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
  alarm_actions = [aws_sns_topic.ec2_alerts.arn]
  ok_actions        = [aws_sns_topic.ec2_alerts.arn]
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
  alarm_actions = [aws_sns_topic.ec2_alerts.arn]
  ok_actions        = [aws_sns_topic.ec2_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  for_each = toset(var.ec2_instance_ids)

  alarm_name          = "HighCPU-${each.value}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "CPU Utilization > ${var.cpu_threshold}% for ${var.datapoints_to_alarm} out of ${var.evaluation_periods} minutes for instance ${each.value}"
  alarm_actions = [aws_sns_topic.ec2_alerts.arn]
  dimensions = {
    InstanceId = each.value
  }
  datapoints_to_alarm = var.datapoints_to_alarm
  treat_missing_data  = "notBreaching"
}


resource "aws_sns_topic" "ec2_alerts" {
  name = "ec2-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.ec2_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
