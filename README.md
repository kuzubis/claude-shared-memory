# claude-shared-memory

**One memory for Claude Code, claude.ai chat and Cowork** — with nothing but files, skills and the Google Drive connector. No servers, no paid services, no code to run in the cloud.

🇺🇦 [Українська версія](README.uk.md)

## Why
Claude Code on your laptop knows your projects, rules and history. Open claude.ai on your phone — and it knows none of that. This kit makes every Claude surface read the same memory at the start of a conversation and hand back what was decided at the end.

## How it works (in 20 seconds)
- Your **computer is the source of truth**: Markdown files in the folder you open in Claude Code (`CLAUDE.md`, `JOURNAL.md`, `memory/MEMORY.md`, per-project `docs/CONTEXT.md`).
- After each finished task Claude Code (skill **task-summary**) uploads a fresh `MEMORY` Google Doc to a Drive folder `Claude-memory`.
- Every claude.ai / Cowork conversation (skill **shared-memory**) reads `MEMORY` first and, at the end, drops a one-page summary into `Claude-memory/INBOX`.
- Claude Code imports the INBOX into your files, marks each entry ✅ and moves it to `archive`. Nothing is deleted.

Details, diagram and the limitations we hit: [docs/how-it-works.md](docs/how-it-works.md).

## What's inside
| Folder | What |
|---|---|
| `skills/` | the claude.ai skill `shared-memory` (the protocol) |
| `claude-code/` | goes into your Claude Code folder: `CLAUDE.md` template, `task-summary` skill, journal and memory templates |
| `sync/` | optional Windows auto-backup every 30 min: private GitHub repo + Google Drive mirror (`install-sync.ps1` registers it in Task Scheduler) |
| `tools/` | `build-skill-zips.py` — packs skills into zips claude.ai accepts |
| `docs/` | [how it works](docs/how-it-works.md), [setup](docs/setup.md) |

## Quick start
1. Read [docs/setup.md](docs/setup.md) (≈30 min). Or let Claude Code do most of it: open it in an empty folder and paste
   `Set me up with the claude-shared-memory kit from https://github.com/kuzubis/claude-shared-memory following its docs/setup.md. Ask me before anything that creates accounts, repos or scheduled tasks.`
2. In claude.ai: upload the `shared-memory` skill zip, turn on the Google Drive connector, paste one paragraph into personal preferences.
3. Test: ask a new chat something only your memory knows.

## Fill the memory from day one
An empty memory fills up as you work. To start with a full one, run the interview from the companion kit **[claude-deep-context](https://github.com/kuzubis/claude-deep-context)**: Claude asks you 14 blocks of questions and builds `my-profile` and `my-company` skills — they also serve as the fallback when Drive is unreachable.

## Requirements
- claude.ai plan with Skills and Connectors; Claude Code.
- A Google account (the same in claude.ai and Claude Code).
- Windows for the optional `sync/` scripts (the rest is OS-independent).

## Privacy
Memory files go to Google Drive (and to GitHub if you use `sync/`). Keep the GitHub repo **private** and never store passwords, card numbers or passport data in memory files. The sync excludes `.env`, keys and session files.

## Origin
Built by a non-programmer director of a biogas plant together with Claude Code, after a "deep context" interview session — and tested day to day across Claude Code, claude.ai and Cowork. Issues and improvements are welcome.

License: [MIT](LICENSE).
