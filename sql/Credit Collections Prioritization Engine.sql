create database credit_collections;
use credit_collections;
show tables;
drop table loans;
describe collections;
select * from customers;
select * from loans;
SELECT COUNT(*) FROM loans;
select * from collections_status_clean;
-- Total Outstanding Portfolio
select round(sum(Outstanding_Amount), 2) as Total_Outstanding from collections;
-- Recovery Rate %
select round(sum(Amount_Recovered)/sum(Outstanding_Amount)*100, 2) as Recovery_Rate
from collections;
-- High Risk Accounts (60+ DPD)
select * from collections
where Days_Past_Due >= 60;
select * from loans_clean;
describe loans_clean;
alter table loans_clean
modify Start_Date Date;
drop table if exists loans;
rename table loans_clean to loans;
show tables;
select * from loans;
select * from collectors;
drop table if exists collectors_clean;
-- City-wise Outstanding
select * from collections;
select * from customers;
SELECT c.City,
ROUND(SUM(col.Outstanding_Amount),2) AS outstanding_amt
FROM customers c
JOIN loans l ON c.Customer_ID = l.Customer_ID
JOIN collections col ON l.Loan_ID = col.Loan_ID
GROUP BY c.City
ORDER BY outstanding_amt DESC;
select * from customers;
select avg(EMI_Amount) from loans;
select * from collections;
SELECT 
    l.Loan_ID,
    c.City,
    l.Loan_Type,
    col.Outstanding_Amount,
    col.Days_Past_Due,
    col.Missed_EMIs,
    col.Contact_Response,

    (
        (col.Outstanding_Amount / 1000) +
        (col.Days_Past_Due * 2) +
        (col.Missed_EMIs * 10) +

        CASE
            WHEN col.Contact_Response = 'No Answer' THEN 30
            WHEN col.Contact_Response = 'Promise to Pay' THEN 15
            ELSE 5
        END

    ) AS Priority_Score

FROM loans l
JOIN customers c 
    ON l.Customer_ID = c.Customer_ID
JOIN collections col
    ON l.Loan_ID = col.Loan_ID
ORDER BY Priority_Score DESC;
