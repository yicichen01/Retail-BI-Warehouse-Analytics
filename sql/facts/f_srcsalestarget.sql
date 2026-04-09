----------------------------------------------- Fact_SRCSalesTarget
UPDATE Dim_Reseller
SET ResellerName = 'Mississippi Distributors'
WHERE DimResellerID = 1;


DROP TABLE IF EXISTS Fact_SRCSalesTarget;

CREATE TABLE Fact_SRCSalesTarget
(
     DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
	,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
    ,DimTargetDateID INTEGER CONSTRAINT FK_DimTargetDateID FOREIGN KEY REFERENCES Dim_Date(DimDateID) --Foreign Key
    ,SalesTargetAmount INTEGER
);

INSERT INTO Fact_SRCSalesTarget
	(
		 DimStoreID
		,DimResellerID
		,DimChannelID
        ,DimTargetDateID
        ,SalesTargetAmount
	)
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

SELECT * FROM Fact_SRCSalesTarget	

