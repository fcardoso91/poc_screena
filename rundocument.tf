resource "aws_ssm_document" "rebuild-rpm" {
  name            = "rebuild-rpm"
  document_type   = "Command"
  document_format = "YAML"

  tags = {
    "Name" = "rebuild-rpm"
  }

  content = <<DOC
---
schemaVersion: '2.2'
description: "Rebuild RPM Database and clean YUM cache"
mainSteps:
  - action: aws:runShellScript
    name: rebuildRPMDatabase
    inputs:
      runCommand:
        - mkdir -p /var/lib/rpm/backup
        - cp -a /var/lib/rpm/__db* /var/lib/rpm/backup/
        - rm -f /var/lib/rpm/__db.[0-9][0-9]*
        - rpm --quiet -qa
        - rpm --rebuilddb
        - yum clean all

DOC
}