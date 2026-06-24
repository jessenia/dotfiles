---
name: debugging
description: Use when diagnosing or fixing a bug. Enforces end-to-end reproduction, root-cause fixes, and regression coverage.
---

# Debugging and bug fixing

Reproduce the bug end-to-end first, as close as possible to how an end user hits it. If
an end-to-end reproduction is not practical, explain why and use the closest realistic
one.

Find the real root cause before fixing. Do not patch symptoms unless you explicitly
document the tradeoff.

Keep the fix focused: do not introduce broad refactors during a bug fix.

After fixing, confirm the original failure no longer occurs, and add or update regression
coverage when practical.
