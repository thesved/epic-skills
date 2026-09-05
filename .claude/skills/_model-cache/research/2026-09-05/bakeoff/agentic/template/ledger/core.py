import csv
import io
from datetime import datetime


def parse_entry(line):
    """Parse 'YYYY-MM-DD,category,amount' into (date, category, amount)."""
    parts = next(csv.reader([line.strip()]))
    if len(parts) != 3:
        raise ValueError("expected 3 fields")
    d = datetime.strptime(parts[0].strip(), "%Y-%m-%d").date()
    category = parts[1].strip()
    amount = float(parts[2])
    return d, category, amount


def total(entries):
    """Sum of amounts."""
    return round(sum(e[2] for e in entries), 2)


def filter_since(entries, since):
    """Entries dated after `since`."""
    return [e for e in entries if e[0] > since]


def export_csv(entries):
    """CSV text of the entries."""
    buf = io.StringIO()
    for d, category, amount in entries:
        buf.write(f"{d.isoformat()},{category},{amount}\n")
    return buf.getvalue()
