---
paths:
  - "**/projects/welgo/**"
  - "**/projects/personal-finances/**"
  - "**/.claude/skills/welgo-cash-*/**"
  - "**/.claude/skills/welgo-bookkeeper-*/**"
  - "**/.claude/skills/fin*/**"
title: Financial Delegation — Finance Channel + COO CC
date: 2026-05-11
domain: welgo
status: hard
---

# Financial Delegation — Finance Channel + COO CC — HARD

**Status:** HARD locked 2026-05-11 (promoted from `feedback-financial-asks-finance-channel-plus-dm.md`)
**Bucket:** advisory
**Tier:** T2 — Hard Advisory (T1 candidate via PreToolUse hook on `slack_send_message` when body matches financial-keyword regex + recipient is Welgo finance team)
**Review-trigger:** When a new finance operator joins OR if Ed corrects channel routing 1+ more time after lock.

## Failure mode this prevents

Financial-task delegations (bookkeeper reviews, expense audits, QBO cleanups, transfer asks, payment-status questions) routed to `#opco` or operator DMs bypass Sese (COO). Result:

1. Sese (who now owns operations + reports for ALL financial tasks per role-card v2026-05-11) loses visibility on what's been delegated to Angela / Tom / Jes on the money side
2. Multiple operators duplicate effort on same audit when channel is fragmented
3. Audit trail scattered across DMs — no single channel to compile monthly review
4. Ed becomes informational bottleneck reposting finance asks to Sese

Tonight's incident (2026-05-11 09:18 MST) triggered the promotion: Era stale-tx investigation surfaced 39 alleged bounces; instinct was to DM Angela direct. Sese org-chart confirmation 2026-05-11 placed ALL finance tasks under COO. Direct DM bypasses the chain.

## When this rule fires

Before any delegation, ask, or review post to a Welgo team member about:
- QBO transactions / categorization / cleanup
- Bookkeeper queue reviews
- Bank reconciliation
- Expense audits / cuts / vendor reviews
- Payment status (failed, pending, returned, bounced)
- Transfer requests (operator-initiated or operator-questioning)
- Recurring vendor analysis
- Software / SaaS spend audits
- Tax / 1099 / W9 prep
- Plaid / Era / Mercury / Revolut sync issues
- Any task touching `WELGO_FINANCIAL_CONTEXT.md` 7-account map

Recipients in scope: Angela, Tom, Jes, future finance ops, vendors (CPA Priya).

## When this rule does NOT fire (anti-rule)

- Ed-personal finance work (personal Plaid, personal Mercury, personal Revolut Business) — separate domain
- Pure data pulls (no operator action requested) — Era / Welgo Brain MCP query, not a delegation
- Hostaway / Airbnb / VRBO non-financial revenue ops (Tom's revenue scope, not finance)
- One-time vendor contracts already approved (G4 already passed)
- Emergency (account frozen, fraud, security event) — Ed handles direct + emergency channel
- Read-only "what's the balance" questions — answer in chat, no delegation needed

## What Claude does

### Channel routing (locked)

ALL Welgo financial delegations:
- Primary: post to `#finance_legal_accounting_cashflow` Slack channel (Welgo workspace)
- CC: tag Sese `<@U0850GZKNCS>` in the parent post for COO visibility, even if she isn't doing the work
- DM (operator notification): send DM to operator with channel link + one-line summary; main thread stays in channel for transparency

NEVER post Welgo financial delegations to:
- `#opco` (general ops, wrong scope per `feedback-financial-asks-finance-channel-plus-dm.md`)
- Operator DM alone (Sese loses visibility)
- `#gsm-welgo` (front-desk ops, wrong scope)
- `#cs_cashflow_accounting` (Sese's daily snapshot channel — read-only output, not delegation channel)

### Parent post format

Per `slack-thread-pattern.md` + `delegation-must-at-mention-recipient.md`:

```
*<@OPERATOR_ID> — <Operator Name>: <task summary> (<deliverable count>-part)*
```

Body in thread. CC tag in thread reply 1 (visibility, not action). Deadline + fallback in thread reply N per `explain-vs-commit-ask.md`.

### Pre-send shift gate

Per `delegation-shift-and-load-precheck.md`: check operator local time + load BEFORE send. Manila operators (Angela, Sese, Jes): only send 09:00-21:00 Manila time. Outside window: hold draft, schedule send for next on-shift block.

### Audit trail

Every send appends `events.jsonl`:
```json
{"ts":"<iso>","source":"financial-delegation","kind":"finance_delegation_sent","payload":{"channel":"#finance_legal_accounting_cashflow","operator":"<id>","cc":["<sese_id>"],"task":"<short>","deadline":"<iso>","ed_approved":true}}
```

### Hook enforcement (planned)

`~/.claude/hooks/financial-delegation-channel-check.sh` — PreToolUse on `slack_send_message`:
1. If recipient channel = `#opco` AND body contains financial keywords (regex: QBO, bookkeeper, bank, payment, transfer, ACH, NSF, bounced, recurring, vendor, expense, audit, reconcile, software spend, subscription, invoice, bill, payroll, Relay, Airwallex, Mercury, Revolut, Chase) → WARN-mode block. Suggest channel switch.
2. WARN-mode default. `FINANCIAL_DELEGATION_BLOCK=1` to convert to BLOCK after 1 week evidence.
3. Override per-call: `FINANCIAL_CHANNEL_OVERRIDE=1`.

## Related rules

- `~/.claude/rules/delegation-mode-routing.md` — tactical vs principal mode upstream
- `~/.claude/rules/delegation-must-at-mention-recipient.md` — @-mention enforcement
- `~/.claude/rules/delegation-shift-and-load-precheck.md` — shift gate
- `~/.claude/rules/delegation-receipt-verification.md` — post-send receipt watch
- `~/.claude/rules/explain-vs-commit-ask.md` — deliverable + deadline + fallback
- `~/.claude/rules/slack-thread-pattern.md` — parent-label + thread structure
- `~/.claude/projects/-Users-edgomberg-life-os/memory/feedback-financial-asks-finance-channel-plus-dm.md` — origin memory (superseded by this rule)
- `~/life-os/.claude/rules/welgo-bookkeeper-review-flow.md` — sister: bookkeeper queue + 3-action contract
- `~/life-os/.claude/rules/welgo-financial-facts.md` — canonical financial state

## Why this exists (provenance)

Promoted 2026-05-11 from feedback memory + Sese org-chart update (2026-05-11 placed all finance work under COO). Triggered by Era bounce-audit delegation to Angela where instinct was direct DM. Sese-visibility on financial work is now structural, not preference. Rule layer enforces channel + CC discipline pre-send so the transparency Ed wants becomes automatic, not human-remembered.
