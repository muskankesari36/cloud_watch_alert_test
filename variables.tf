variable "ec2_instance_ids" {
  type    = list(string)
  default = [] 
}

variable "notification_email" {
  type    = string
  default = ""
}

variable "cpu_threshold" {
  type = number
}

variable "evaluation_periods" {
  type = number
}

variable "datapoints_to_alarm" {
  type = number
}

variable "period" {
  default = 60 # seconds
}