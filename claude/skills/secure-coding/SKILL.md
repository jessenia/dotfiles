---
name: secure-coding
description: Use when writing or reviewing authentication, authorization, IAM/RBAC, secrets handling, encryption, network exposure, or input validation. Detailed security checklist.
---

# Secure coding

Treat security as a first-class requirement, embedded in each change rather than a final checklist.

Do not weaken authentication, authorization, encryption, logging, auditability, or validation.
Do not introduce hardcoded secrets, tokens, passwords, API keys, private keys, or credentials.
Do not log secrets or sensitive payloads.

Prefer least privilege for IAM, RBAC, Kubernetes roles, service accounts, and network policies.

Flag insecure defaults, overly broad permissions, public exposure, missing TLS, unsafe deserialization, and missing input validation.

For auth-related code, explicitly consider abuse cases and failure modes.
