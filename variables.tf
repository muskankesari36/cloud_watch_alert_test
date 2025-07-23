variable "ec2_instance_ids" {
  type    = list(string)
  default = [] 
}

variable "notification_email" {
  type    = string
  default = "" 
}