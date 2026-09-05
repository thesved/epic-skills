# ledger

Tiny personal ledger library + CLI. Entries are CSV lines `YYYY-MM-DD,category,amount`.

Spec (the tests are the contract):
- `parse_entry(line)` returns `(date, category, amount)`; date is a `datetime.date`, amount a `decimal.Decimal` with exactly two decimal places. Dates must be strictly `YYYY-MM-DD` with zero padding; anything else raises `ValueError`. Categories may contain commas when the CSV field is double-quoted.
- `total(entries)` returns a `Decimal` with two decimal places (exact money arithmetic, never floats).
- `filter_since(entries, since)` keeps entries dated on or after `since` (inclusive).
- `export_csv(entries)` returns CSV text with a header `date,category,amount`, one row per entry, RFC 4180 quoting (a category containing a comma is double-quoted), `\n` line endings, amounts always with two decimals.
- CLI: `python -m ledger.cli [--since YYYY-MM-DD] FILE` prints the total of the (optionally filtered) entries as `total: <amount>`.

Run the tests: `python3 -m unittest discover -s tests -v`
