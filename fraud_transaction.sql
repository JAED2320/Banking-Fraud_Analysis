CREATE DATABASE fraud_analysis;
use fraud_analysis;

SELECT 
    category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM transactions
GROUP BY category
ORDER BY fraud_rate_pct DESC;

SELECT
	merchant,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_count,
    DENSE_RANK() OVER(ORDER BY SUM(is_fraud) DESC) AS fraud_rank
FROM transactions
GROUP BY merchant
ORDER BY fraud_rank
LIMIT 10;


SELECT 
    hour,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM transactions
GROUP BY hour
ORDER BY hour;	


WITH monthly_stat AS (
	SELECT
		month,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraud_count,
        ROUND(AVG(is_fraud) * 100 , 2) AS fraud_rate_pct
	FROM transactions
    GROUP BY month
)

SELECT
	month,
    total_transactions,
    fraud_count,
    fraud_rate_pct,
    fraud_rate_pct - LAG(fraud_rate_pct) OVER(ORDER BY month) AS change_from_previous_month
FROM monthly_stat
ORDER BY month;

SELECT
	CASE
		WHEN amt < 50 THEN 'Low Amount'
        WHEN amt BETWEEN 50 AND 200 THEN 'Medium Amount'
        ELSE 'High Amount' 
	END AS amount_bucket,
    category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM transactions
WHERE category IN ('shopping_net', 'misc_net', 'grocery_pos')
GROUP BY amount_bucket, category
ORDER BY category, fraud_rate_pct DESC;


SELECT risk_level, COUNT(*) AS total_transactions, SUM(is_fraud) AS fraud_count, ROUND(AVG(is_fraud)*100,2) AS fraud_rate_pct
FROM (
    SELECT *,
        CASE 
            WHEN category IN ('shopping_net','misc_net','grocery_pos') AND hour IN (22,23,0,1,2,3) AND amt >= 200 THEN 'High Risk'
            WHEN category IN ('shopping_net','misc_net','grocery_pos') AND amt >= 200 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_level
    FROM transactions
) t
GROUP BY risk_level;

SELECT 
    day_of_week,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM transactions
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');