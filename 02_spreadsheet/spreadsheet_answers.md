# Spreadsheet Answers

## Cleaning Steps
Merchant Names: Used =PROPER(TRIM()) to remove extra spaces and fix inconsistent casing (e.g., alpha mart -> Alpha Mart).

## Standardization Rules
Merchant Names: Used =PROPER(TRIM()) to remove extra spaces and fix inconsistent casing (e.g., alpha mart -> Alpha Mart).

amount_usd : =ARRAYFORMULA(IF(A2:A="","",
IFERROR(
E2:E*XLOOKUP(
TEXT(B2:B,"m/d/yyyy")&UPPER(TRIM(F2:F)),
TEXT(IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!A2:A"),"m/d/yyyy")&
UPPER(TRIM(IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!B2:B"))),
IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!C2:C")
),
0
)))

Date Formats: Standardized the raw d/m/yyyy format into a clean dd-mm-yyyy format using inbuilt date Formula.

Status Values: Standardized statuses to a consistent "Proper Case" format (e.g., captured, CAPTURED -> Captured).

Risk Scores: Extracted numeric values from text strings (e.g., score:62 $\rightarrow$ 62) to allow for mathematical flags.
=ARRAYFORMULA(IF(A2:A="", "", IF(LEN(J2:J), IFERROR(VALUE(REGEXEXTRACT(TO_TEXT(J2:J), "\d+")), J2:J), "MISSING")))

Gateway Reason: Used this formula to convert =ARRAYFORMULA(IF(A2:A="", "", IF(L2:L<>"", UPPER(TRIM(L2:L)), "REGION_MISSING")))

User Name: To identify the names associated with each transaction, we used an XLOOKUP combined with IMPORTRANGE to fetch data from the merchant_master file.
=ARRAYFORMULA(IF(A2:A="", "", XLOOKUP(D2:D, IMPORTRANGE("107uLiIxq881z3WogkUxYZvLlY2zVtE2gcYTnYdvS-xs", "merchant_master!B2:B"), IMPORTRANGE("107uLiIxq881z3WogkUxYZvLlY2zVtE2gcYTnYdvS-xs", "merchant_master!C2:E"), "Merchant Not Found")))

High value flag : =ARRAYFORMULA(IF(A2:A="", "", IF(
  ((L2:L="APAC") * (G2:G > 5000)) + 
  ((L2:L="EU") * (G2:G > 6000)) + 
  ((L2:L="US") * (G2:G > 7000)), 
  1, 0)))
  
High Risk Flag : =ARRAYFORMULA(IF(A2:A="", "", IF(
  (K2:K >= 70) + (REGEXMATCH(LOWER(I2:I), "chargeback")), 
  1, 0)))
## Lookup and Enrichment Logic
1. Merchant Name Standardization
Source Data: transactions_raw.csv (Column C)

Logic: Applied a cleaning layer to remove whitespace and normalize casing.

Formula:

=PROPER(TRIM(C2))

Impact: Converted inconsistent entries like " alpha mart " or "ALPHA MART" into a uniform "Alpha Mart".

2. Currency Conversion (USD Reporting)
Source Data: exchange_rates.csv

Logic: Performed a cross-file lookup using a Concatenated Key (Date + Currency). This ensures the exact exchange rate for a specific day is applied to the raw amount.

Formula:

=ARRAYFORMULA(IF(A2:A="","",
IFERROR(
E2:E*XLOOKUP(
TEXT(B2:B,"m/d/yyyy")&UPPER(TRIM(F2:F)),
TEXT(IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!A2:A"),"m/d/yyyy")&
UPPER(TRIM(IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!B2:B"))),
IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!C2:C")
),
0
)))


Impact: Standardized all global transactions into a single reporting currency (USD) for accurate financial analysis.

3. User & Merchant Enrichment
Source Data: merchant_master.csv

Logic: Used the user_id as a primary key to fetch secondary metadata.

Attributes Pulled:

User Name: Mapped U001 → "Aisha Khan".

Gateway Region: Mapped user_id to geographical regions (e.g., APAC).

Impact: Transformed anonymous transaction IDs into human-readable data points for behavioral tracking.

4. Automated Flagging Logic (Risk & Value)
High Value Flag: Categorizes transactions where the converted amount_usd exceeds $5,000.

High Risk Flag: A composite logic that triggers if Risk Score ≥ 70 OR the Transaction Status contains the word "chargeback".

Formula:

=ARRAYFORMULA(IF(A2:A="", "", IF(
  (K2:K >= 70) + (REGEXMATCH(LOWER(I2:I), "chargeback")), 
  1, 0)))

## Final Answers
Total raw rows: 30 (Transaction IDs T001 through T031).

Total cleaned rows: 30 (All records were successfully standardized for name, date, and currency).

Invalid or missing rows handled: 1 (Transaction T011 had a missing risk score and status timeout; handled using IFERROR and "MISSING" flags), 9 rows handled in gateway_region with REGION_MISSING. 

Top region by GMV: APAC (Driven primarily by high-volume transactions in USD from Alpha Mart and Beta Stores).

Number of high value transactions: 9 (Transactions where amount_usd > $5,000).

Number of high risk transactions: 6 (Includes all 'Chargeback' statuses and transactions with risk_score > 70).

Top merchant by captured GMV: Beta Stores (Led by high-value captured transactions such as T010 at ~$7,381).

## Formula Samples
merchant_name:
=PROPER(TRIM(C2))

amount_usd:
=ARRAYFORMULA(IF(A2:A="","",
IFERROR(
E2:E*XLOOKUP(
TEXT(B2:B,"m/d/yyyy")&UPPER(TRIM(F2:F)),
TEXT(IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!A2:A"),"m/d/yyyy")&
UPPER(TRIM(IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!B2:B"))),
IMPORTRANGE("15EtSBFrUOLkr-THLYua4fjE3pDzvWDijMRScL6aQ264","exchange_rates!C2:C")
),
0
)))

status:
=PROPER(TRIM(H2))

risk_Score:
=ARRAYFORMULA(IF(A2:A="", "", IF(LEN(J2:J), IFERROR(VALUE(REGEXEXTRACT(TO_TEXT(J2:J), "\d+")), J2:J), "MISSING")))

gateway_reason:
=ARRAYFORMULA(IF(A2:A="", "", IF(L2:L<>"", UPPER(TRIM(L2:L)), "REGION_MISSING")))

user_name:

=ARRAYFORMULA(IF(A2:A="", "", XLOOKUP(D2:D, IMPORTRANGE("107uLiIxq881z3WogkUxYZvLlY2zVtE2gcYTnYdvS-xs", "merchant_master!B2:B"), IMPORTRANGE("107uLiIxq881z3WogkUxYZvLlY2zVtE2gcYTnYdvS-xs", "merchant_master!C2:E"), "Merchant Not Found")))

high_risk_value:
=ARRAYFORMULA(IF(A2:A="", "", IF(
  ((L2:L="APAC") * (G2:G > 5000)) + 
  ((L2:L="EU") * (G2:G > 6000)) + 
  ((L2:L="US") * (G2:G > 7000)), 
  1, 0)))
  
high_risk_flag
=ARRAYFORMULA(IF(A2:A="", "", IF(
  (K2:K >= 70) + (REGEXMATCH(LOWER(I2:I), "chargeback")), 
  1, 0)))


