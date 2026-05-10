# SQL Answers

## Q1

### Query
SELECT 
    status, 
    COUNT(transaction_id) AS transaction_count
FROM 
    spreadsheet_workbook
GROUP BY 
    status
ORDER BY 
    transaction_count DESC;
### Result Summary
| status             | transaction_count |
| ------------------ | ----------------- |
| Captured           | 19                |
| Failed E05 Timeout | 7                 |
| Chargeback         | 4                 |

## Q2

### Query	
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
	
### Result Summary
| merchant_name | total_captured_gmv |
| ------------- | ------------------ |
| Beta Stores   | 33431              |
| Alpha Mart    | 29984.5            |
| Delta Travels | 10300              |
| City Pharma   | 8640               |

## Q3

### Query		
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

### Result Summary
| merchant_name | total_captured_gmv |
| ------------- | ------------------ |
| Beta Stores   | 33431              |
| Alpha Mart    | 29984.5            |
| Delta Travels | 10300              |
| City Pharma   | 8640               |

## Q4

### Query	
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
	
### Result Summary
| date       | daily_gmv | successful_transactions |
| ---------- | --------- | ----------------------- |
| 2026-01-03 | 26382     | 5                       |
| 2026-02-03 | 11080     | 3                       |
| 2026-03-03 | 16031.5   | 4                       |
| 2026-04-03 | 13920     | 4                       |
| 2026-05-03 | 6136      | 1                       |
| 2026-06-03 | 8806      | 2                       |

## Q5

### Query		
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
	
### Result Summary
| merchant_name | chargeback_count | total_transactions | chargeback_ratio |
| ------------- | ---------------- | ------------------ | ---------------- |
| Eco Home      | 1                | 2                  | 50.0             |
| Delta Travels | 1                | 4                  | 25.0             |
| Beta Stores   | 1                | 11                 | 9.0909           |
| Alpha Mart    | 1                | 11                 | 9.0909           |


## Q6

### Query
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
	
### Result Summary
There are no results to be displayed.

## Q7

### Query	
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
	
### Result Summary
| user_id | user_name   | incident_date | incident_count | transaction_statuses                             |
| ------- | ----------- | ------------- | -------------- | ------------------------------------------------ |
| U008    | Rohan Mehta | 2026-05-03    | 3              | Failed E05 Timeout,Failed E05 Timeout,Chargeback |

## Q8

### Query	
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
	
### Result Summary
| merchant_name | chargeback_count | unique_affected_users | total_chargeback_amount |
| ------------- | ---------------- | --------------------- | ----------------------- |
| Eco Home      | 1                | 1                     | 6649                    |
| Alpha Mart    | 1                | 1                     | 5400                    |
| Delta Travels | 1                | 1                     | 2500                    |
| Beta Stores   | 1                | 1                     | 1711                    |

	
