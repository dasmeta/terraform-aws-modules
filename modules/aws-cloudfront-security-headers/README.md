# Add HTTP security headers
**CloudFront Functions event type: viewer response**
Terraform module to create a Lambda@Edge function to add best practice security headers and support HSTS preload requirements.

- [Creating a Simple Lambda@Edge Function](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-how-it-works-tutorial.html)

## Dy default it will set the following headers:
```hcl
{ key = "Server", value = "CloudFront" }
{ key = "Strict-Transport-Security", value = "max-age=63072000; includeSubdomains; preload" }
{ key = "Content-Security-Policy", value = "default-src 'self' 'unsafe-inline' 'unsafe-eval' https: http: data: wss:" }
{ key = "X-Content-Type-Options", value = "nosniff" }
{ key = "X-Frame-Options", value = "DENY" }
{ key = "X-XSS-Protection", value = "1; mode=block" }
{ key = "Referrer-Policy", value = "same-origin" }
{ key = "Feature-Policy", value = "microphone 'none'; camera 'none'" }
{ key = "Permissions-Policy", value = "camera=(), microphone=()" }
```
## you can disable any default header or add you custom ones by using `override_custom_headers` variable

# Usage

**IMPORTANT:** Make sure that you’re in the US-East-1 (N. Virginia) Region (us-east-1). You must be in this Region to create Lambda@Edge functions.

# Sample 1
## Step 1: Create a Lambda@Edge using a module `aws-cloudfront-security-headers`

```hcl

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

module aws-cloudfront-security-headers {
    source                  = "dasmeta/modules/aws//modules/aws-cloudfront-security-headers"
    version                 = "0.19.6"
    name                    = "CloudFront-Add-HSTS-Header"

    providers = {
    aws = aws.east
  }

}

```
## Step 2: Add a CloudFront Trigger to Run the Function
Now that you have a Lambda function to update security headers, configure the CloudFront trigger to run your function to add the headers in any response that CloudFront receives from the origin for your distribution.

![Add a CloudFront Trigger to Run the Function](https://github.com/dasmeta/terraform-aws-modules/blob/main/modules/aws-cloudfront-security-headers/cloudfront.gif)


# Sample 2

## the following sample will create lambda@edge with config override:
 - override default `Server` header with custom one
 - disable default `x-frame-options` header
 - have an additional `Cross-Origin-Embedder-Policy` header

```hcl

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

module aws-cloudfront-security-headers {
    source                  = "dasmeta/modules/aws//modules/aws-cloudfront-security-headers"
    version                 = "0.19.6"

    name                    = "CloudFront-Add-HSTS-Header"

    providers = {
    aws = aws.east
  }

  override_custom_headers = {
     server = { key = "Server", value = "CloudFront1" }
     x-frame-options = { key = "X-FRAME-OPTIONS", value = "" }
     cross-origin-embedder-policy = { key = "Cross-Origin-Embedder-Policy", value = "(unsafe-none|require-corp); report-to='default'" }
  }
}

```
