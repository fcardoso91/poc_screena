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