variable "ec2_instance_ids" {
  type    = list(string)
  default = [] 
}

variable "notification_email" {
  type    = string
  default = ""
}

variable "cpu_threshold" {
  default = 85
}

variable "evaluation_periods" {
  default = 5
}

variable "datapoints_to_alarm" {
  default = 3
}

variable "period" {
  default = 60 # seconds
}