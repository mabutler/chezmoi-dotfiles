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
