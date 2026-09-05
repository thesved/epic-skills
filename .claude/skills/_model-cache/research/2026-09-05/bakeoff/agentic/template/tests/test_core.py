import io, os, sys, tempfile, unittest
from contextlib import redirect_stdout
from datetime import date
from decimal import Decimal

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from ledger import parse_entry, total, filter_since, export_csv
from ledger.cli import main


class ParseTests(unittest.TestCase):
    def test_basic(self):
        d, c, a = parse_entry("2026-03-05,groceries,12.30")
        self.assertEqual(d, date(2026, 3, 5)); self.assertEqual(c, "groceries")
        self.assertIsInstance(a, Decimal); self.assertEqual(str(a), "12.30")

    def test_amount_normalised_to_two_decimals(self):
        self.assertEqual(str(parse_entry("2026-03-05,fuel,7")[2]), "7.00")
        self.assertEqual(str(parse_entry("2026-03-05,fuel,7.5")[2]), "7.50")

    def test_quoted_category_with_comma(self):
        self.assertEqual(parse_entry('2026-01-02,"rent, march",900.00')[1], "rent, march")

    def test_unpadded_date_rejected(self):
        with self.assertRaises(ValueError): parse_entry("2026-3-5,fuel,1.00")

    def test_bad_field_count(self):
        with self.assertRaises(ValueError): parse_entry("2026-03-05,fuel")


class TotalTests(unittest.TestCase):
    def test_exact_money(self):
        es = [parse_entry("2026-01-01,a,1.10"), parse_entry("2026-01-01,b,2.20")]
        t = total(es); self.assertIsInstance(t, Decimal); self.assertEqual(str(t), "3.30")

    def test_empty(self):
        self.assertEqual(str(total([])), "0.00")


class FilterTests(unittest.TestCase):
    def test_inclusive(self):
        es = [parse_entry("2026-02-28,a,1.00"), parse_entry("2026-03-01,b,1.00"), parse_entry("2026-03-02,c,1.00")]
        self.assertEqual([e[1] for e in filter_since(es, date(2026, 3, 1))], ["b", "c"])


class ExportTests(unittest.TestCase):
    def test_header_quoting_and_decimals(self):
        es = [parse_entry('2026-01-02,"rent, march",900'), parse_entry("2026-01-03,fuel,7.5")]
        self.assertEqual(export_csv(es), 'date,category,amount\n2026-01-02,"rent, march",900.00\n2026-01-03,fuel,7.50\n')


class CliTests(unittest.TestCase):
    def _file(self):
        f = tempfile.NamedTemporaryFile("w", suffix=".csv", delete=False)
        f.write("2026-02-28,a,1.10\n2026-03-01,b,2.20\n2026-03-05,c,0.05\n"); f.close(); return f.name

    def test_total(self):
        out = io.StringIO()
        with redirect_stdout(out): main([self._file()])
        self.assertEqual(out.getvalue().strip(), "total: 3.35")

    def test_since(self):
        out = io.StringIO()
        with redirect_stdout(out): main(["--since", "2026-03-01", self._file()])
        self.assertEqual(out.getvalue().strip(), "total: 2.25")


if __name__ == "__main__":
    unittest.main()
