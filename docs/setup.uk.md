# Налаштування (близько 30 хвилин, Windows)

Потрібно:
- тариф claude.ai, де доступні **Скіли** (Skills) і **Конектори** (Connectors), та **Claude Code** (застосунок для комп'ютера або командний рядок);
- обліковий запис Google (той самий, що підключите і в claude.ai, і в Claude Code);
- необов'язково, для резервної копії: **Git**, **GitHub CLI** (`gh`), **Google Диск для комп'ютера**, **Python 3** (лише щоб зібрати zip скілів).

> **Найпростіше.** Кроки 1–5 Claude Code може зробити сам. Відкрийте Claude Code у порожній папці, яка стане робочою, і вставте:
> ```
> Налаштуй мені набір claude-shared-memory з https://github.com/kuzubis/claude-shared-memory
> за його docs/setup.uk.md. Перед усім, що створює облікові записи, сховища чи задачі за розкладом, питай мене.
> ```
> Потім кроки 6–8 зробіть у claude.ai самі.

## 1. Робоча папка
1. Оберіть папку, яку завжди відкриватимете в Claude Code, наприклад `C:\Work\Claude`.
2. Скопіюйте в неї з цього сховища:
   - усе з папки `claude-code/` (щоб `CLAUDE.md.template`, `JOURNAL.md.template`, `.claude\`, `memory\` опинилися в корені);
   - папки `skills\` → `memory\skills\`, `sync\` → `sync\`, `tools\` → `tools\`.
3. Перейменуйте `CLAUDE.md.template` → `CLAUDE.md`, `JOURNAL.md.template` → `JOURNAL.md`, `memory\MEMORY.md.template` → `memory\MEMORY.md`. Замініть у них `<YOUR NAME>`, `<LANGUAGE>`, `<WORK_FOLDER>`.

## 2. Папки на Google Диску
У Claude Code увімкніть конектор **Google Drive** (у застосунку — меню конекторів сесії; у командному рядку — `/mcp`). Потім вставте:

```
Створи на моєму Google Диску папку "Claude-memory" з підпапками "INBOX" і "archive".
Завантаж memory/MEMORY.md у "Claude-memory" як Google-документ "MEMORY" (contentMimeType text/markdown).
Потім заміни <MEMORY_FOLDER_ID>, <INBOX_FOLDER_ID>, <ARCHIVE_FOLDER_ID> на справжні ID папок у
memory/skills/shared-memory/SKILL.md, .claude/skills/task-summary/SKILL.md і CLAUDE.md.
```

Вручну: створіть папки на drive.google.com; ID папки — частина її адреси після `/folders/`.

## 3. Закрите сховище GitHub (необов'язково, але раджу)
У PowerShell, у робочій папці:
```powershell
git init
git add -A
git commit -m "Initial"
gh repo create my-claude --private --source . --push
```
(Якщо `gh` ще не увійшов в обліковий запис — спершу `gh auth login`.)

## 4. Автокопія кожні 30 хвилин (необов'язково)
```powershell
powershell -ExecutionPolicy Bypass -File .\sync\install-sync.ps1 -WorkFolder 'C:\Work\Claude'
```
Додайте `-WhatIf`, щоб спершу лише подивитися, що буде. Якщо встановлено Google Диск для комп'ютера, папка дзеркалиться в `Мій диск\My-Claude` (назва — параметр `-DriveCopyName`; якщо диск не знайдено автоматично, вкажіть `-DriveFolder 'G:\Мій диск'`). Перевірка — файл `sync\sync-log.txt`: там має бути `GitHub: OK` і `Google Drive: OK`.

## 5. Зібрати zip скіла
(Необов'язково, але спершу можна: заповніть профіль і довідку про компанію інтерв'ю з [claude-deep-context](https://github.com/kuzubis/claude-deep-context) — отримаєте скіли `my-profile` і `my-company`.)

Зберіть zip скіла `shared-memory`:
```powershell
python tools\build-skill-zips.py memory\skills
```

## 6. Завантажити скіли в claude.ai
1. claude.ai → ваше ім'я ліворуч унизу → **Налаштування** (Settings) → **Можливості** (Capabilities) → **Скіли** (Skills).
2. **Завантажити скіл** (Upload skill) → виберіть `memory\skills\shared-memory.zip` (і zip профілю та компанії, якщо зробили). Якщо вже є старий скіл з такою назвою — спершу видаліть його.
3. Перевірте, що вони увімкнені. Cowork підтягне їх сам.

## 7. Підключити Google Диск у чаті
У новому чаті claude.ai: **+** біля поля введення → **Конектори** (Connectors) → увімкніть **Google Drive**. Увійдіть **тим самим обліковим записом Google**, на якому лежить `Claude-memory`.

## 8. Особисті налаштування (щоб кожен чат читав пам'ять)
Налаштування → **Загальні** (General) → поле «Які особисті вподобання Claude має враховувати» — вставте й збережіть:
```
На початку КОЖНОЇ розмови застосуй скіл shared-memory: прочитай з Google Диска документ «Claude-memory / MEMORY» (і потрібний файл контексту), щоб знати все, що знає Claude Code на моєму комп'ютері.
Наприкінці кожної суттєвої розмови (рішення, новий файл, новий факт) — поклади підсумок окремим документом у папку «Claude-memory / INBOX» за скілом shared-memory.
```
За бажання додайте рядок про мову й стиль (наприклад, «Відповідай українською, простими словами, покроково»).

## Перевірка
1. Новий чат claude.ai: спитайте те, що знає лише ваша пам'ять (наприклад, «Хто такий <прізвисько колеги>?»). Відповідь має прийти з MEMORY.
2. Там же: «Запиши, що перевірка спільної пам'яті пройшла». У `Claude-memory/INBOX` має з'явитися новий документ.
3. У Claude Code: «перенеси вхідні з чату». Запис з'явиться в `JOURNAL.md`, а документ отримає ✅ і переїде в `archive`.
