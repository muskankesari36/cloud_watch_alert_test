variable "ec2_instance_ids" {
  type    = list(string)
  default = [] 
}

variable "system_check_email" {
  type    = string
  default = ""
}

variable "instance_check_email" {
  type    = string
  default = ""
}