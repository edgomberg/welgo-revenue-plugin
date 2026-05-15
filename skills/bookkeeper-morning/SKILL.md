---
name: bookkeeper-morning
description: Angela's morning briefing for the bookkeeper role. Pulls today's flagged QBO transactions, overdue review items from the prior day, and any escalation Ed sent overnight. Triggers on /bookkeeper-morning, "morning briefing", "what's on my plate", or auto-fires once per day at first session start. Use when Angela starts her day or returns from a break of more than 4 hours.
---

# bookkeeper-morning

Daily start-of-day surface for the bookkeeper queue.

## Steps

1. Call `welgo_brain_list_tasks` filter `bookkeeper_review`, count items.
2. Call `welgo_brain_list_tasks` filter `bookkeeper_review` AND `overdue=true`, surface separately.
3. Call `welgo_brain_search_comms` for any Ed-to-Angela DM in last 24h containing escalation keywords (urgent, asap, review, override, vendor).
4. Print a one-screen summary:
   - Today's flagged count
   - Overdue from yesterday count + list
   - Ed's escalations (if any)
   - Suggested order: overdue first, then today's, then escalations
5. Ask "ready to start with overdue?"

## Constraints

- Plain English only. No tech jargon.
- One question at a time per coaching-pace rule.

## Related

- Skill: `qbo-categorize` (the action skill this briefing routes into)
- Rule: `welgo-bookkeeper-review-flow`
