---
# paths: (compiled to wiki/welgo-rules.md — load that instead)
#   - "projects/welgo/**"
compiled_to: wiki/welgo-rules.md
title: Welgo Bookkeeper Review Flow — HARD
date: 2026-05-07
domain: meta
auto_frontmatter: 2026-05-11
---

# Welgo Bookkeeper Review Flow — HARD

**Status:** HARD — locked 2026-04-30
**Bucket:** domain-scoped
**Tier:** T2 — Hard Advisory
**Review-trigger:** When Angela's role changes OR when bookkeeper_agent.py review queue schema changes OR when a new bookkeeper tool ships.

## Failure mode this prevents

Before this rule: flagged QBO transactions sat in a Google Sheet that Angela was supposed to review. No structured workflow. No Slack notification. No Approve/Override/Escalate actions. No daily summary. Angela could not self-serve on ambiguous transactions without emailing Ed. The review queue was a dead end.

After this rule: Angela (bookkeeper) reviews flagged transactions in the Welgo Brain queue. Three actions only. Daily summary in #opco. Escalations go to Ed in structured format. No Google Sheet dependency.

## When this rule fires

- Any code change to `bookkeeper_agent.py` or the review queue schema
- When designing the Slack Block Kit review interface for bookkeeper
- When onboarding Angela (or any successor) to the bookkeeper review workflow
- When a transaction sits in the review queue for more than 48 hours
- When Ed receives a bookkeeper escalation that bypassed the queue

## When this rule does NOT fire (anti-rule)

- Pre-Angela-call (before 2026-04-30). This rule was provisional before then. Now locked.
- QBO sync errors (logged separately per QBO error capture tasks)
- Transactions already approved and posted
- Non-Welgo financial review (personal finances, Kamarooms)

## What Claude does

### The three-action contract

Every flagged transaction in the bookkeeper review queue has exactly three actions:

| Action | When | Who | What happens |
|---|---|---|---|
| Approve | Transaction category looks correct | Angela | Marked resolved, posted to QBO as-is |
| Override | Angela wants a different category | Angela | Selects correct category from picklist, re-posted |
| Escalate to Ed | Angela is unsure | Angela | Structured message to Ed in #opco with transaction + Angela's question |

No fourth action. No freeform comment without an action. No "I'll get back to this."

### Slack Block Kit interface (design contract)

The Welgo Brain sends a daily batch digest per flagged transactions (not per transaction). Format:

```
*Bookkeeper Review — <date>*
[thread]
Transaction: [vendor] $[amount] on [date]
Current category: [category]
Why flagged: [reason from bookkeeper_agent]
[ Approve ] [ Override ] [ Escalate to Ed ]
```

Block Kit buttons trigger a webhook back to Welgo Brain. The webhook updates the transaction record in QBO and logs to `events.jsonl` with `kind: bookkeeper_review_action`.

### Daily summary in #opco

Each day at EOD, Welgo Brain posts to #opco (parent = bold label only, content in thread per slack-thread-pattern rule):

```
*Bookkeeper Daily Summary — <date>*
[thread]
Reviewed: N transactions
  Approved: X
  Overridden: Y
  Escalated to Ed: Z
Pending (>24h): [list if any]
```

### Escalation format

```
Escalation from Angela:
Transaction: [vendor] $[amount] on [date]
Current category: [category]
Angela's question: [verbatim]
Link: [QBO transaction URL]
```

### Events.jsonl capture

Every review action appends:
```json
{
  "ts": "<ISO>",
  "source": "bookkeeper_agent",
  "kind": "bookkeeper_review_action",
  "payload": {
    "transaction_id": "<QBO id>",
    "action": "approve | override | escalate",
    "reviewer": "angela",
    "original_category": "<str>",
    "new_category": "<str or null>",
    "escalation_note": "<str or null>"
  }
}
```

### Stale queue check

Any transaction in the review queue more than 48 hours without an action:
- Morning briefing surfaces it: "N transactions stale in bookkeeper queue."
- If Angela is unreachable more than 72 hours: Ed receives direct escalation via #opco.
- Stale threshold configurable in Welgo Brain config (default: 48h).

## Related rules

- `~/life-os/.claude/rules/operator-code-authority.md` — Angela's in-scope authority for Approve/Override; Escalate routes to Ed
- `~/life-os/.claude/rules/operator-access-infrastructure.md` — Angela must have bearer token and tunnel access before this flow goes live
- `~/.claude/rules/slack-thread-pattern.md` — daily digest uses parent-label + thread pattern
- `~/.claude/rules/ai-agentic-workflow-architecture.md` — events.jsonl append-only, review actions logged with kind + payload
- `~/life-os/.claude/rules/welgo-operator-enablement.md` — parent architecture; bookkeeper review flow is a Layer 2 spec-first artifact

## Why this exists (provenance)

Locked 2026-04-30 after Angela bookkeeper onboarding call. Angela confirmed role and reviewed the Notion onboarding doc (https://app.notion.com/p/353dc12c53e081279f09d9cfa3e633b8). The Google Sheet review flow was identified as the bottleneck. Slack Block Kit Approve/Override buttons are a 3hr build item captured as a Tier A task. This rule governs what that build must satisfy.
