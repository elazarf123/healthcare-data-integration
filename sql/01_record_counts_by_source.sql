/* =============================================================
   01_record_counts_by_source.sql
   Goal: replicate the Excel lab's source-classification step.

   Counts how many records each source system contributed and
   shows each source's share of the total dataset. In a real
   integration project this is the first sanity check: it tells
   you whether a feed is missing or duplicated before any
   analysis begins.
   ============================================================= */

SELECT
    data_source,
    COUNT(*)                                   AS record_count,
    -- date range confirms each feed covers the expected period
    MIN(visit_date)                            AS earliest_record,
    MAX(visit_date)                            AS latest_record,
    -- share of total, rounded to 1 decimal
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM patient_visits), 1)
                                               AS pct_of_total
FROM patient_visits
GROUP BY data_source
ORDER BY record_count DESC;
