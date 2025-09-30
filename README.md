# Payroll Timesheet — README

## Overview

An interactive Bash-based payroll timesheet for collecting weekly hours and calculating pay and taxes.
Designed for quick HR use from the terminal. Records are appended to a plain text file `payroll.txt` in a pipe-delimited table format.

**Key assumptions**

* Time is entered in 24-hour integer format (e.g., `7` for 7:00, `13` for 1:00 PM).
* Workweek is Monday → Friday only.
* Monthly pay is calculated as `weekly_pay * 4`.
* Tax rules (applied to monthly pay):

  * `< 32` weekly hours → 5% tax
  * `32 ≤ hours < 40` → 10% tax
  * `≥ 40` → 15% tax

---

## Features

* Interactive main menu: Add record, Search records, Exit.
* Collects: date, employee name, employee ID, hourly wage, daily time in/out.
* Calculates daily hours, weekly hours, weekly pay and monthly pay.
* Applies tax bracket and shows monthly pay after tax.
* Appends records to `payroll.txt` in `Date|Full Name|Employee ID|Hourly Wage|Mon|Tue|Wed|Thu|Fri|Weekly|Monthly Pay|Tax` format.
* Case-insensitive search of `payroll.txt` via `grep`.

---

## Project structure

```
payroll_timesheet.sh   # Main script (this file's code)
payroll.txt            # Data file (created / appended at runtime)
README.md              # This document
```

---

## Prerequisites

* Bash shell (Linux, macOS, WSL, Git Bash).
* `grep`, `column` utilities available (standard on Linux/macOS).

---

## Installation & Run

1. Save the script file, e.g. `payroll_timesheet.sh`.
2. Make it executable:

   ```bash
   chmod +x payroll_timesheet.sh
   ```
3. Run it:

   ```bash
   ./payroll_timesheet.sh
   ```

---

## Usage guide (quick)

1. Choose `1` to add a record.
2. Enter the date for the start of the week: `MM/DD/YYYY`.
3. Enter an employee ID (used for searching).
4. Enter full name and hourly wage (integer expected by the script).
5. Enter `Time In` and `Time Out` for Monday → Friday (24-hour integers).
6. Script prints summary, calculates monthly pay and tax, appends the record to `payroll.txt`.
7. Choose `2` from the main menu to search `payroll.txt` by name or ID. The search is case-insensitive.

Example stored line (pipe-separated):

```
03/01/2025|Jane Doe|EMP001|$20|8|8|8|8|8|40|$3200|$320
```

---

## Format of `payroll.txt`

Each record is appended as a single line with pipe separators:

```
Date|Full Name|Employee ID|$Wage|MonHours|TueHours|WedHours|ThuHours|FriHours|WeeklyHours|$MonthlyPay|$TaxAmounts...
```

`column -t -s "|"` is used for pretty display in the script.

---

## Known issues & caveats (please read)

* **Input validation**: The script assumes numeric integer inputs. Non-numeric input will break arithmetic operations.
* **Time granularity**: Only integer hours supported. No minutes/partials (e.g., `7.5`) — the script uses integer arithmetic.
* **Overnight shifts**: If `Time Out < Time In` (overnight work), the simple subtraction yields a negative hour. Not handled.
* **Unset tax variable in table**: The script sets different tax result variables in different branches (`tax`, `SECONDtax`, `THIRDtax`) and then writes all of them to the same record. Some fields may be empty depending on branch.
* **No concurrency or locking**: Multiple simultaneous runs can corrupt `payroll.txt`.
* **Security/privacy**: `payroll.txt` is plain text. The script notes the DB is for HR only, but there is no access control/encryption.
* **No header row check**: If you want a header row in `payroll.txt`, add it manually before first run.

---

## Suggested improvements (next steps)

If you want this to be production-ready or safer, consider:

* **Add input validation** (ensure numbers, valid dates).
* **Support fractional hours** (use `bc` or convert minutes to decimal).
* **Handle overnight shifts** (if `out < in`, add 24).
* **Use a single `tax` variable** so every record writes exactly one tax value.
* **Switch to CSV** (comma-separated) or proper CSV/JSON for compatibility with Excel/tools.
* **Lock file on write** (`flock`) to avoid concurrent write issues.
* **Encrypt or restrict access** to `payroll.txt` (file permissions, or store in a secure DB).
* **Add header row** to `payroll.txt` if you want column names.
* **Calculate monthly as average of 4.33 weeks** if you want calendar-accurate monthly pay (optional).
* **Add an “update” and “delete” record option** for corrections.

---

## Maintenance & debugging tips

* If `grep` returns nothing during search, run:

  ```bash
  cat payroll.txt
  ```

  to confirm contents.
* For safer arithmetic, quote variables and check with `[[ ]]` for numeric comparison:

  ```bash
  if [[ "$WEEKLY" -lt 32 ]]; then
    ...
  fi
  ```
* To format `payroll.txt` output when viewing in the terminal:

  ```bash
  cat payroll.txt | column -t -s "|"
  ```

---

## License & Notes

Use at your own risk. This is a learning/demo script — not production payroll software. If you plan to use it for real payroll or HR-sensitive data, implement validation, secure storage, and access controls first.

