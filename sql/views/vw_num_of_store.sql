---- 4. Compare the performance of all stores located in states that have more than one store to all stores that are the only store in the state. What can we learn about having more than one store in a state?
DROP VIEW IF EXISTS View_NumOfStore;

CREATE SECURE VIEW View_NumOfStore as
SELECT 
    StoreNumber,
    NumOfStore,
    CalendarYear,
    SalesAmount
FROM(
SELECT DISTINCT
    StoreNumber,
    State_Province,
    CalendarYear,
    SUM(SalesAmount) as SalesAmount
FROM View_SalesActual t1
LEFT JOIN View_Store t2
ON t1.dimstoreid = t2.dimstoreid
INNER JOIN View_Date t3
ON t1.dimdateid = t3.dimdateid
INNER JOIN View_Location t4
ON t1.dimlocationid = t4.dimlocationid
WHERE StoreNumber != -1
GROUP BY 1, 2, 3) ta
INNER JOIN(
SELECT 
    State_Province,
    COUNT(DISTINCT StoreName) as NumOfStore
FROM View_Store t1
INNER JOIN View_Location t2
ON t1.dimlocationid = t2.dimlocationid
WHERE State_Province != 'Unknown'
GROUP BY 1) tb
ON ta.State_Province = tb.State_Province
ORDER BY 1;
    
SELECT * FROM View_NumOfStore

