"""Healthcare Operational Trend Analysis (Simulated Data)

Run (from repo root):
  python -m venv .venv
  # Windows: .venv\Scripts\activate
  # Mac/Linux: source .venv/bin/activate
  pip install -r requirements.txt
  python src/analyze.py
"""

from __future__ import annotations
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

DATA_PATH = "data/simulated_lab_data.csv"

def risk_score(row: pd.Series) -> int:
    score = 0
    if row.WBC > 20: score += 2
    elif row.WBC > 11: score += 1

    if row.HGB < 7: score += 2
    elif row.HGB < row.HGB_low: score += 1

    if row.Lactate >= 2.2: score += 2
    elif row.Lactate >= 1.8: score += 1

    if row.CRP >= 50: score += 2
    elif row.CRP >= 10: score += 1

    if row.PLT < 50: score += 2
    elif row.PLT < 150: score += 1

    return int(score)

def risk_level(score: int) -> str:
    if score >= 6: return "High"
    if score >= 3: return "Moderate"
    return "Low"

def main() -> None:
    df = pd.read_csv(DATA_PATH)
    df["collection_date"] = pd.to_datetime(df["collection_date"])
    df["risk_score"] = df.apply(risk_score, axis=1)
    df["risk_level"] = df["risk_score"].apply(risk_level)

    # Chart 1: Risk distribution
    plt.figure()
    df["risk_score"].value_counts().sort_index().plot(kind="bar")
    plt.title("Risk Score Distribution (Simulated Lab Dataset)")
    plt.xlabel("Risk score")
    plt.ylabel("Count of results")
    plt.tight_layout()
    plt.savefig("visuals/risk_distribution_py.png", dpi=200)
    plt.close()

    # Example patient: highest max risk
    pt = df.groupby("patient_id")["risk_score"].max().sort_values(ascending=False).index[0]
    g = df[df["patient_id"] == pt].sort_values("collection_date")

    plt.figure()
    plt.plot(g["collection_date"], g["WBC"], marker="o")
    plt.axhline(float(g["WBC_high"].iloc[0]), linestyle="--")
    plt.title(f"WBC Trend Over Time ({pt})")
    plt.xlabel("Collection date")
    plt.ylabel("WBC")
    plt.tight_layout()
    plt.savefig("visuals/wbc_trend_example_py.png", dpi=200)
    plt.close()

    print(f"Done. Example patient: {pt}. Charts saved to visuals/.")

if __name__ == "__main__":
    main()
