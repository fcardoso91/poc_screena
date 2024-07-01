
resource "aws_ssm_maintenance_window" "crontab_rebuild_rpm" {
  name               = "crontab-rebuild-rpm"
  schedule           = "cron(0 05 09 ? * * *)"
  duration           = 1
  cutoff             = 0
  allow_unassociated_targets = true
  description        = "crontab rebuild rpm AWS Maintenance Window"
}

resource "aws_ssm_maintenance_window_target" "crontab_rebuild_rpm_target" {
  window_id = aws_ssm_maintenance_window.crontab_rebuild_rpm.id
  name      = "crontab-rebuild-rpm-target"
  description = "Target EC2 Linux"
  resource_type = "INSTANCE"

  targets {
    key    = "InstanceIds"
    values = ["i-012ea0bb7348e4fa4"]
  }
}

resource "aws_ssm_maintenance_window_task" "crontab_rebuild_rpm_task" {
  window_id         = aws_ssm_maintenance_window.crontab_rebuild_rpm.id
  name              = "rebuild-rpm"
  description       = "Rebuild RPM Database and clean YUM cache"
  service_role_arn  = "arn:aws:iam::652749460913:role/CustomRoleForMaintenance"
  task_type         = "AUTOMATION"
  priority          = 1
  max_concurrency   = "2"
  max_errors        = "1"

  task_arn          = "rebuild-rpm"
  targets {
    key    = aws_ssm_maintenance_window_target.crontab_rebuild_rpm.targets.key
    values = aws_ssm_maintenance_window_target.crontab_rebuild_rpm.targets.values
    }
}