---- 3. Assess product sales by day of the week at stores 5 and 8. What can we learn about sales trends?
DROP VIEW IF EXISTS View_StoreSalesOverWeek;

CREATE SECURE VIEW View_StoreSalesOverWeek as

SELECT
    StoreNumber,
    CalendarYear,
    DayNameOfWeek = 'Mon' THEN 1
         WHEN DayNameOfWeek = 'Tue' THEN 2
         WHEN DayNameOfWeek = 'Wed' THEN 3
         WHEN DayNameOfWeek = 'Thu' THEN 4
         WHEN DayNameOfWeek = 'Fri' THEN 5
         WHEN DayNameOfWeek = 'Sat' THEN 6
         WHEN DayNameOfWeek = 'Sun' THEN 7
         END as DayOfWeek,   
    SUM(SalesQuantity) as SalesQuantity
FROM View_SalesActual t1
LEFT JOIN View_Store t2
ON t1.dimstoreid = t2.dimstoreid
INNER JOIN View_Date t3
ON t1.dimdateid = t3.dimdateid
WHERE StoreName IN ('Store Number 5', 'Store Number 8')
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;
    
SELECT * FROM View_StoreSalesOverWeek

