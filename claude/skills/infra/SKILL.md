---
name: infra
description: Use when editing Terraform, Kubernetes, AWS, Docker, or CI/CD configuration. Covers convention inspection, validation workflow, and change-safety disclosures.
---

# Infrastructure changes

The global safety guardrails (no destructive commands; confirm before changing state
backends, provider versions, cluster contexts, namespaces, or deploy targets) already
apply. This skill adds the domain workflow on top of them.

Inspect current conventions before editing. Prefer idempotent changes.
Do not touch production-facing configuration casually.

Terraform: run `terraform fmt`, `terraform validate`, and `terraform plan` when safe and
configured. Review the plan before suggesting apply.

Kubernetes: state the target namespace and context assumptions before applying anything.

IAM and RBAC: prefer least privilege. Avoid broad IAM wildcards unless justified.
