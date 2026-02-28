# Healthcare Operational Trend Analysis (Simulated Data)
# Run from repo root in RStudio: source("r/analysis.R")

library(tidyverse)
library(lubridate)

df <- read_csv("data/simulated_lab_data.csv") %>%
  mutate(collection_date = ymd(collection_date))

calc_risk <- function(WBC, HGB, HGB_low, PLT, CRP, Lactate) {
  score <- 0
  if (WBC > 20) score <- score + 2 else if (WBC > 11) score <- score + 1
  if (HGB < 7) score <- score + 2 else if (HGB < HGB_low) score <- score + 1
  if (Lactate >= 2.2) score <- score + 2 else if (Lactate >= 1.8) score <- score + 1
  if (CRP >= 50) score <- score + 2 else if (CRP >= 10) score <- score + 1
  if (PLT < 50) score <- score + 2 else if (PLT < 150) score <- score + 1
  score
}

df <- df %>%
  rowwise() %>%
  mutate(risk_score = calc_risk(WBC, HGB, HGB_low, PLT, CRP, Lactate),
         risk_level = case_when(
           risk_score >= 6 ~ "High",
           risk_score >= 3 ~ "Moderate",
           TRUE ~ "Low"
         )) %>%
  ungroup()

p1 <- df %>%
  count(risk_score) %>%
  ggplot(aes(x = factor(risk_score), y = n)) +
  geom_col() +
  labs(title = "Risk Score Distribution (Simulated Lab Dataset)",
       x = "Risk score", y = "Count of results")

ggsave("visuals/risk_distribution_r.png", p1, width = 8, height = 5, dpi = 200)

pt <- df %>% group_by(patient_id) %>% summarize(max_risk = max(risk_score)) %>%
  arrange(desc(max_risk)) %>% slice(1) %>% pull(patient_id)

g <- df %>% filter(patient_id == pt) %>% arrange(collection_date)

p2 <- ggplot(g, aes(collection_date, WBC)) +
  geom_line() + geom_point() +
  geom_hline(aes(yintercept = unique(WBC_high)), linetype = "dashed") +
  labs(title = paste0("WBC Trend Over Time (", pt, ")"),
       x = "Collection date", y = "WBC (x10^3/uL)")

ggsave("visuals/wbc_trend_example_r.png", p2, width = 8, height = 5, dpi = 200)
