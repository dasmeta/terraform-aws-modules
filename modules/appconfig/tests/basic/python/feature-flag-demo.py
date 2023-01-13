from datetime import datetime, timedelta
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from string import Template
import webbrowser
import boto3

WEBSERVER_PORT = 8080
APPCONFIG_APPLICATION_NAME = "FeatureFlagPoC"
APPCONFIG_CONFIG_PROFILE_NAME = "CheckoutProfile"
APPCONFIG_ENVIRONMENT_NAME = "Development"
AWS_REGION = "eu-central-1"

cached_config_data = {}
cached_config_token = None
cached_token_expiration_time = None


def get_config():
    global cached_config_token
    global cached_config_data
    global cached_token_expiration_time
    appconfigdata = boto3.client("appconfigdata", region_name=AWS_REGION)

    # If we don't have a token yet, call start_configuration_session to get one
    if not cached_config_token or datetime.now() >= cached_token_expiration_time:
        start_session_response = appconfigdata.start_configuration_session(
            ApplicationIdentifier=APPCONFIG_APPLICATION_NAME,
            EnvironmentIdentifier=APPCONFIG_ENVIRONMENT_NAME,
            ConfigurationProfileIdentifier=APPCONFIG_CONFIG_PROFILE_NAME,
        )
        cached_config_token = start_session_response["InitialConfigurationToken"]

    get_config_response = appconfigdata.get_latest_configuration(
        ConfigurationToken=cached_config_token
    )
    # Response always includes a fresh token to use in next call
    cached_config_token = get_config_response["NextPollConfigurationToken"]
    # Token will expire if not refreshed within 24 hours, so keep track of
    # the expected expiration time minus a bit of padding
    cached_token_expiration_time = datetime.now() + timedelta(hours=23, minutes=59)
    # 'Configuration' in the response will only be populated the first time we
    # call GetLatestConfiguration or if the config contents have changed since
    # the last time we called. So if it's empty we know we already have the latest
    # config, otherwise we need to update our cache.
    content = get_config_response["Configuration"].read()
    if content:
        try:
            cached_config_data = json.loads(content.decode("utf-8"))
            print("received new config data:", cached_config_data)
        except json.JSONDecodeError as error:
            raise ValueError(error.msg) from error

    return cached_config_data


def get_html():
    # For simplicity this code fetches a fresh config from AppConfig every time a page is served.
    # In an actual application in most cases you would want to poll AppConfig in the background
    # and cache the results.
    config = get_config()
    allow_bitcoin_flag = config["allow-bitcoin-at-checkout"]

    if allow_bitcoin_flag["enabled"]:
        dropdown_display_css = "initial"
        default_currency = allow_bitcoin_flag["default-currency"]
        bitcoinDiscountPercentage = allow_bitcoin_flag["bitcoin-discount-percentage"]
        bitcoinDiscountEndDate = allow_bitcoin_flag.get("bitcoin-discount-end-date", "")
    else:
        default_currency = "USD"
        dropdown_display_css = "none"
        bitcoinDiscountPercentage = 0
        bitcoinDiscountEndDate = ""

    if bitcoinDiscountEndDate:
        discountEndDatetime = datetime.strptime(bitcoinDiscountEndDate, "%m/%d/%Y")
        if datetime.today() > discountEndDatetime:
            bitcoinDiscountPercentage = 0

    usd_selected = "selected='selected'" if default_currency == "USD" else ""
    btc_selected = "selected='selected'" if default_currency == "BTC" else ""

    html_template = """
<html>
<head>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type">
    <meta content="utf-8" http-equiv="encoding">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap" rel="stylesheet">
    <style>
        h1 {
            font-family: 'Bebas Neue', cursive;
        }
        .cart {
            width: 350px;
            background-color: rgb(210, 221, 231);
            border-radius: 10px;
            padding: 0px 10px 10px 10px;
            border: 1px solid lightgrey;
        }
        .right {
            float: right;
        }
        #currency {
            margin-right: 5px;
            display: $dropdownDisplayCSS;
        }
    </style>
    <title>AppConfig Feature Flag Demo Checkout Page</title>
</head>
<body onload="dropdownChanged()">
    <h1>FooBar Premium Plan Checkout</h1>
    <div class="cart">
        <h4>Shopping Cart</h4>
        FooBar Premium <span class="right price"></span>
        <hr>
        <p id="btc-discount">
            <i>
                <small>Early adopter discount, order using BTC by $bitcoinDiscountEndDate</small>
                <span class="right">$bitcoinDiscountPercentage%</span>
            </i>
        </p>
        <b>Total:</b>
            <span class="right">
                <select name="currency" id="currency" onchange="dropdownChanged()" autocomplete="off">
                    <option value="USD" $usdSelected>USD</option>
                    <option value="BTC" $btcSelected>BTC</option>
                </select>
                <span class="total"></span>
            </span>
    </div>
</body>
<script>
    function dropdownChanged() {
        currency = "USD"
        if ('$dropdownDisplayCSS' !== 'none') {
            currency = document.getElementById("currency").value;
        }
        if (currency === "USD") {
            currencySymbol="$$";
            price = 450;
        } else {
            currencySymbol="₿";
            price = 0.000026;
        }
        discount=$bitcoinDiscountPercentage;
        if (discount && currency === "BTC") {
            total = price - (price*discount/100);
            total = total.toFixed(6);
            document.getElementById("btc-discount").style.display = 'inherit';
        } else {
            total = price;
            document.getElementById("btc-discount").style.display = 'none';
        }
        document.querySelectorAll(".price").forEach(txt => { txt.textContent = currencySymbol+price; })
        document.querySelectorAll(".total").forEach(txt => { txt.textContent = currencySymbol+total; })
    }
</script>
</html>
    """
    html = Template(html_template).substitute(
        dropdownDisplayCSS=dropdown_display_css,
        usdSelected=usd_selected,
        btcSelected=btc_selected,
        bitcoinDiscountPercentage=bitcoinDiscountPercentage,
        bitcoinDiscountEndDate=bitcoinDiscountEndDate,
    )
    return html


class SimpleCheckoutPageWebServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes(get_html(), "utf-8"))


if __name__ == "__main__":
    hostname = "localhost"
    webServer = HTTPServer((hostname, WEBSERVER_PORT), SimpleCheckoutPageWebServer)
    url = f"http://{hostname}:{WEBSERVER_PORT}"
    print(f"Local webserver started. To view, navigate your browser to: {url}")
    webbrowser.open(url, new=2)
    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass
    webServer.server_close()
