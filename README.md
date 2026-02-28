# Healthcare Operational Trend Analysis (Trend + Risk Scoring) 🧪📈

**Author:** Branden Bryant  
**Focus:** Healthcare Analytics • Operations Analytics • AI Systems Readiness

This repository contains a completed case study demonstrating how to clean healthcare-style lab data, perform **trend analysis**, and apply an explainable **risk scoring** approach for operational monitoring.

## Case Study Summary
**Business problem:** Labs generate high volumes of results; without standardized cleaning and visualization, teams often miss early trend signals and respond reactively.  
**Objective:** Convert lab-style results into operational intelligence by standardizing data, measuring trends over time, and flagging higher-risk patterns using transparent rules.

## Dataset
- `data/simulated_lab_data.csv` (simulated for safe public sharing)
- Includes patient draws over time and simplified reference ranges.

## Risk Scoring (Explainable Rules)
Per-result score using thresholds:
- WBC: >11 (+1), >20 (+2)
- HGB: below ref (+1), <7 (+2)
- Lactate: ≥1.8 (+1), ≥2.2 (+2)
- CRP: ≥10 (+1), ≥50 (+2)
- PLT: <150 (+1), <50 (+2)

Risk level:
- Low (0–2), Moderate (3–5), High (6+)

## Trend Logic (Operational Monitoring)
- Persistent High WBC (rolling last 3 results above ref high)
- HGB Decline Flag (negative slope across last 5 samples)

## Quantitative Impact (Simulated Dataset Analysis)

- Identified High-Risk classification in ~X% of total results

- Detected persistent abnormal WBC trends using rolling logic

- Flagged declining hemoglobin patterns using slope-based detection

- Reduced noise by categorizing raw lab values into 3 operational tiers (Low/Moderate/High)

## Visual Outputs
- `visuals/risk_distribution.png`
- `visuals/wbc_trend_example.png`
- `visuals/hgb_lactate_trend_example.png`

## Run (Python)
```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# Mac/Linux:
source .venv/bin/activate
pip install -r requirements.txt
python src/analyze.py
```

## Run (R)
Run in RStudio:
- `source("r/analysis.R")`

## SQL Examples
See: `sql/analysis_queries.sql`
