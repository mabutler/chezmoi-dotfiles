When committing, note my contributions in the message body when they establish meaningful human contribution: architectural decisions, or requests that changed what actually shipped — not ones I raised that got explained away or didn't survive a technical constraint. Omit otherwise.
To validate changes, run the existing build/tests if available. If the direct path is blocked — a tool isn't installed, a GUI can't be driven programmatically, no harness exists for what you're testing — stop and ask me before building new tooling or scaffolding to work around it (e.g., writing a mockable test library to avoid driving a real GUI, or implementing a replacement CLI tool because one isn't findable). These blockers are usually quick for me to resolve; treat "build a workaround" as something that needs my go-ahead, not a default next step when the easy path fails.
Always wait for confirmation to commit. I want to review all changes first

## Software Logging Policy

### Log Levels
- **CRITICAL** — system restarting. Include exception and restart reason.
- **WARN** — failure, execution continuing. Worth monitoring for patterns.
- **INFO** — significant lifecycle milestone. States the outcome, not the data behind it. Should read like an audit trail.
- **DEBUG** — application's interpretation of state before a milestone. "Engineer's working notes." Not a lower tier of INFO.
- **TRACE** — mechanical entry/exit with parameter and return values.

### What belongs at each level
- INFO states what happened ("Payment held for review"). DEBUG carries the reasoning ("FraudScore=0.87 exceeds threshold=0.75"). Never put diagnostic data in INFO.
- Do not re-log what a callee's TRACE already shows. If data is significant enough for DEBUG, prefer promoting that TRACE line to DEBUG over adding a second line. Do not skip a DEBUG log just because a TRACE covers the same data.
- Significant actions being taken (not just outcomes) belong at INFO — log both the attempt and the result so a crash mid-operation leaves a record.
- Declined/failed-but-continuing operations are WARN, not DEBUG — they're worth monitoring for patterns in production.
- A layer that's otherwise verbose/DEBUG (an internal engine, driver, or backend implementation behind a higher-level entry point) still logs its own one-time startup/initialization/shutdown actions at INFO, if the action runs once per lifecycle and its effect persists for the whole lifecycle afterward. The "this layer is DEBUG" default applies to repeating, per-event work, not one-shot lifecycle actions.

### TRACE rules
- Entry and exit on every function, every return path.
- Exit TRACE required even when INFO or WARN immediately precedes the return statement.
- Complex object parameters: use a ToString() override or ToTrace() helper with a fixed set of cheap properties. Do not select fields inline at each call site.
- External library calls have no TRACE. Log what came back at DEBUG in the caller instead.

### Do not log
- Passwords, tokens, secrets, API keys
- Full credit card numbers, SSNs, government IDs, or raw PII. Internal record IDs (GUIDs, row IDs, usernames) are fine.

### Correlation IDs
- session_id and event_id are read from scope state automatically. Never pass them as parameters or log them manually at the call site.

### Performance
- Guard expensive log arguments with a level check. Simple variable interpolation needs no guard.
- High-frequency events (sustained >100/sec): sample or aggregate rather than logging every occurrence.
