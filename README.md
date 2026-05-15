# welgo-revenue-plugin

Pre-packed Claude Code setup for the Welgo Revenue role.

## What it does

Bundles rules, skills, an MCP connection to Welgo Brain, hooks, and your agent definitions for the Welgo Revenue role.

## Prereqs (one-time per machine)

1. Claude Code installed.
2. Tailscale installed and signed in with your work Google account.
3. You've been added to the Welgo tailnet via Ed's share link.
4. WELGO_BRAIN_TOKEN set in your shell (Ed sends this privately, paste into ~/.zshrc as export WELGO_BRAIN_TOKEN=..., then source ~/.zshrc). After Tailscale-identity auth is live (Phase 2 v0.3), token will no longer be needed.

## Install

Inside Claude Code:

```
/plugin install https://github.com/edgomberg/welgo-revenue-plugin
```

Confirm install. Restart Claude Code.

## Updates

On every Claude Code launch, it checks for plugin updates. Banner shows when new version available. Run `/plugin update welgo-revenue-plugin` to apply.

## Escalation

Anything outside your scope, post in Slack #opco and tag Ed.

## Questions

Ping Ed directly in Slack DM.
