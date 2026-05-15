---
name: qbo-categorize
description: Review and categorize flagged QuickBooks Online transactions in the Welgo Brain bookkeeper queue. Triggers on /qbo-categorize, "review queue", "categorize transactions", "flagged QBO", "bookkeeper queue", or auto-fires when Angela's session starts and queue has 5+ items. Use when Angela needs to clear the daily bookkeeper review queue with one of three actions per transaction. Even if Angela casually asks "anything in the queue", invoke this skill first.
---

# qbo-categorize

Clear the bookkeeper review queue. One transaction at a time. Three actions only per the welgo-bookkeeper-review-flow rule.

## Steps

1. Call `welgo_brain_list_tasks` with `filter=bookkeeper_review` to pull all pending items.
2. For each transaction, surface:
   - Vendor + amount + date
   - Current category
   - Why flagged (the reason from bookkeeper_agent)
   - Three options: Approve / Override (pick new category) / Escalate to Ed
3. Wait for Angela's pick per transaction. Do not batch.
4. Send the action back via `welgo_brain_update_task` with the result.
5. After all items resolved, post a daily summary to `#finance_legal_accounting_cashflow` per the welgo-bookkeeper-review-flow rule format.

## Constraints

- No fourth action. No "I'll get back to this later".
- Override above $1,000 must auto-route to Escalate per CFO-SCOPE.
- Every action logs to events.jsonl as `bookkeeper_review_action`.

## Related

- Rule: `welgo-bookkeeper-review-flow`
- Tool: `welgo_brain_list_tasks`, `welgo_brain_update_task`
