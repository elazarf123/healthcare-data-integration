"""
visit_analysis.py
Python (pandas) pass over the cleaned patient-visit dataset — the same
questions answered in the Excel lab and sql/ scripts, done a third way
to complete the Ask -> Prepare -> Process -> Analyze -> Share workflow.

Outputs:
  analysis/source_summary.md    — findings write-up
  analysis/billing_by_status.png — paid vs denied dollars chart

Run:  python analysis/visit_analysis.py   (from repo root)
"""

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

BASE = Path(__file__).resolve().parent.parent
df = pd.read_csv(BASE / "data" / "cleaned" / "patient_visits_cleaned.csv",
                 parse_dates=["visit_date"])

# --- 1. Records by source system (mirrors sql/01) ---------------------------
by_source = df.groupby("data_source").agg(
    records=("record_id", "count"),
    first=("visit_date", "min"),
    last=("visit_date", "max"),
)

# --- 2. Billing outcomes (mirrors sql/04) ------------------------------------
claims = df[df["data_source"] == "Claims"].copy()
billing = claims.groupby("claim_status")["billed_amount"].agg(["count", "sum"])
denied_dollars = billing.loc["Denied", "sum"] if "Denied" in billing.index else 0

# --- 3. Care timeline gaps (mirrors sql/03) -----------------------------------
timeline = df.sort_values(["visit_date", "record_id"]).copy()
timeline["days_since_last"] = timeline["visit_date"].diff().dt.days
max_gap = timeline["days_since_last"].max()

# --- chart: dollars by claim status -------------------------------------------
fig, ax = plt.subplots(figsize=(7, 4.5))
colors = {"Paid": "#2e7d32", "Denied": "#c0392b", "Pending": "#f39c12"}
ax.bar(billing.index, billing["sum"],
       color=[colors.get(s, "#888") for s in billing.index])
for i, (status, row) in enumerate(billing.iterrows()):
    ax.text(i, row["sum"] + 5, f"${row['sum']:.0f}\n({int(row['count'])} claims)",
            ha="center", fontsize=10)
ax.set_ylabel("Billed dollars")
ax.set_title("Billing Outcomes by Claim Status — PT-4471 (synthetic)")
fig.tight_layout()
fig.savefig(Path(__file__).parent / "billing_by_status.png", dpi=120)

# --- findings ------------------------------------------------------------------
lines = [
    "# Python Analysis — Findings",
    "",
    "Same dataset, third tool: after Excel (cleaning) and SQL (querying),",
    "this pandas analysis reproduces and extends the lab's findings.",
    "",
    "## Records by source system",
    "",
    by_source.to_markdown(),
    "",
    "## Billing outcomes",
    "",
    billing.rename(columns={"count": "claims", "sum": "dollars"}).to_markdown(),
    "",
    f"The single denial (${denied_dollars:.2f}) came from the diagnosis-coding",
    "mismatch on 2025-03-15 — resubmitted with the corrected ICD-10 code and paid.",
    "In a real revenue cycle, that rework loop is measurable cost.",
    "",
    "## Care continuity",
    "",
    f"Largest gap between touchpoints across all four systems: **{max_gap:.0f} days**.",
    "For chronic-condition management, gap analysis like this is how care teams",
    "spot patients drifting out of follow-up.",
]
(Path(__file__).parent / "source_summary.md").write_text("\n".join(lines))

print(by_source.to_string())
print(billing.to_string())
print(f"max care gap: {max_gap:.0f} days")
print("Wrote source_summary.md + billing_by_status.png")
