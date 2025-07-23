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

resource "aws_sns_topic" "ec2_alarms" {
  name = "ec2-status-check-alarms"
}

# Subscribe email to SNS topic
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.ec2_alarms.arn
  protocol  = "email"
  endpoint  = var.notification_email
}