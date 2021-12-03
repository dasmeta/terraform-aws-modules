exports.handler = (event, context, callback) => {
    
    //Get contents of response
    const response = event.Records[0].cf.response;
    const headers = response.headers;


    %{ for key, value in custom_headers }
    %{ if value.value != "" }
    headers["${key}"] = [{key: "${value.key}", value: "${value.value}"}];
    %{ endif }
    %{ endfor ~}

    //Return modified response
    callback(null, response);
};
