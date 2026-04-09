-- Create View of Fact Tables: Fact_SalesActual
DROP VIEW IF EXISTS View_SalesActual;

CREATE SECURE VIEW View_SalesActual as 	
    SELECT DISTINCT   
		  Dim_Product.DimProductID
		 ,-1 as DimStoreID
         ,-1 as DimResellerID
         ,Dim_Customer.DimCustomerID
         ,Dim_Channel.DimChannelID
         ,Dim_Date.DimDateID
         ,Dim_Location.DimLocationID
         ,Staging_SalesDetail.SalesHeaderID
         ,Staging_SalesDetail.SalesDetailID
         ,Staging_SalesDetail.SalesAmount
         ,Staging_SalesDetail.SalesQuantity
         ,Dim_Product.ProductRetailPrice AS SaleUnitPrice
         ,(Staging_SalesDetail.SalesQuantity*Dim_Product.ProductCost) AS SaleExtendedCost
         ,Staging_SalesDetail.SalesAmount-(Staging_SalesDetail.SalesQuantity*Dim_Product.ProductCost) AS SaleTotalProfit
	FROM Staging_SalesDetail
	INNER JOIN Dim_Product ON
	Dim_Product.SourceProductID = Staging_SalesDetail.ProductID
    INNER JOIN Staging_SalesHeader ON
    Staging_SalesHeader.SalesHeaderID = Staging_SalesDetail.SalesHeaderID    
    INNER JOIN Dim_Customer ON
	Dim_Customer.SourceCustomerID = Staging_SalesHeader.CustomerID
    INNER JOIN Dim_Channel ON
	Dim_Channel.SourceChannelID = Staging_SalesHeader.ChannelID
    INNER JOIN Dim_Date ON
	Dim_Date.FullDate = TO_DATE(Staging_SalesHeader.Date, 'MM/DD/YY')
    INNER JOIN Dim_Location ON
	Dim_Location.DimLocationID = Dim_Customer.DimLocationID
    UNION ALL(
	SELECT DISTINCT   
		  Dim_Product.DimProductID
		 ,-1 as DimStoreID
         ,Dim_Reseller.DimResellerID
         ,-1 as DimCustomerID
         ,Dim_Channel.DimChannelID
         ,Dim_Date.DimDateID
         ,Dim_Location.DimLocationID
         ,Staging_SalesDetail.SalesHeaderID
         ,Staging_SalesDetail.SalesDetailID
         ,Staging_SalesDetail.SalesAmount
         ,Staging_SalesDetail.SalesQuantity
         ,Dim_Product.ProductWholesalePrice AS SaleUnitPrice
         ,(Staging_SalesDetail.SalesQuantity*Dim_Product.ProductCost) AS SaleExtendedCost
         ,Staging_SalesDetail.SalesAmount-(Staging_SalesDetail.SalesQuantity*Dim_Product.ProductCost) AS SaleTotalProfit
	FROM Staging_SalesDetail
	INNER JOIN Dim_Product ON
	Dim_Product.SourceProductID = Staging_SalesDetail.ProductID
    INNER JOIN Staging_SalesHeader ON
    Staging_SalesHeader.SalesHeaderID = Staging_SalesDetail.SalesHeaderID    
    INNER JOIN Dim_Reseller ON
	Dim_Reseller.SourceResellerID = Staging_SalesHeader.ResellerID
    INNER JOIN Dim_Channel ON
	Dim_Channel.SourceChannelID = Staging_SalesHeader.ChannelID
    INNER JOIN Dim_Date ON
	Dim_Date.FullDate = TO_DATE(Staging_SalesHeader.Date, 'MM/DD/YY')
    INNER JOIN Dim_Location ON
	Dim_Location.DimLocationID = Dim_Reseller.DimLocationID
    )
    UNION ALL(
	SELECT DISTINCT   
		  Dim_Product.DimProductID
		 ,Dim_Store.DimStoreID
         ,-1 as DimResellerID
         ,-1 as DimCustomerID
         ,Dim_Channel.DimChannelID
         ,Dim_Date.DimDateID
         ,Dim_Location.DimLocationID
         ,Staging_SalesDetail.SalesHeaderID
         ,Staging_SalesDetail.SalesDetailID
         ,Staging_SalesDetail.SalesAmount
         ,Staging_SalesDetail.SalesQuantity
         ,Dim_Product.ProductRetailPrice AS SaleUnitPrice
         ,(Staging_SalesDetail.SalesQuantity*Dim_Product.ProductCost) AS SaleExtendedCost
         ,Staging_SalesDetail.SalesAmount-(Staging_SalesDetail.SalesQuantity*Dim_Product.ProductCost) AS SaleTotalProfit
	FROM Staging_SalesDetail
	INNER JOIN Dim_Product ON
	Dim_Product.SourceProductID = Staging_SalesDetail.ProductID
    INNER JOIN Staging_SalesHeader ON
    Staging_SalesHeader.SalesHeaderID = Staging_SalesDetail.SalesHeaderID    
    INNER JOIN Dim_Store ON
	Dim_Store.SourceStoreID = Staging_SalesHeader.StoreID
    INNER JOIN Dim_Channel ON
	Dim_Channel.SourceChannelID = Staging_SalesHeader.ChannelID
    INNER JOIN Dim_Date ON
	Dim_Date.FullDate = TO_DATE(Staging_SalesHeader.Date, 'MM/DD/YY')
    INNER JOIN Dim_Location ON
	Dim_Location.DimLocationID = Dim_Store.DimLocationID
    )
    ;

SELECT * FROM View_SalesActual


-- Create View of Fact Tables: Fact_SRCSalesTarget
DROP VIEW IF EXISTS View_SRCSalesTarget;

CREATE SECURE VIEW View_SRCSalesTarget as
	SELECT DISTINCT   
		  Dim_Store.DimStoreID
		 ,-1 as DimResellerID
         ,Dim_Channel.DimChannelID
		 ,t2.DimDateID
         ,Staging_TargetDataChannel.TargetSalesAmount
	FROM Staging_TargetDataChannel
	INNER JOIN Dim_Store ON
    Dim_Store.StoreName = Staging_TargetDataChannel.TargetName
    INNER JOIN Dim_Channel ON
    Dim_Channel.ChannelName = Staging_TargetDataChannel.ChannelName
    INNER JOIN(
    SELECT *
    ,ROW_NUMBER() OVER(PARTITION BY CalendarYear ORDER BY FullDate) as RANKING
    FROM Dim_Date
    )t2 ON
    t2.CalendarYear = Staging_TargetDataChannel.Year and RANKING = 1
    UNION ALL(
	SELECT DISTINCT   
		  -1 as DimStoreID
		 ,Dim_Reseller.DimResellerID
         ,Dim_Channel.DimChannelID
		 ,t3.DimDateID
         ,Staging_TargetDataChannel.TargetSalesAmount
	FROM Staging_TargetDataChannel
	INNER JOIN Dim_Reseller ON
    Dim_Reseller.ResellerName = Staging_TargetDataChannel.TargetName
    INNER JOIN Dim_Channel ON
    Dim_Channel.ChannelName = Staging_TargetDataChannel.ChannelName
    INNER JOIN(
    SELECT *
    ,ROW_NUMBER() OVER(PARTITION BY CalendarYear ORDER BY FullDate) as RANKING
    FROM Dim_Date
    )t3 ON
    t3.CalendarYear = Staging_TargetDataChannel.Year and RANKING = 1
    )
    ;

SELECT * FROM View_SRCSalesTarget	


-- Create View of Fact Tables: Fact_ProductSalesTarget
DROP VIEW IF EXISTS View_ProductSalesTarget;

CREATE SECURE VIEW View_ProductSalesTarget as
	SELECT DISTINCT   
		  Dim_Product.DimProductID
		 ,t1.DimDateID
         ,Staging_TargetDataProduct.SalesQuantityTarget
	FROM Staging_TargetDataProduct
	INNER JOIN Dim_Product ON
	Dim_Product.SourceProductID = Staging_TargetDataProduct.ProductID
    INNER JOIN(
    SELECT *
    ,ROW_NUMBER() OVER(PARTITION BY CalendarYear ORDER BY FullDate) as RANKING
    FROM Dim_Date
    )t1 ON
    t1.CalendarYear = Staging_TargetDataProduct.Year and RANKING = 1
    ;

SELECT * FROM View_ProductSalesTarget


-- Create View of Dimension Tables: Dim_Product
DROP VIEW IF EXISTS View_Product;

CREATE SECURE VIEW View_Product as
SELECT
    Dim_Product.DimProductID
    ,Dim_Product.SourceProductID 
    ,Dim_Product.SourceProductTypeID
    ,Dim_Product.SourceProductCategoryID
    ,Dim_Product.ProductName
    ,Dim_Product.ProductType
    ,Dim_Product.ProductCategory
    ,Dim_Product.ProductRetailPrice
    ,Dim_Product.ProductWholesalePrice
    ,Dim_Product.ProductCost
    ,Dim_Product.ProductRetailProfit
    ,Dim_Product.ProductWholesaleUnitProfit
    ,Dim_Product.ProductProfitMarginUnitPercent
FROM Dim_Product;

SELECT * FROM View_Product


-- Create View of Dimension Tables: Dim_Date
DROP VIEW IF EXISTS View_Date;

CREATE SECURE VIEW View_Date as
SELECT
    Dim_Date.DimDateID
    ,Dim_Date.FullDate 
    ,Dim_Date.DayNameOfWeek
    ,Dim_Date.DayNumberOfMonth
    ,Dim_Date.MonthName
    ,Dim_Date.MonthNumberOfYear
    ,Dim_Date.CalendarYear
FROM Dim_Date;

SELECT * FROM View_Date


-- Create View of Dimension Tables: Dim_Store
DROP VIEW IF EXISTS View_Store;

CREATE SECURE VIEW View_Store as
SELECT
    Dim_Store.DimStoreID
    ,Dim_Store.DimLocationID 
    ,Dim_Store.SourceStoreID
    ,Dim_Store.StoreName
    ,Dim_Store.StoreNumber
    ,Dim_Store.StoreManager
FROM Dim_Store;

SELECT * FROM View_Store


-- Create View of Dimension Tables: Dim_Reseller
DROP VIEW IF EXISTS View_Reseller;

CREATE SECURE VIEW View_Reseller as
SELECT
    Dim_Reseller.DimResellerID
    ,Dim_Reseller.DimLocationID 
    ,Dim_Reseller.SourceResellerID
    ,Dim_Reseller.ResellerName
    ,Dim_Reseller.ContactName
    ,Dim_Reseller.PhoneNumber
    ,Dim_Reseller.Email
FROM Dim_Reseller;

SELECT * FROM View_Reseller


-- Create View of Dimension Tables: Dim_Customer
DROP VIEW IF EXISTS View_Customer;

CREATE SECURE VIEW View_Customer as
SELECT
    Dim_Customer.DimCustomerID
    ,Dim_Customer.DimLocationID 
    ,Dim_Customer.SourceCustomerID
    ,Dim_Customer.CustomerFullName
    ,Dim_Customer.CustomerFirstName
    ,Dim_Customer.CustomerLastName
    ,Dim_Customer.CustomerGender
FROM Dim_Customer;

SELECT * FROM View_Customer


-- Create View of Dimension Tables: Dim_Channel
DROP VIEW IF EXISTS View_Channel;

CREATE SECURE VIEW View_Channel as
SELECT
    Dim_Channel.DimChannelID
    ,Dim_Channel.SourceChannelID
    ,Dim_Channel.SourceChannelCategoryID
    ,Dim_Channel.ChannelName
    ,Dim_Channel.ChannelCategory
FROM Dim_Channel;

SELECT * FROM View_Channel


-- Create View of Dimension Tables: Dim_Location
DROP VIEW IF EXISTS View_Location;

CREATE SECURE VIEW View_Location as
SELECT
    Dim_Location.DimLocationID
    ,Dim_Location.Address
    ,Dim_Location.City
    ,Dim_Location.PostalCode
    ,Dim_Location.State_Province
    ,Dim_Location.Country
FROM Dim_Location;

SELECT * FROM View_Location
