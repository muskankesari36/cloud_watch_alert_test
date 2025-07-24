# Create CloudWatch alarms for each instance - System Status Check
resource "aws_cloudwatch_metric_alarm" "system_check" {
  for_each = toset(var.ec2_instance_ids)

  alarm_name          = "SystemCheckFailed-${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "System status check failed for instance ${each.key}"
  dimensions = {
    InstanceId = each.key
  }
  alarm_actions = [aws_sns_topic.ec2_alarms.arn]
  ok_actions    = [aws_sns_topic.ec2_alarms.arn]
}

# Create CloudWatch alarms for each instance - Instance Status Check
resource "aws_cloudwatch_metric_alarm" "instance_check" {
  for_each = toset(var.ec2_instance_ids)

  alarm_name          = "InstanceCheckFailed-${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Instance status check failed for instance ${each.key}"
  dimensions = {
    InstanceId = each.key
  }
  alarm_actions = [aws_sns_topic.ec2_alarms.arn]
  ok_actions    = [aws_sns_topic.ec2_alarms.arn]
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
