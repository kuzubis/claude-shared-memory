---
name: shared-memory
description: Shared memory between claude.ai chat, Cowork and Claude Code, kept on the user's Google Drive. Use at the START of EVERY conversation (read the memory) and at the END of every substantial conversation (drop a summary into the INBOX folder), and whenever the user says "summarize", "save this", "remember", "what did we decide", "done", "that's all" (or the same in their language).
---

# Shared memory (claude.ai ↔ Claude Code ↔ Cowork)

Goal: wherever the user talks to Claude, Claude knows the same things. The single source of truth is the user's computer (the Claude Code working folder). From there the data goes to Google Drive.

Answer the user in their own language. Never tell them you are "running a skill" — just use the knowledge.

## Where the memory lives (user's Google Drive)
- Folder **`Claude-memory`** (ID `<MEMORY_FOLDER_ID>`):
  - Google Doc **`MEMORY`** — the main memory: who the user is, working rules, family, projects, open questions, recent tasks. Only Claude Code updates it: it uploads a fresh document and moves the old one to `archive`. So always look it up by listing the folder, never by an old link.
  - Folder **`INBOX`** (ID `<INBOX_FOLDER_ID>`) — this is where you (chat or Cowork) drop conversation summaries, **one Google Doc per conversation**. Claude Code moves them to the computer, adds ✅ to the title and moves them to `archive`.
  - Folder **`archive`** (ID `<ARCHIVE_FOLDER_ID>`) — processed entries and old versions of MEMORY. Do not touch.
- Optional: a full copy of the working folder (e.g. `My-Claude`), refreshed by the sync script every 30 min. **Read only** — anything you change there is overwritten.

## 1. At the start of a conversation
1. With the Google Drive connector call `search_files` with the query **only** `parentId = '<MEMORY_FOLDER_ID>'` (no `title` clause — title search lags by minutes and may return an archived copy). From the result take the document whose `title` is exactly `MEMORY`; if there are several, the newest by `createdTime`. Read it with `read_file_content` (`includeComments: true`).
2. If the task is about a specific project, find its context file in the working-folder copy (table in `CLAUDE.md`) and read it too. If a `.md` file does not open, search with `fullText contains '…'`.
3. List the `INBOX` folder (`parentId = '<INBOX_FOLDER_ID>'`): there may be fresh entries from other chats that Claude Code has not imported yet.
4. Do not retell what you read. Just work with it.
- **Cowork:** if you have access to the working folder on disk, read `memory/MEMORY.md` directly.
- **No access at all:** work from the profile/company skills (a snapshot) and tell the user in one line that fresh memory could not be read (for example, the Google Drive connector is off).

## 2. At the end of a substantial conversation
Substantial = something was decided, a file was created or changed, a new fact/date/person/document number appeared, or the user corrected a rule. Skip trivial Q&A.

Create a **new** Google Doc in `INBOX`: Google Drive connector, `create_file`, `parentId` = `<INBOX_FOLDER_ID>`, `contentMimeType` = `text/markdown`.
- Title: `YYYY-MM-DD — short title (claude.ai)` or `(Cowork)`.
- Body — every field as a separate list item (single line breaks get merged):

```
## YYYY-MM-DD — short title (claude.ai | Cowork)
- **Project:** …
- **Done:** …
- **Decisions:** … (what was chosen and why)
- **Files:** … (names and where they are: Google Drive / downloads)
- **New facts for memory:** … (people, dates, numbers, rules from the user; each tagged [user] or [document])
- **Next:** … (or "—")
```

Rules:
- Only facts the user stated or confirmed. No recommendations they did not accept.
- Be concrete: document numbers and dates, amounts, names.
- One document = one conversation. If more is decided later in the same chat, create another document with "(2)".
- Never delete or edit other documents in `INBOX`, `archive` or the working-folder copy.
- Never write passwords, card numbers or passport data.
- Tell the user in one line: "Saved a summary to shared memory."
- If claude.ai's own memory also saves a summary — fine, they don't conflict.

## 3. What Claude Code does (for reference)
At the start of its sessions and when it finishes a task, Claude Code lists `INBOX`, imports every entry into files on the computer (journal, project context, memory), prefixes the title with "✅ " and moves the document to `archive`. Then it uploads a fresh `MEMORY`. So whatever is decided in chat becomes known to Claude Code, and vice versa.
