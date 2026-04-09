---- 2. Recommend separate 2013 and 2014 bonus amounts for each store if the total bonus pool for 2013 is $500,000 and the total bonus pool for 2014 is $400,000. Base your recommendation on how well the stores are selling Product Types of Men’s Casual and Women’s Casual.
SELECT 
    StoreNumber,
    CalendarYear,
    SUM(SalesQuantity) as SalesQuantity,
    SUM(SalesAmount) as SalesAmount,
    SUM(SaleTotalProfit) as SaleTotalProfit
FROM View_StoreProductSales
WHERE ProductType IN ('Men''s Casual', 'Women''s Casual')
GROUP BY 1, 2
ORDER BY 1, 2

