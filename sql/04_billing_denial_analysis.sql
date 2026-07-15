/* =============================================================
   04_billing_denial_analysis.sql
   Goal: summarize insurance billing outcomes by payer —
   total billed, paid vs. denied dollars, and denial rate.

   Why it matters: denial-rate reporting is a core revenue-cycle
   KPI. This mirrors the insurance workflows I supported in IT:
   a denied claim triggers rework (correct the code, resubmit),
   and analytics teams quantify that cost.
   ============================================================= */

SELECT
    insurance_payer,
    COUNT(*)                                   AS total_claims,
    SUM(billed_amount)                         AS total_billed,
    -- conditional aggregation splits dollars by adjudication result
    SUM(CASE WHEN claim_status = 'Paid'   THEN billed_amount ELSE 0 END)
                                               AS paid_amount,
    SUM(CASE WHEN claim_status = 'Denied' THEN billed_amount ELSE 0 END)
                                               AS denied_amount,
    ROUND(100.0 * SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END)
        / COUNT(*), 1)                         AS denial_rate_pct
FROM patient_visits
WHERE data_source = 'Claims'                   -- billing rows only
GROUP BY insurance_payer
ORDER BY total_billed DESC;
