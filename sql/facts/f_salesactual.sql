----------------------------------------------- Fact_SalesActual
DROP TABLE IF EXISTS Fact_SalesActual;

CREATE TABLE Fact_SalesActual
(
     DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
	,DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
    ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID INTEGER CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key
    ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
    ,DimSaleDateID INTEGER CONSTRAINT FK_DimSaleDateID FOREIGN KEY REFERENCES Dim_Date(DimDateID) --Foreign Key
    ,DimLocationID INTEGER CONSTRAINT FK_DimLocationID FOREIGN KEY REFERENCES Dim_Location(DimLocationID) --Foreign Key
    ,SalesHeaderID INTEGER NOT NULL --natural key
    ,SalesDetailID INTEGER NOT NULL --natural key
    ,SaleAmount FLOAT
    ,SaleQuantity INTEGER
    ,SaleUnitPrice FLOAT
    ,SaleExtendedCost FLOAT
    ,SaleTotalProfit FLOAT
);

INSERT INTO Fact_SalesActual
	(
		 DimProductID
		,DimStoreID
        ,DimResellerID
        ,DimCustomerID
        ,DimChannelID
        ,DimSaleDateID
        ,DimLocationID
        ,SalesHeaderID
        ,SalesDetailID
        ,SaleAmount
        ,SaleQuantity
        ,SaleUnitPrice
        ,SaleExtendedCost
        ,SaleTotalProfit
	)
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

SELECT * FROM Fact_SalesActual	

