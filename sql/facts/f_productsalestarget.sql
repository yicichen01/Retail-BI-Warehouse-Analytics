----------------------------------------------- Fact_ProductSalesTarget
DROP TABLE IF EXISTS Fact_ProductSalesTarget;

CREATE TABLE Fact_ProductSalesTarget
(
     DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
	,DimTargetDateID INTEGER CONSTRAINT FK_DimTargetDateID FOREIGN KEY REFERENCES Dim_Date(DimDateID) --Foreign Key
    ,ProductTargetSalesQuantity INTEGER
);

INSERT INTO Fact_ProductSalesTarget
	(
		 DimProductID
		,DimTargetDateID
		,ProductTargetSalesQuantity
	)
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

SELECT * FROM Fact_ProductSalesTarget

