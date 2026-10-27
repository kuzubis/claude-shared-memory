# How it works

## The problem
Claude Code (on your computer), claude.ai chat (browser, phone) and Cowork each have their own memory. What you explained in one place is unknown in the others. This kit gives them **one shared memory** using only built-in tools: files on your computer, skills, and the Google Drive connector.

## The idea: one source of truth, two mailboxes

```
                 ┌─────────────────────────────── your computer ───────────────────────────────┐
                 │  working folder (opened in Claude Code)                                     │
                 │    CLAUDE.md · JOURNAL.md · memory/MEMORY.md · <project>/docs/CONTEXT.md     │
                 └───────────────┬───────────────────────────────────────────▲─────────────────┘
       task-summary skill,       │ export: fresh MEMORY doc                   │ import: INBOX docs → files,
       after every task          ▼                                            │ ✅ + move to archive
                 ┌──────────────────────── Google Drive: Claude-memory ───────┴─────────────────┐
                 │   MEMORY (Google Doc)        INBOX/ (one doc per chat)        archive/        │
                 └───────────────┬───────────────────────────────────────────▲─────────────────┘
       shared-memory skill,      │ read at the start                          │ write at the end
       every conversation        ▼                                            │
                 ┌──────────────────────── claude.ai chat · Cowork ──────────────────────────────┐
                 └───────────────────────────────────────────────────────────────────────────────┘
```

- **The computer is the source of truth.** Rules, facts, project context and the journal live in plain Markdown files in your working folder. Claude Code reads them at the start of every session (via `CLAUDE.md`).
- **Code → chat.** After every finished task the `task-summary` skill updates `memory/MEMORY.md` (≤300 lines) and uploads it to Drive as a fresh Google Doc `MEMORY`. The previous one is moved to `archive`.
- **Chat → Code.** At the start of a conversation the `shared-memory` skill reads `MEMORY`. At the end of a substantial one it creates **one new Google Doc** in `INBOX` with a short structured summary.
- **Import.** At the start of each Claude Code session and in `task-summary`, Claude Code lists `INBOX`, moves every entry into the journal, project context and memory, prefixes the doc title with ✅ and moves it to `archive`. Nothing is ever deleted.
- **Snapshots in skills.** `my-profile` and `my-company` are compact snapshots used when Drive is not reachable.
- **Backup (optional).** `sync/sync.ps1` pushes the whole working folder to a private GitHub repo and mirrors it to Google Drive every 30 minutes, including Claude Code's own memory (`memory/code/`).

## Limitations (found the hard way)
| Limitation | What we do about it |
|---|---|
| The Google Drive connector can create, rename, move and read files — but **cannot append text to an existing Google Doc**. (Editing in place needs a Google Docs connector, which is often not available.) | One new document per chat summary in `INBOX`; `MEMORY` is replaced by a fresh document, the old one goes to `archive`. |
| Drive **search by title lags** for minutes: right after a rename it still returns the old title/location. | Always list a folder with `parentId = '<ID>'` only, then check `title` in the result. |
| A skill does not run by itself at the start of a chat. | One paragraph in claude.ai **personal preferences** tells every chat to use `shared-memory` first. |
| Single line breaks in uploaded Markdown are merged into one paragraph. | Summary fields are written as list items. |
| `robocopy /MIR` makes the Drive copy an exact mirror and deletes anything added there by hand. | Chat writes only to the separate `Claude-memory` folder, never into the mirrored copy. |
| claude.ai skills are uploaded by hand (zip). | `tools/build-skill-zips.py` builds correct zips (forward slashes inside — `Compress-Archive` on Windows PowerShell 5.1 writes backslashes). |
| Some Claude Code permission modes may block creating scheduled tasks. | Import also happens at session start and in `task-summary`, so a schedule is optional. |

## What is NOT shared
- claude.ai's own built-in memory and project knowledge stay as they are; this kit adds a copy, it doesn't replace them.
- Secrets: the sync excludes `.env`, keys, sessions. Never put passwords, card numbers or passport data into memory files — they go to GitHub and Drive.
