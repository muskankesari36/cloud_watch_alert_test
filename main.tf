# System Check Alarm
resource "aws_cloudwatch_metric_alarm" "system_check_alarm" {
  for_each = toset(var.ec2_instance_ids)

  alarm_name          = "SystemCheckFailed-${each.key}"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  statistic           = "Maximum"
  period              = 300
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  dimensions = {
    InstanceId = each.key
  }

  alarm_description = "System status check failed for ${each.key}"
  alarm_actions     = [aws_sns_topic.system_alerts.arn]
  ok_actions        = [aws_sns_topic.system_alerts.arn]
}

# Instance Check Alarm
resource "aws_cloudwatch_metric_alarm" "instance_check_alarm" {
  for_each = toset(var.ec2_instance_ids)

  alarm_name          = "InstanceCheckFailed-${each.key}"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  statistic           = "Maximum"
  period              = 300
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  dimensions = {
    InstanceId = each.key
  }

  alarm_description = "Instance status check failed for ${each.key}"
  alarm_actions     = [aws_sns_topic.instance_alerts.arn]
  ok_actions        = [aws_sns_topic.instance_alerts.arn]
}

# System Check SNS
resource "aws_sns_topic" "system_alerts" {
  name = "ec2-system-check-alerts"
}

resource "aws_sns_topic_subscription" "system_email" {
  topic_arn = aws_sns_topic.system_alerts.arn
  protocol  = "email"
  endpoint  = var.system_check_email
}

# Instance Check SNS
resource "aws_sns_topic" "instance_alerts" {
  name = "ec2-instance-check-alerts"
}

resource "aws_sns_topic_subscription" "instance_email" {
  topic_arn = aws_sns_topic.instance_alerts.arn
  protocol  = "email"
  endpoint  = var.instance_check_email
}
