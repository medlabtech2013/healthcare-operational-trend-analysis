-- Healthcare Operational Trend Analysis (Simulated Data)
-- Load data/simulated_lab_data.csv into a table named: lab_results

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT patient_id) AS patients
FROM lab_results;

-- Risk level distribution computed in SQL
SELECT
  CASE
    WHEN (
      (CASE WHEN WBC > 20 THEN 2 WHEN WBC > 11 THEN 1 ELSE 0 END) +
      (CASE WHEN HGB < 7 THEN 2 WHEN HGB < HGB_low THEN 1 ELSE 0 END) +
      (CASE WHEN Lactate >= 2.2 THEN 2 WHEN Lactate >= 1.8 THEN 1 ELSE 0 END) +
      (CASE WHEN CRP >= 50 THEN 2 WHEN CRP >= 10 THEN 1 ELSE 0 END) +
      (CASE WHEN PLT < 50 THEN 2 WHEN PLT < 150 THEN 1 ELSE 0 END)
    ) >= 6 THEN 'High'
    WHEN (
      (CASE WHEN WBC > 20 THEN 2 WHEN WBC > 11 THEN 1 ELSE 0 END) +
      (CASE WHEN HGB < 7 THEN 2 WHEN HGB < HGB_low THEN 1 ELSE 0 END) +
      (CASE WHEN Lactate >= 2.2 THEN 2 WHEN Lactate >= 1.8 THEN 1 ELSE 0 END) +
      (CASE WHEN CRP >= 50 THEN 2 WHEN CRP >= 10 THEN 1 ELSE 0 END) +
      (CASE WHEN PLT < 50 THEN 2 WHEN PLT < 150 THEN 1 ELSE 0 END)
    ) >= 3 THEN 'Moderate'
    ELSE 'Low'
  END AS risk_level,
  COUNT(*) AS n
FROM lab_results
GROUP BY risk_level
ORDER BY n DESC;

-- Patients with frequent WBC above reference high
SELECT patient_id,
       SUM(CASE WHEN WBC > WBC_high THEN 1 ELSE 0 END) AS wbc_high_count,
       COUNT(*) AS total_draws,
       ROUND(1.0 * SUM(CASE WHEN WBC > WBC_high THEN 1 ELSE 0 END) / COUNT(*), 3) AS pct_high
FROM lab_results
GROUP BY patient_id
HAVING total_draws >= 10
ORDER BY pct_high DESC, wbc_high_count DESC
LIMIT 10;

-- Simple trend proxy: last minus first WBC per patient
WITH first_last AS (
  SELECT patient_id,
         MIN(collection_date) AS first_date,
         MAX(collection_date) AS last_date
  FROM lab_results
  GROUP BY patient_id
)
SELECT lr1.patient_id,
       lr_first.WBC AS first_wbc,
       lr_last.WBC AS last_wbc,
       ROUND(lr_last.WBC - lr_first.WBC, 2) AS delta_wbc
FROM first_last lr1
JOIN lab_results lr_first ON lr_first.patient_id = lr1.patient_id AND lr_first.collection_date = lr1.first_date
JOIN lab_results lr_last  ON lr_last.patient_id  = lr1.patient_id AND lr_last.collection_date  = lr1.last_date
ORDER BY delta_wbc DESC
LIMIT 10;

-- Daily averages (operations view)
SELECT collection_date,
       ROUND(AVG(WBC), 2) AS avg_wbc,
       ROUND(AVG(HGB), 2) AS avg_hgb,
       ROUND(AVG(Lactate), 2) AS avg_lactate,
       COUNT(*) AS draws
FROM lab_results
GROUP BY collection_date
ORDER BY collection_date;
