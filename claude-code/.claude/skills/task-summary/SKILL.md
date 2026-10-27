---
name: task-summary
description: Wraps up a finished task and saves the knowledge for future chats — updates the project's docs/CONTEXT.md, adds an entry to JOURNAL.md, updates Claude's memory and syncs the shared memory with claude.ai (Google Drive INBOX → files, files → MEMORY). Use ON YOUR OWN after every finished task (something was done/changed/decided), and when the user says "summarize", "save", "record this", "done", "that's all for today" (or the same in their language).
---

# Task summary

Goal: a new chat knows what was done, which decisions were made and what's next — without explaining from scratch.

## Steps

### 1. Decide what to summarize
From this chat pick out:
- **Project** (a row from the table in `CLAUDE.md`, or "general").
- **Done** — 1–3 sentences, the result, not the process.
- **Decisions** — what was chosen and why (especially what was rejected).
- **Changed/created files**, new version, where it is deployed.
- **What's left / next step**, known problems.
- New **commands, paths, settings** needed later.

If there were neither changes nor decisions — record nothing, just say so.

### 2. Update the project's context file
Context files are listed in the table in `CLAUDE.md`. Read the file fully, then:
- update the current state / version / settings so they are **current** (fix what's stale instead of adding a contradicting line next to it);
- add a short change-history line if the file has such a section;
- if the project has no context file yet — create `<project>/docs/CONTEXT.md` (what it is, where it lives, how to run/deploy, current version, history) and add a row to the table in `CLAUDE.md`.

Skip this step for "general".

### 3. Add an entry to JOURNAL.md
Insert **right after the `---` line** (newest on top):

```markdown
## YYYY-MM-DD — Short task title
**Project:** <name>
**Done:** ...
**Decisions:** ...
**Files:** ...
**Next:** ... (or "—")
```

5–8 lines. Details go to CONTEXT.md, not the journal. Use today's absolute date.

### 4. Update memory (only for a new lasting fact)
Claude Code memory: `~/.claude/projects/<project-id>/memory/` + index `MEMORY.md`.
- New project version, new server address, new rule from the user, new project — update the matching memory file (or create one and add a line to the index).
- Don't duplicate CONTEXT.md — a pointer is enough.

### 4a. Shared memory with claude.ai (see `docs/how-it-works.md` of claude-shared-memory)
Google Drive folder `Claude-memory` (ID `<MEMORY_FOLDER_ID>`) with subfolders `INBOX` (ID `<INBOX_FOLDER_ID>`) and `archive` (ID `<ARCHIVE_FOLDER_ID>`). The Drive connector cannot append to an existing document — only create, rename, move and read. So every change = a new document; the old one goes to `archive` (never to the trash).
1. **Import:** `search_files` with `parentId = '<INBOX_FOLDER_ID>'`; read every document (`read_file_content`, `includeComments: true`) and move it into files: JOURNAL.md (newest on top, marked "(claude.ai)" or "(Cowork)"), the right CONTEXT.md, lasting facts into memory. Then `update_file`: prefix the title with "✅ ", `parentId` = archive.
2. **Export:** if something important for memory changed (rules, facts, projects, open questions, a new journal entry), update `memory/MEMORY.md` (≤300 lines, "Recent tasks" section 6–8 lines). Then find the current `MEMORY` doc — `search_files` with **only** `parentId = '<MEMORY_FOLDER_ID>'` (no `title`: title search lags), check the title in the result; create a new `MEMORY` there (`create_file`, `text/markdown`, the file's content); rename the old one to "MEMORY until YYYY-MM-DD HH:MM" and move it to archive. Verify with `read_file_content` that the new one reads back.
3. If the Google Drive connector is unavailable — update only `memory/MEMORY.md` and tell the user in one line that the Drive copy will be refreshed next time.

### 5. Don't commit yourself
The folder syncs to GitHub automatically every 30 min (`sync/sync.ps1`). No manual commit needed unless a project has its own release routine.

### 6. Tell the user
One or two lines in the user's language: what was recorded and where, e.g.
> Summary saved: updated `app/docs/CONTEXT.md` (version 1.2) and added a JOURNAL.md entry.
