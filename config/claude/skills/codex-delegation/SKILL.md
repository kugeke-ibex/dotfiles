---
name: codex-delegation
description: Guidance for delegating heavy coding or research tasks to Codex via /codex:rescue or the codex:codex-rescue subagent in order to conserve Claude Code tokens. Consult before starting any of the following — cross-file investigation touching 3+ files, implementation requiring reading 5+ files, refactoring of 100+ lines, root-cause analysis from logs or stack traces, asking for a second opinion after being stuck on the same error twice, external resource investigation such as inspecting a GitHub repository URL or crawling a documentation site, or multi-page web research requiring fetching 3+ pages. Skip for 1-2 file edits, a single quick WebFetch of one URL, interactive design discussions, final diff review, or when the user explicitly asks to implement directly.
---

# Codex Delegation Rules

Delegate heavy coding tasks to Codex to conserve Claude Code token consumption.
Do not implement such tasks directly in Claude Code.

## Tasks to Delegate (send to Codex)

- Cross-cutting investigation or research spanning 3+ files
- Implementation tasks requiring reading 5+ files
- Root-cause analysis from logs or stack traces
- Large-scale refactoring (100+ lines of changes)
- Second opinion when stuck on the same error twice or more
- New implementation or fix with a clear spec and limited scope
- External resource investigation: inspecting a GitHub repository URL,
  crawling a documentation site, or analyzing a third-party library source
- Multi-page web research requiring fetching 3+ pages or deep comparison
  across multiple URLs

## Tasks to Handle in Claude Code

- Small edits touching 1–2 files
- Interactive design discussion or direction-setting
- Diff review and final integration
- Any task the user explicitly says to implement directly
- A single quick WebFetch of one URL for a short summary

## Prompt Rules When Delegating

When invoking `/codex:rescue` or the `codex:codex-rescue` subagent,
always specify the following:

- **Goal**: what to accomplish
- **Scope**: which files or directories may be touched
- **Inputs**: existing files to reference
- **Expected output**: list of files to create or modify, and their format
- **Constraints**: no breaking changes, follow existing naming conventions, etc.
- **Verification**: fmt / validate / test must pass, etc.
- **Return format**: "Return a list of changed file paths plus a summary"

## Claude Code Flow After Delegation

1. Receive the Codex summary
2. Read the changed files to verify
3. Make minor adjustments or integrate as needed
