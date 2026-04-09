-- 1.2 What should be done in the next year to maximize store profits?
DROP VIEW IF EXISTS View_StoreProductSales;

CREATE SECURE VIEW View_StoreProductSales as

SELECT 
    StoreNumber,
    CalendarYear,
    ProductName,
    ProductType, 
    ProductCategory,
    SUM(SalesQuantity) as SalesQuantity,
    SUM(SalesAmount) as SalesAmount,
    SUM(SaleExtendedCost) as SaleExtendedCost,
    SUM(SaleTotalProfit) as SaleTotalProfit
FROM View_SalesActual t1
LEFT JOIN View_Store t2
ON t1.dimstoreid = t2.dimstoreid
INNER JOIN View_Date t3
ON t1.dimdateid = t3.dimdateid
INNER JOIN View_Product t4
ON t1.dimproductid = t4.dimproductid
WHERE StoreName IN ('Store Number 5', 'Store Number 8')
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1, 2, 3;

SELECT * FROM View_StoreProductSales

