# Python Analysis — Findings

Same dataset, third tool: after Excel (cleaning) and SQL (querying),
this pandas analysis reproduces and extends the lab's findings.

## Records by source system

| data_source     |   records | first               | last                |
|:----------------|----------:|:--------------------|:--------------------|
| Claims          |         5 | 2025-01-12 00:00:00 | 2025-05-20 00:00:00 |
| Clinical Trials |         1 | 2025-04-01 00:00:00 | 2025-04-01 00:00:00 |
| EHR             |         4 | 2025-01-12 00:00:00 | 2025-05-20 00:00:00 |
| Registry        |         2 | 2025-02-10 00:00:00 | 2025-06-01 00:00:00 |

## Billing outcomes

| claim_status   |   claims |   dollars |
|:---------------|---------:|----------:|
| Denied         |        1 |       185 |
| Paid           |        4 |       685 |

The single denial ($185.00) came from the diagnosis-coding
mismatch on 2025-03-15 — resubmitted with the corrected ICD-10 code and paid.
In a real revenue cycle, that rework loop is measurable cost.

## Care continuity

Largest gap between touchpoints across all four systems: **49 days**.
For chronic-condition management, gap analysis like this is how care teams
spot patients drifting out of follow-up.