output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.poc_screena.address
  sensitive   = false
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.poc_screena.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance postgres username"
  value       = aws_db_instance.poc_screena.username
  sensitive   = true
}

output "client_passwd" {
  description = "rds ec2 client instance password"
  value       = aws_instance.poc_screena.password_data
  sensitive   = false
}

output "aws_ssm_maintenance_window_target_key" {
  value       = aws_ssm_maintenance_window_target.crontab_rebuild_rpm.targets[0].key
  sensitive   = false
}

output "aws_ssm_maintenance_window_target_values" {
  value       = aws_ssm_maintenance_window_target.crontab_rebuild_rpm.targets[0].values
  sensitive   = false
}