variable "db_password" {
  description = "RDS postgres user password"
  type        = string
  sensitive   = true
}