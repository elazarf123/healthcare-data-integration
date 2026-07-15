# Data Dictionary — patient_visits

All data in this project is **fully fictitious** and generated for training purposes. No PHI is present.

| Column | Type | Description |
|---|---|---|
| record_id | INTEGER | Unique row identifier |
| patient_id | TEXT | De-identified patient key (e.g., PT-4471) |
| data_source | TEXT | Origin system: `EHR`, `Claims`, `Registry`, `Clinical Trials` |
| visit_date | DATE | Date of encounter or record event (YYYY-MM-DD) |
| provider | TEXT | Treating provider or originating organization |
| diagnosis_code | TEXT | ICD-10-CM code (e.g., R05.3 chronic cough, J45.30 mild persistent asthma) |
| diagnosis_desc | TEXT | Diagnosis description as recorded by the source system |
| procedure_code | TEXT | CPT code (Claims records only, e.g., 99213 office visit, 94010 spirometry) |
| billed_amount | DECIMAL | Amount billed to payer (Claims records only) |
| insurance_payer | TEXT | Payer name (Claims records only) |
| claim_status | TEXT | `Paid`, `Denied`, or `Pending` (Claims records only) |
| notes | TEXT | Free-text clinical or administrative notes |

## Source system characteristics

- **EHR** — clinical truth: diagnoses, treatment decisions, outcomes. No billing fields.
- **Claims** — financial view: CPT codes, billed amounts, payer, adjudication status. Diagnosis codes may lag or mismatch the EHR (see records 1007–1008: a denial caused by a coding mismatch, then a corrected resubmission).
- **Registry** — periodic population-health snapshots; sparse fields, standardized diagnosis only.
- **Clinical Trials** — screening/enrollment events; no billing data.

## Cleaning rules applied (Excel lab → `data/cleaned/`)

1. Standardized `diagnosis_desc` casing and terminology.
2. Validated `visit_date` format (ISO 8601).
3. Classified every record by `data_source`.
4. Flagged the denied/resubmitted claim pair rather than deleting it — denials are analytically meaningful.
