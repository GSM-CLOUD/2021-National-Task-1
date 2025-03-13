variable "region" {
  default = "ap-northeast-2"
}

variable "awscli_profile" {
  default = "second-profile"
}

variable "prefix" {
  default = "wsi"
}

variable "bucket_frontend_name" {
  default = "wsi-99-gsm9-web-static"
}

variable "bucket_backend_name" {
  default = "wsi-99-gsm9-artifactory"
}

variable "log_group_name" {
  default = "/aws/ec2/wsi"
}

variable "log_group_path" {
  default = "/var/log/app/app.log"
}