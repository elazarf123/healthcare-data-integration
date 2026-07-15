/* =============================================================
   03_chronic_condition_timeline.sql
   Goal: track a chronic condition longitudinally — from first
   symptom (chronic cough, R05.3) to diagnosis refinement
   (J45.909 -> J45.30) to documented control.

   Technique: window functions build a patient journey view,
   ordering every touchpoint across all four source systems
   and measuring days between encounters (care-gap analysis).
   ============================================================= */

SELECT
    patient_id,
    visit_date,
    data_source,
    diagnosis_code,
    diagnosis_desc,
    -- sequence number across the patient's full journey
    ROW_NUMBER() OVER (
        PARTITION BY patient_id ORDER BY visit_date, record_id
    )                                          AS encounter_seq,
    -- days since the previous touchpoint (any source system);
    -- large gaps can indicate lapsed follow-up for chronic care
    JULIANDAY(visit_date) - JULIANDAY(
        LAG(visit_date) OVER (
            PARTITION BY patient_id ORDER BY visit_date, record_id
        )
    )                                          AS days_since_last_contact,
    notes
FROM patient_visits
WHERE diagnosis_code LIKE 'J45%'               -- asthma family
   OR diagnosis_code LIKE 'R05%'               -- cough (presenting symptom)
ORDER BY patient_id, visit_date, record_id;

/* PostgreSQL note: replace the JULIANDAY() arithmetic with
   visit_date - LAG(visit_date) OVER (...), which subtracts
   dates directly. */
