module "this" {
  source = "../"
  name   = "X-Frame-Options"
  security_headers = {
    frame_options = "DENY"
  }
}
