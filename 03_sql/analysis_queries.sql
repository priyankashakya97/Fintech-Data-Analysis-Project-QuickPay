-- Q1
SELECT 
    status, 
    COUNT(transaction_id) AS transaction_count
FROM 
    spreadsheet_workbook
GROUP BY 
    status
ORDER BY 
    transaction_count DESC;
-- Q2	
SELECT 
    merchant_name, 
    SUM(amount_usd) AS total_captured_gmv
FROM 
    spreadsheet_workbook
WHERE 
    status = 'Captured'
GROUP BY 
    merchant_name
ORDER BY 
    total_captured_gmv DESC;
-- Q3	
SELECT 
    merchant_name, 
    SUM(amount_usd) AS total_captured_gmv
FROM 
    spreadsheet_workbook
WHERE 
    status = 'Captured'
GROUP BY 
    merchant_name
ORDER BY 
    total_captured_gmv DESC
LIMIT 10;
-- Q4
SELECT 
    DATE(transaction_date) AS date,
    SUM(amount_usd) AS daily_gmv,
    COUNT(transaction_id) AS successful_transactions
FROM 
    spreadsheet_workbook
WHERE 
    status = 'Captured'
GROUP BY 
    DATE(transaction_date)
ORDER BY 
    date ASC;
-- Q5	
SELECT 
    merchant_name,
    COUNT(CASE WHEN status = 'Chargeback' THEN 1 END) AS chargeback_count,
    COUNT(transaction_id) AS total_transactions,
    (COUNT(CASE WHEN status = 'Chargeback' THEN 1 END) / COUNT(transaction_id)) * 100 AS chargeback_ratio
FROM 
    spreadsheet_workbook
GROUP BY 
    merchant_name
HAVING 
    chargeback_ratio > 1
ORDER BY 
    chargeback_ratio DESC;
-- Q6
SELECT 
    gateway_region,
    AVG(CASE WHEN risk_score = 'MISSING' THEN NULL ELSE CAST(risk_score AS UNSIGNED) END) AS avg_risk_score,
    COUNT(transaction_id) AS transaction_count
FROM 
    spreadsheet_workbook
GROUP BY 
    gateway_region
HAVING 
    avg_risk_score > 50 
    AND transaction_count > 20
ORDER BY 
    avg_risk_score DESC;
-- Q7	
SELECT 
    user_id, 
    user_name, 
    DATE(transaction_date) AS incident_date,
    COUNT(transaction_id) AS incident_count,
    GROUP_CONCAT(status) AS transaction_statuses
FROM 
    spreadsheet_workbook
WHERE 
    status LIKE 'Failed%' 
    OR status = 'Chargeback'
GROUP BY 
    user_id, 
    user_name, 
    DATE(transaction_date)
HAVING 
    incident_count >= 3
ORDER BY 
    incident_count DESC;
-- Q8	
SELECT 
    merchant_name,
    COUNT(transaction_id) AS chargeback_count,
    COUNT(DISTINCT user_id) AS unique_affected_users,
    SUM(amount_usd) AS total_chargeback_amount
FROM 
    spreadsheet_workbook
WHERE 
    status = 'Chargeback'
GROUP BY 
    merchant_name
ORDER BY 
    total_chargeback_amount DESC;
	
