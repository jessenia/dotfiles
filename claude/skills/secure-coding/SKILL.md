---
name: secure-coding
description: Use when writing or reviewing authentication, authorization, IAM/RBAC, secrets handling, encryption, network exposure, or input validation. Detailed security checklist.
---

# Secure coding

The global no-hardcoded-secrets and no-logging-secrets rules already apply. This skill
adds the review checklist on top of them.

Treat security as a first-class requirement, embedded in each change rather than a final
checklist. Do not weaken authentication, authorization, encryption, logging,
auditability, or validation.

Flag: insecure defaults, overly broad permissions, public exposure, missing TLS, unsafe
deserialization, and missing input validation.

Prefer least privilege for IAM, RBAC, Kubernetes roles, service accounts, and network
policies.

For auth-related code, explicitly consider abuse cases and failure modes.
