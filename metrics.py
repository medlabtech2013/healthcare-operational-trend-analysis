import pandas as pd

df = pd.read_csv("data/simulated_lab_data.csv")

# Risk categories
df["risk_score"] = df.apply(lambda r: (
     (2 if r["WBC"] > 20 else 1 if r["WBC"] > 11 else 0)
   + (2 if r["HGB"] < 7 else 1 if r["HGB"] < r["HGB_low"] else 0)
   + (2 if r["Lactate"] >= 2.2 else 1 if r["Lactate"] >= 1.8 else 0)
   + (2 if r["CRP"] >= 50 else 1 if r["CRP"] >= 10 else 0)
   + (2 if r["PLT"] < 50 else 1 if r["PLT"] < 150 else 0)
), axis=1)

total = len(df)
high = len(df[df["risk_score"] >= 6])
mod = len(df[(df["risk_score"] >= 3) & (df["risk_score"] < 6)])
low = len(df[df["risk_score"] <= 2])

print("Total records:", total)
print("High risk %:", round(100 * high / total, 2))
print("Moderate risk %:", round(100 * mod / total, 2))
print("Low risk %:", round(100 * low / total, 2))