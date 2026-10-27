# The big interview: everything Claude should know about you and your work

The idea is "deep context". Claude asks you questions on every topic that matters for working together. From the answers it builds two reference files that every new chat reads before starting:
- `profile/docs/ABOUT-ME.md` (blocks 1–4 and 14) → later the **my-profile** skill;
- `<company>/docs/CONTEXT.md` (blocks 5–13) → later the **my-company** skill.

Takes 2–4 evenings. You can do it in parts.

## How to start
Open Claude Code in your working folder and paste:

```
Interview me using interview/questions.md.
One question per message. Wait for my answer, then ask the next one.
After each block write the result right away into profile/docs/ABOUT-ME.md (blocks 1–4, 14)
or <company>/docs/CONTEXT.md (blocks 5–13). Tag every fact [me] or [document].
Commands: "next"/"skip", "block N", "pause" (write down where we stopped).
```

## Rules
1. **One question per message.** If an answer is incomplete, Claude asks one short follow-up and moves on.
2. **Answer any way you like:** text, voice (Win + H on Windows), a file or a path to a file (CV, staff list, org chart, contract register, screenshot). Claude reads the file and skips questions it already answers.
3. **"Look it up yourself."** If the answer is in your files or mail, say so — Claude will search, read-only.
4. **Safety.** Don't write passwords, card or account numbers, passport data, e-signature codes: the files are copied to GitHub and Google Drive. Contract numbers, names, positions and work phones are fine.
5. **At the end** ask: "Turn ABOUT-ME.md into the my-profile skill and CONTEXT.md into the my-company skill using the templates in skills/". Then upload them to claude.ai (see docs/setup.md).

---

## Questions

### Block 1. How we work together
1. Which tasks do you give Claude most often, and which are the most important?
2. What annoys you most in answers: too long, too many questions, jargon, something else?
3. What may Claude do on its own, and what only after your "yes"? E.g. messages, deletions, money, publishing.
4. Where do you usually work from: laptop, phone, a bot? Where do you prefer to receive results?
5. Which result formats suit you best: Excel, PDF, slides, Word, a messenger message?
6. Are there samples Claude must always use (letterhead, report to your boss, deck)? Where are they?
7. When do you usually work? When must you not be disturbed?
8. Whom may Claude write to on your behalf, and whom never?

### Block 2. About you
1. Full name. How to sign official letters?
2. Year of birth, education, previous jobs — what's worth knowing (you can send your CV).
3. Languages: which one for partners? Your English level?
4. Hobbies?
5. Which principles must Claude follow (honesty, sources, checking regulations…)?
6. What do you want to achieve in 1–3 years — personally and at work?

### Block 3. Family and home
1. Partner: what they do, how to address them, what may be sent to them on your behalf?
2. Children: kindergarten, school, activities, schedule.
3. Parents, siblings: names, where they live, how Claude can help?
4. Which dates to remind you of: birthdays, anniversaries, other?
5. Home and utilities: who pays, how meter readings are sent?
6. Power during outages: generator, power station, power banks?
7. Car: model, mileage, next service, insurance expiry, VIN for parts?
8. Which household chores would you hand to Claude: shopping, prices, selling things?

### Block 4. Health and sport
1. Which sport, which watch and apps?
2. Upcoming races and goals.
3. Injuries or limits to take into account.
4. Do you want help with nutrition, weight, recovery?

### Block 5. The company: what it does
1. History: when founded, who built it, since when are you in your role?
2. Current state: what works, what doesn't, key monthly figures?
3. Technology or product: equipment, capacity, inputs, output.
4. By-products and waste: where do they go, are they sold?
5. Equipment that breaks most often.
6. Who services the equipment? Schedule, next overhaul?
7. Spare parts: where you buy, stock on hand, delivery time?
8. Addresses: legal, site, office. Where is accounting?

### Block 6. Market and sales
1. How and to whom do you sell: contracts, markets, intermediaries?
2. Tariffs and prices, how long they are valid, guarantees.
3. Who plans sales and volumes, what forecast errors cost.
4. Grid / infrastructure connection: contracts, allowed capacity.
5. Metering: who reads the data, which meters or systems?
6. Current requirements from regulators and operators.
7. Regular reports: which, to whom, by which day?

### Block 7. Finance, bank, taxes
1. Loans: bank, balance, currency, rate, schedule, collateral, covenants, bank manager.
2. Agreements with the bank: what's agreed, which obligations?
3. Main monthly income and costs (order of magnitude is enough).
4. Accounting: who, which software, how to get trial balances?
5. Regular payments and their dates.
6. Taxes: system, VAT, regular returns, open issues with the tax office.
7. Insurance: what is insured, with whom, until when?
8. Audit: who and when?
9. Grants and state programs: at what stage?

### Block 8. People
1. How many employees, who works where?
2. Key people: name, position, responsibility, best way to reach them. The nicknames/abbreviations you use.
3. What can be delegated to whom?
4. HR items to track (reservations, leave, certifications)?
5. Timesheets and payroll: who, what's needed from you?
6. Occupational safety: who is responsible, what's current?
7. Who is missing, open vacancies?
8. External consultants and lawyers: who is responsible for what?

### Block 9. Owner and related companies
1. How you work with the owner or your boss: how often you report, format, what they want to see first?
2. Which companies are in the group? What do you do in each?
3. Key people in those companies.
4. Settlements between the companies.
5. Folders with cryptic names: one line each — what it is, still relevant, may Claude open it?
6. Strategy: main decisions already made.
7. What you decide yourself and what only with the owner.

### Block 10. Counterparties and contracts
1. Without which 10 counterparties does the business stop? Who supplies what?
2. Key foreign partners: contracts, contact persons.
3. Supply and sales contracts: terms, prices, renewals.
4. Infrastructure and regulator contracts: numbers, dates, terms.
5. Construction/service contracts in progress: with whom, what stage?
6. Land or premises lease: plots, landlords, terms.
7. Which contracts expire soon or must be renewed?
8. Open disputes, claims, court cases, debts.
9. How you choose suppliers: quotes, tenders, approvals?
10. Keep a contract register in Excel with expiry dates and reminders?

### Block 11. State, regulation, security
1. Special statuses (critical infrastructure etc.): which, valid until when?
2. Licenses, reporting, inspections.
3. Environment: permits, reports.
4. Military registration / staff reservations: who is responsible?
5. Open cases with state bodies.
6. Site security: guards, shelter, backup power.
7. Which lawyers you have and whom to ask about what.

### Block 12. Projects in progress
1. All current projects by importance.
2. For each: next step and deadline.
3. What slows things down most?
4. New ideas you are seriously considering.
5. Who else works on each project?

### Block 13. Documents and files
1. Which folders are alive and which are archive? Should Claude tidy up?
2. Where are the letterhead, stamp and signature scans, letter and order templates?
3. How do you sign documents (no passwords)?
4. Which mailbox is for work and official letters?
5. Whom do you talk to about work in messengers?
6. Which documents are prepared monthly or quarterly — to make them from a template?

### Block 14. Projects with Claude and devices
1. Which of your Claude projects (bots, automations, apps) matter most, and which can be frozen?
2. Your devices: laptop, phone, tablet — models.
3. Which services do you pay for and how much are you willing to spend on IT per month?
4. Top 5 things to automate next (work and personal).
