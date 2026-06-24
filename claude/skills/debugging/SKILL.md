---
name: debugging
description: Use when diagnosing or fixing a bug. Covers reproducing the failure end-to-end, finding the real root cause, validating the fix, and adding regression coverage.
---

# Debugging and bug fixing

Start by reproducing the bug in an end-to-end setting that is as close as possible to how an end user experiences it.

Find the real root cause before making the fix.
Do not patch symptoms unless you explicitly document the tradeoff.

Make sure the fix directly addresses the reproduced failure.
After fixing, validate that the original failure no longer occurs.
Add or update regression coverage when practical.

If an end-to-end reproduction is not practical, explain why and use the closest realistic reproduction available.

Do not introduce broad refactors during a focused bug fix.
Treat flaky tests as real engineering problems unless proven otherwise.
When a test or lint fails, determine whether the cause is the current change, the environment, or a pre-existing issue.
