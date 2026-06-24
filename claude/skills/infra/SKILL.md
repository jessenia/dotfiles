---
name: infra
description: Use when editing Terraform, Kubernetes, AWS, Docker, or CI/CD configuration. Covers convention inspection, validation workflow, and change-safety disclosures.
---

# Infrastructure changes

Inspect current conventions before editing. Prefer idempotent changes.

Do not touch production-facing configuration casually.
Do not change state backends, provider versions, cluster contexts, namespaces, or deployment targets without explicit confirmation.

Terraform: prefer `terraform fmt`, `terraform validate`, and `terraform plan` when safe and configured.
Review the plan before suggesting apply.

Kubernetes: show namespace and context assumptions before applying anything.

IAM and RBAC: prefer least privilege. Avoid broad IAM wildcards unless justified.

Never run `terraform destroy`, `kubectl delete`, or destructive cloud commands unless explicitly requested.
