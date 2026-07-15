# Healthcare Data Integration: Reconciling EHR, Claims, Registry & Clinical Trial Records

**From fragmented source systems to a unified, query-ready patient view — in Excel and SQL.**

## Overview

Healthcare data rarely lives in one place. A single patient encounter generates records in the EHR (clinical documentation), the claims system (billing and adjudication), disease registries (population health), and sometimes clinical trial databases — each with its own formats, terminology, and blind spots.

This project follows one fictitious patient's journey — a persistent cough that is ultimately diagnosed and managed as mild persistent asthma — across all four source systems. I first cleaned and classified the fragmented records in Excel, then rebuilt the entire workflow in SQL to demonstrate that the same analysis scales from a spreadsheet to a relational database.

> **Note:** All data is fully fictitious and created for training purposes. No PHI or real patient information appears anywhere in this repository.

## Why I Built This

I'm transitioning from IT Support — where I spent years supporting insurance systems and troubleshooting the workflows behind claims processing — into Healthcare Data Analytics. That background shows up directly in this project: I know from experience that a denied claim usually isn't a data-entry accident. It's a systems problem, often a diagnosis-coding mismatch between what the provider documented and what was billed. This dataset deliberately includes one such denial (records 1007–1008) so the analysis can surface and explain it.

## What This Project Demonstrates

- **Organizing fragmented healthcare data.** Classifying records by source system (EHR vs. Claims vs. Registry vs. Clinical Trials) and understanding what each source can and cannot tell you.
- **Data cleaning.** Standardizing diagnosis terminology, validating dates, and preserving analytically meaningful "bad" records (denials) instead of deleting them.
- **EHR-to-Claims reconciliation.** Self-joining clinical and billing records on patient and encounter date to flag diagnosis-code mismatches — the kind that cause denials.
- **Longitudinal analysis.** Using SQL window functions to sequence a chronic condition timeline (symptom → diagnosis → refinement → control) and measure care gaps between encounters.
- **Revenue-cycle metrics.** Computing payer-level billed/paid/denied dollars and denial rates with conditional aggregation.
- **Domain fluency.** ICD-10-CM diagnosis codes, CPT procedure codes, claim adjudication statuses, and payer workflows.

## Repository Structure

```
healthcare-data-integration/
├── README.md
├── .gitignore
├── data/
│   ├── raw/
│   │   └── patient_visits_raw.csv        # As-received: inconsistent casing, mixed terminology
│   └── cleaned/
│       └── patient_visits_cleaned.csv    # Output of the Excel cleaning lab
├── sql/
│   ├── 00_schema_setup.sql               # Table definition + sample data load
│   ├── 01_record_counts_by_source.sql    # Source-system profiling & completeness check
│   ├── 02_ehr_claims_reconciliation.sql  # Clinical-vs-billing join with mismatch flags
│   ├── 03_chronic_condition_timeline.sql # Longitudinal tracking with window functions
│   └── 04_billing_denial_analysis.sql    # Payer-level denial rates & dollars
└── docs/
    └── data_dictionary.md                # Column definitions & source-system notes
```

## Key Finding

The March 15 encounter produced a claim denial: the EHR documented `J45.909` (asthma, unspecified) while payer rules required the more specific `J45.30` (mild persistent asthma, uncomplicated). The reconciliation query (`02`) flags the mismatch automatically; the denial analysis (`04`) quantifies its cost. The corrected resubmission was paid — a complete denial-and-rework cycle captured in the data.

## How to Run

1. Open any SQL environment (SQLite is the fastest path — no server needed: `sqlite3 demo.db`).
2. Run `sql/00_schema_setup.sql` to create and populate the table.
3. Run scripts `01`–`04` in order. Each file's header comment explains the business question it answers.

## Skills & Tools

Excel (cleaning, classification, validation) · SQL (joins, self-joins, window functions, conditional aggregation, CTE-ready structure) · Healthcare data standards (ICD-10-CM, CPT) · Revenue-cycle concepts (adjudication, denials, resubmission)

## About Me

IT Support Specialist → Healthcare Data Analyst in progress. Years of hands-on experience supporting insurance systems and the people who use them, now applying that operational knowledge to the data itself.

📫 elazarferrer1@gmail.com · [GitHub](https://github.com/elazarf123)
