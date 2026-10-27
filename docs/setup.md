# Setup (about 30 minutes, Windows)

You need:
- a claude.ai plan where **Skills** and **Connectors** are available, and **Claude Code** (desktop app or CLI);
- a Google account (the same one you will connect in claude.ai and in Claude Code);
- optional, for the backup: **Git**, **GitHub CLI** (`gh`), **Google Drive for desktop**, **Python 3** (only to build skill zips).

> **Shortcut.** Steps 1–5 can be done by Claude Code itself. Open Claude Code in an empty folder that will become your working folder and paste:
> ```
> Set me up with the claude-shared-memory kit from https://github.com/kuzubis/claude-shared-memory
> following its docs/setup.md. Ask me before anything that creates accounts, repos or scheduled tasks.
> ```
> Then do steps 6–8 in claude.ai yourself.

## 1. Working folder
1. Pick a folder you will always open in Claude Code, e.g. `C:\Work\Claude`.
2. Copy into it from this repository:
   - everything inside `claude-code/` (so `CLAUDE.md.template`, `JOURNAL.md.template`, `.claude\`, `memory\` land in the root);
   - the folders `skills\` → `memory\skills\`, `sync\` → `sync\`, `interview\` → `interview\`, `tools\` → `tools\`.
3. Rename `CLAUDE.md.template` → `CLAUDE.md`, `JOURNAL.md.template` → `JOURNAL.md`, `memory\MEMORY.md.template` → `memory\MEMORY.md`. Replace `<YOUR NAME>`, `<LANGUAGE>`, `<WORK_FOLDER>` in them.

## 2. Google Drive folders
In Claude Code turn on the **Google Drive** connector (in the desktop app: connectors menu of the session; in the CLI: `/mcp`). Then paste:

```
On my Google Drive create a folder "Claude-memory" with subfolders "INBOX" and "archive".
Upload memory/MEMORY.md into "Claude-memory" as a Google Doc named "MEMORY" (contentMimeType text/markdown).
Then replace <MEMORY_FOLDER_ID>, <INBOX_FOLDER_ID>, <ARCHIVE_FOLDER_ID> with the real folder IDs in
memory/skills/shared-memory/SKILL.md, .claude/skills/task-summary/SKILL.md and CLAUDE.md.
```

Manual alternative: create the folders at drive.google.com; a folder's ID is the part of its address after `/folders/`.

## 3. Private GitHub repository (optional, recommended)
In PowerShell, inside the working folder:
```powershell
git init
git add -A
git commit -m "Initial"
gh repo create my-claude --private --source . --push
```
(`gh auth login` first if `gh` is not signed in.)

## 4. Auto-sync every 30 minutes (optional)
```powershell
powershell -ExecutionPolicy Bypass -File .\sync\install-sync.ps1 -WorkFolder 'C:\Work\Claude'
```
Add `-WhatIf` to preview. If Drive for desktop is installed, the folder is mirrored to `My Drive\My-Claude` (change with `-DriveCopyName`; give `-DriveFolder 'G:\My Drive'` if it isn't found automatically). Check `sync\sync-log.txt` — it should say `GitHub: OK` and `Google Drive: OK`.

## 5. Fill your profile and company context
Run the interview: open `interview/questions.md` and paste the prompt from it into Claude Code. At the end ask Claude to turn the results into `memory/skills/my-profile/SKILL.md` and `memory/skills/my-company/SKILL.md`. Then build the zips:
```powershell
python tools\build-skill-zips.py memory\skills
```

## 6. Upload the skills to claude.ai
1. claude.ai → your name (bottom left) → **Settings** → **Capabilities** → **Skills**.
2. **Upload skill** → choose `memory\skills\shared-memory.zip`, then `my-profile.zip`, `my-company.zip`. If an older skill with the same name exists, delete it first.
3. Make sure all three are switched on. Cowork picks them up automatically.

## 7. Connect Google Drive in chat
In a new claude.ai chat: **+** next to the input → **Connectors** → turn on **Google Drive**. Sign in with **the same Google account** that holds `Claude-memory`.

## 8. Personal preferences (so every chat reads the memory)
Settings → **General** → "What personal preferences should Claude consider in responses?" — paste and save:
```
At the start of EVERY conversation use the shared-memory skill: read the Google Drive doc "Claude-memory / MEMORY" (and the relevant context file) so you know what Claude Code on my computer knows.
At the end of every substantial conversation (a decision, a new file, a new fact) put a summary as a separate document into the folder "Claude-memory / INBOX" following the shared-memory skill.
```
Add your language and style line if you like (e.g. "Answer in Ukrainian, plain words, step by step").

## Check
1. New claude.ai chat: ask something only your memory knows (e.g. "Who is <a colleague's nickname>?"). The answer should come from MEMORY.
2. Same chat: "Record that the shared-memory test passed." A new doc must appear in `Claude-memory/INBOX`.
3. In Claude Code: "import the inbox from chat". The entry appears in `JOURNAL.md`, and the doc gets ✅ and moves to `archive`.
