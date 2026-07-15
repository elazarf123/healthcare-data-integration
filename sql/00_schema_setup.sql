/* =============================================================
   00_schema_setup.sql
   Creates the patient_visits table and loads the sample dataset.

   Purpose: reproduces the Excel lab's cleaned dataset as a
   relational table so every downstream query is runnable.
   Dialect: standard ANSI SQL (tested on SQLite; compatible with
   PostgreSQL and SQL Server with minor type tweaks).
   All data is fictitious — no PHI.
   ============================================================= */

DROP TABLE IF EXISTS patient_visits;

CREATE TABLE patient_visits (
    record_id       INTEGER PRIMARY KEY,   -- unique row ID
    patient_id      TEXT    NOT NULL,      -- de-identified patient key
    data_source     TEXT    NOT NULL,      -- EHR | Claims | Registry | Clinical Trials
    visit_date      DATE    NOT NULL,
    provider        TEXT,
    diagnosis_code  TEXT,                  -- ICD-10-CM
    diagnosis_desc  TEXT,
    procedure_code  TEXT,                  -- CPT (Claims only)
    billed_amount   DECIMAL(10,2),         -- Claims only
    insurance_payer TEXT,                  -- Claims only
    claim_status    TEXT,                  -- Paid | Denied | Pending
    notes           TEXT
);

INSERT INTO patient_visits VALUES
(1001,'PT-4471','EHR','2025-01-12','Dr. Amara Osei','R05.3','Chronic Cough',NULL,NULL,NULL,NULL,'Initial visit - persistent cough 9 weeks'),
(1002,'PT-4471','Claims','2025-01-12','Dr. Amara Osei','R05.3','Chronic Cough','99213',145.00,'BlueShield PPO','Paid',NULL),
(1003,'PT-4471','EHR','2025-02-03','Dr. Amara Osei','J45.909','Asthma Unspecified',NULL,NULL,NULL,NULL,'Spirometry ordered'),
(1004,'PT-4471','Claims','2025-02-03','Dr. Amara Osei','J45.909','Asthma Unspecified','94010',210.00,'BlueShield PPO','Paid','Spirometry'),
(1005,'PT-4471','Registry','2025-02-10','State Asthma Registry','J45.909','Asthma Unspecified',NULL,NULL,NULL,NULL,'Enrolled in state chronic disease registry'),
(1006,'PT-4471','EHR','2025-03-15','Dr. Amara Osei','J45.909','Asthma - Mild Persistent',NULL,NULL,NULL,NULL,'Inhaled corticosteroid started'),
(1007,'PT-4471','Claims','2025-03-15','Dr. Amara Osei','J45.909','Asthma - Mild Persistent','99214',185.00,'BlueShield PPO','Denied','Coding mismatch - resubmitted'),
(1008,'PT-4471','Claims','2025-03-15','Dr. Amara Osei','J45.30','Asthma - Mild Persistent Uncomplicated','99214',185.00,'BlueShield PPO','Paid','Corrected claim'),
(1009,'PT-4471','Clinical Trials','2025-04-01','Northwind Research','J45.30','Asthma - Mild Persistent',NULL,NULL,NULL,NULL,'Screened for inhaler adherence study NCT-0000000'),
(1010,'PT-4471','EHR','2025-05-20','Dr. Amara Osei','J45.30','Asthma - Mild Persistent Controlled',NULL,NULL,NULL,NULL,'Symptoms improved - cough resolved'),
(1011,'PT-4471','Claims','2025-05-20','Dr. Amara Osei','J45.30','Asthma - Mild Persistent Uncomplicated','99213',145.00,'BlueShield PPO','Paid','Follow-up'),
(1012,'PT-4471','Registry','2025-06-01','State Asthma Registry','J45.30','Asthma - Mild Persistent',NULL,NULL,NULL,NULL,'Quarterly registry status update - controlled');
