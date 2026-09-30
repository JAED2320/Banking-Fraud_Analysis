# Banking Fraud Pattern Analysis

## The Problem
Banks process millions of transactions daily, and fraud hides in a tiny fraction of them — often less than 1%. Finding that fraction isn't about one magic rule; it's about spotting *combinations* of signals that, together, separate a suspicious transaction from a normal one.

This project puts on the hat of a fraud analytics analyst at a bank, working through a year's worth of transaction history to answer one core question:

**Where and how does fraud actually happen — and what patterns can help a risk team catch it faster?**

## The Data
A simulated credit card transaction dataset (Sparkov-generated, sourced from Kaggle: [kartik2112/fraud-detection](https://www.kaggle.com/datasets/kartik2112/fraud-detection)) covering ~1.85 million transactions across 1,000 customers and 800 merchants (2019-2020). For this project, a stratified sample of 25,000 transactions (300 fraud, 24,700 legitimate) was used, preserving the real-world fraud rate (~1.2%).

*Note: real, individual bank transaction data is never publicly available for privacy/legal reasons — this simulated dataset is a widely-used, realistic stand-in, common in fraud-detection research and portfolios.*

## The Approach
Three layers, each answering the same business questions in a different way:

**1. Python (cleaning + EDA)**
Cleaned the data, engineered new features (customer age, hour of day, day of week, distance between cardholder and merchant using the Haversine formula), and explored 6 key patterns visually.

**2. SQL (MySQL)**
Rebuilt the same questions as production-style SQL — including window functions (`RANK`, `DENSE_RANK`), CTEs with `LAG()` for month-over-month trend analysis, `CASE WHEN` risk bucketing, and subqueries.

**3. Power BI**
An interactive one-page dashboard connecting live to the MySQL database, with KPI cards, category/hour/day-of-week breakdowns, and slicers.

## Key Findings

1. **Category matters — a lot.** Online/e-commerce categories (`shopping_net`, `misc_net`) and `grocery_pos` show fraud rates of 2.8-3.2%, roughly 6-8x higher than low-risk categories like `food_dining` (0.33%).

2. **Fraud is a night owl.** Fraud rate jumps from under 0.4% during the day to 3-6.4% between 10 PM and 3 AM — by far the strongest single signal in the data.

3. **Fraud transactions run bigger.** Median fraud amount (~₹350) is roughly 7x the median legitimate transaction (~₹40-50).

4. **Amount + category together beat either alone.** Within the 3 riskiest categories, 100% of fraud cases occurred at ₹200+ — none in the low/medium amount range. Amount alone, however, is a weak signal on its own: the 20 largest transactions in the whole dataset (mostly `travel` bookings) were all legitimate.

5. **A combined risk score works.** Flagging transactions that hit all three signals at once (risky category + night hour + high amount) as "High Risk" produces a dramatically higher fraud concentration than looking at any single factor — a simple, explainable stand-in for what a real fraud-scoring model does.

6. **Fraud isn't concentrated in a few bad merchants.** The top "riskiest" merchants each had only 3-4 fraud cases — fraud here is a distributed pattern, not a few bad actors.

## Business Recommendation
A fraud team could get meaningful lift from a simple, explainable rule: **flag transactions that are simultaneously in a high-risk category, above ₹200, and occurring between 10 PM-3 AM** for priority review — rather than treating any single factor (amount, category, or time) as a standalone trigger.

## Tools
`Python (Pandas, Matplotlib, Seaborn)` · `MySQL` · `Power BI` · `Jupyter Notebook`

## Files in this repo
- `fraud_transaction.ipynb` — full cleaning, feature engineering, and EDA
- `fraud_transaction.sql` — all SQL analysis queries
- `fraud_transaction.pbix` — Power BI dashboard
- `data_clean/fraud_sample_25k.csv` — the cleaned, sampled dataset
- `charts/` — saved EDA visualizations
