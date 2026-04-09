---- 1. Give an overall assessment of stores number 5 and 8’s sales.
-- How are they performing compared to target? Will they meet their 2014 target?
-- Should either store be closed? Why or why not?
DROP VIEW IF EXISTS View_RealvsTarget;

CREATE SECURE VIEW View_RealvsTarget as
SELECT 
    StoreNumber, 
    CalendarYear,
    ROUND(SUM(RealSalesAmount), 0) as RealSalesAmount,
    ROUND(SUM(TargetSalesAmount), 0) as TargetSalesAmount,
    ROUND(SUM(RealSalesAmount) - SUM(TargetSalesAmount), 0) as SalesAmountGap
FROM(
SELECT DISTINCT 
    StoreNumber, 
    CalendarYear, 
    SUM(SalesAmount) as RealSalesAmount, 
    TargetSalesAmount
FROM View_SalesActual t1
LEFT JOIN View_Store t2
ON t1.dimstoreid = t2.dimstoreid
INNER JOIN View_Date t3
ON t1.dimdateid = t3.dimdateid
LEFT JOIN View_SRCSalesTarget t4
ON t1.dimstoreid = t4.dimstoreid
AND t1.dimdateid = t4.dimdateid
WHERE StoreNumber IN (5, 8)
GROUP BY 1, 2, 4) t
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT * FROM View_RealvsTarget

