/* =============================================================
   02_ehr_claims_reconciliation.sql
   Goal: join clinical (EHR) records to financial (Claims)
   records for the same patient and visit date, then flag
   diagnosis-code mismatches.

   Why it matters: EHR and Claims systems are maintained by
   different teams and often disagree. A mismatch between the
   documented diagnosis and the billed diagnosis is a common
   root cause of claim denials — exactly what happened on
   2025-03-15 in this dataset.
   ============================================================= */

SELECT
    ehr.patient_id,
    ehr.visit_date,
    ehr.diagnosis_code                         AS ehr_diagnosis,
    clm.diagnosis_code                         AS billed_diagnosis,
    clm.procedure_code,
    clm.billed_amount,
    clm.insurance_payer,
    clm.claim_status,
    -- flag rows where the billed code disagrees with the chart
    CASE
        WHEN ehr.diagnosis_code = clm.diagnosis_code THEN 'Match'
        ELSE 'MISMATCH - review before adjudication'
    END                                        AS coding_check
FROM patient_visits AS ehr
INNER JOIN patient_visits AS clm
    ON  ehr.patient_id = clm.patient_id
    AND ehr.visit_date = clm.visit_date       -- same encounter
WHERE ehr.data_source = 'EHR'
  AND clm.data_source = 'Claims'
ORDER BY ehr.visit_date, clm.claim_status;
