/**
 * # Why
 * Create S3 bucket for CloudTrail and lambda to push data to CloudWatch
 * 
 * ## Examples
 * Minimal Setup
 * ```terraform
 * module "cloudtrail-s3-to-cloudwatch-minimal" {
 *   source  = "dasmeta/modules/aws//modules/cloudtrail-s3-to-cloudwatch"
 *   version = "0.32.0"
 *
 *   bucket_name                    = "cloudtrail-log-bucket"
 *   create_lambda_s3_to_cloudwatch = true
 *   // If you want access another account to write bucket you can set account id , if you use cloudtrail and s3 bucket same account you shouldn't set this variable
 *   account_id                     = "56**168"
 *   cloudtrail_name                = "cloudtrail"
 * }
 * ```
 * Disable Lambda - just bucket
 * ```terraform
 * module "cloudtrail-s3-to-cloudwatch-no-lambda" {
 *   source  = "dasmeta/modules/aws//modules/cloudtrail-s3-to-cloudwatch"
 *   version = "0.32.0"
 *
 *   bucket_name                    = "cloudtrail-log-bucket"
 *   cloudtrail_name                = "cloudtrail"
 *   create_lambda_s3_to_cloudwatch = false
 * }
 * ```
 * Different AWS Account (cross account log streaming)
 * ```terraform
 * module "cloudtrail-s3-to-cloudwatch-different-account" {
 *   source  = "dasmeta/modules/aws//modules/cloudtrail-s3-to-cloudwatch"
 *   version = "0.32.0"
 *
 *   bucket_name                    = "cloudtrail-log-bucket"
 *   cloudtrail_name                = "cloudtrail"
 *   account_id                     = "56**168"
 * }
 * ```
 */
