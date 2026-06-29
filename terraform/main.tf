# ============================================================
# terraform/main.tf
# Task 2 — Infrastructure Provisioning (local provider)
#
# What this does:
#   - Creates ./simulated_server/ directory
#   - Creates ./simulated_server/logs/ subdirectory
#   - Creates ./simulated_server/config/ subdirectory
#   - Generates system_state.json inside config/
#
# HOW TO USE:
#   cd terraform/
#   terraform init
#   terraform apply
#   terraform destroy   ← Tears everything down cleanly
# ============================================================

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# ── REQUIREMENT 1 ─────────────────────────────────────────────
# Use the local provider (no cloud, no credentials needed)
provider "local" {}

# ── Create the base simulated_server directory ────────────────
# Terraform's local provider doesn't have a "directory" resource,
# so we create a hidden placeholder file to force the folder to exist.
resource "local_file" "logs_placeholder" {
  filename        = "${path.module}/../simulated_server/logs/.gitkeep"
  content         = "# This file ensures the logs/ directory is tracked by Terraform state.\n"
  file_permission = "0644"
}

resource "local_file" "config_placeholder" {
  filename        = "${path.module}/../simulated_server/config/.gitkeep"
  content         = "# This file ensures the config/ directory is tracked by Terraform state.\n"
  file_permission = "0644"
}

# ── REQUIREMENT 1 — Generate system_state.json ────────────────
# Written into ./simulated_server/config/
resource "local_file" "system_state" {
  filename        = "${path.module}/../simulated_server/config/system_state.json"
  file_permission = "0644"

  content = jsonencode({
    environment = "local_dev"
    status      = "provisioned"
    provisioned_by = "Terraform"
    provider    = "hashicorp/local"
  })
}

# ── Outputs: confirm what was created ─────────────────────────
output "logs_directory" {
  value       = "${path.module}/../simulated_server/logs/"
  description = "Path to the logs directory created by Terraform"
}

output "config_directory" {
  value       = "${path.module}/../simulated_server/config/"
  description = "Path to the config directory created by Terraform"
}

output "system_state_file" {
  value       = local_file.system_state.filename
  description = "Path to the generated system_state.json"
}
