module aws-cloudfront-security-headers {
    count = var.create_hsts ? 1 : 0
    
    source                  = "dasmeta/modules/aws//modules/aws-cloudfront-security-headers"
    name                    = "${substr(replace(var.aliases[0], ".", "-"), 0, 32)}-security-headers"  
  }
