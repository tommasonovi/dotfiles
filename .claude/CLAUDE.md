# Project Guidelines

## Branch Structure

- Validation/control branches follow the naming convention: `validation/control_<YYYY_MM_DD>` (e.g., `validation/control_2026_03_20`).
- A new branch is created almost every day.
- Unless explicitly told otherwise, use the latest `validation/control_*` branch as the base branch when checking, comparing, or verifying changes (not `dev`).

## General Principles

- Verify, don't assume: only claim success when it was explicitly confirmed.
- Prefer simple, systematic solutions over ad-hoc complexity.
- Keep responses concise and avoid filler.

## Testing

- Use TDD by default: write tests first unless the change is trivial or it's a one-off test run.
- Favor high-value testing: prefer end-to-end or integration coverage, avoid redundant tests, and never rely on external network dependencies in unit tests.

## Code Quality

- For Python changes, make sure both `pyright` and `ruff` pass on the touched files.
- Keep code maintainable: reuse functions, keep business logic layered/composable, keep files reasonably small, and keep comments concise.

## Project Conventions

- Follow Google C++ style, `lowerCamelCase` member functions, and `magic_enum` when it fits enum/string work.
- If Bazel is locked, wait for it rather than killing the process holding the lock.

## Git Hygiene

- Use `user/tommasonovi/...` branch names.
- Don't use `git add -A`.
- Never push unless explicitly asked.
- Use `glab` for GitLab interactions (MRs, repo info, etc.). If not authenticated, ask the user to run `glab auth login`.

## Pull Requests

- Keep PRs reviewer-friendly: include motivation and rationale, don't list breaking changes if there aren't any.
- Don't include pre-commit/basic compile checks or Bazel unit tests in PR test plans.
- When manual validation is useful, leave focused MR testing notes with setup, procedure, key outputs, and results.
