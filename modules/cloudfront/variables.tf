variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the distribution is enabled to accept end user requests for content."
}

variable "is_ipv6_enabled" {
  type        = bool
  default     = true
  description = "Whether the IPv6 is enabled for the distribution."
}

variable "price_class" {
  type        = string
  default     = "PriceClass_All"
  description = "The price class for this distribution."
}

variable "retain_on_delete" {
  type        = bool
  default     = false
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform."
}

variable "tags_name" {
  type        = string
  default     = "terraform testing by Vika"
}

variable "wait_for_deployment" {
  type        = bool
  default     = true
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed."
}

variable "ordered_allowed_methods_1" {
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  description = "Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin."
}

variable "ordered_cached_methods_1" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = "Controls whether CloudFront caches the response to requests using the specified HTTP methods."
}

variable "ordered_compress_1" {
  type        = bool
  default     = true
  description = "Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header."
}

variable "ordered_default_ttl_1" {
  type        = number
  default     = 0
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header."
}

variable "ordered_max_ttl_1" {
  type        = number
  default     = 0
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated."
}

variable "ordered_min_ttl_1" {
  type        = number
  default     = 0
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated."
}

variable "ordered_smooth_streaming_1" {
  type        = bool
  default     = false
  description = "Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior."
}

variable "ordered_viewer_protocol_policy_1" {
  type        = string
  default     = "redirect-to-https"
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https."
}

variable "ordered_allowed_methods_2" {
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "ordered_cached_methods_2" {
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "ordered_compress_2" {
  type        = bool
  default     = true
}

variable "ordered_default_ttl_2" {
  type        = number
  default     = 0
}

variable "ordered_max_ttl_2" {
  type        = number
  default     = 0
}

variable "ordered_min_ttl_2" {
  type        = number
  default     = 0
}

variable "ordered_smooth_streaming_2" {
  type        = bool
  default     = false
}

variable "ordered_viewer_protocol_policy_2" {
  type        = string
  default     = "redirect-to-https"
}

variable "connection_attempts_1" {
  type        = number
  default     = 3
  description = "The number of times that CloudFront attempts to connect to the origin."
}

variable "connection_timeout_1" {
  type        = number
  default     = 10
  description = "The number of seconds that CloudFront waits when trying to establish a connection to the origin."
}

variable "http_port" {
  type        = number
  default     = 80
  description = "The HTTP port the custom origin listens on."
}

variable "https_port" {
  type        = number
  default     = 443
  description = "The HTTPS port the custom origin listens on."
}

variable "origin_keepalive_timeout" {
  type        = number
  default     = 5
  description = "The Custom KeepAlive timeout, in seconds."
}

variable "origin_protocol_policy" {
  type        = string
  default     = "http-only"
  description = "The origin protocol policy to apply to your origin."
}

variable "origin_read_timeout" {
  type        = number
  default     = 30
  description = "The Custom Read timeout, in seconds."
}

variable "origin_ssl_protocols" {
  type        = list(string)
  default     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS."
}

variable "connection_attempts_2" {
  type        = number
  default     = 3
}

variable "connection_timeout_2" {
  type        = number
  default     = 10
}

variable "restriction_type" {
  type        = string
  default     = "none"
  description = "The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist."
}

variable "cloudfront_default_certificate" {
  type        = bool
  default     = true
  description = "true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution."
}

variable "minimum_protocol_version" {
  type        = string
  default     = "TLSv1"
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
}
