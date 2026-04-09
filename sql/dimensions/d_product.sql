------------------------------ DIM_PRODUCT
drop table if exists Dim_Product;

--CREATE TABLE
create or replace table Dim_Product
(
    DimProductID integer identity(1,1) constraint PK_DimProduct primary key not null, -- surrogate key
    SourceProductID integer not null,  -- natural key
    SourceProductTypeID integer not null,  -- natural key
    SourceProductCategoryID integer not null,  -- natural key
    ProductName varchar(255) not null, 
    ProductType varchar(255) not null,
    ProductCategory varchar(255) not null,
    ProductRetailPrice float(10) not null,
    ProductWholesalePrice float(10) not null,
    ProductCost float(10) not null,
    ProductRetailProfit float(20) not null,
    ProductWholesaleUnitProfit float(10) not null,
    ProductProfitMarginUnitPercent float(10) not null  
);

--LOAD UNKNOWN MEMBER
insert into Dim_Product
(
    DimProductID,
    SourceProductID,
    SourceProductTypeID,
    SourceProductCategoryID,
    ProductName,
    ProductType,
    ProductCategory,
    ProductRetailPrice,
    ProductWholesalePrice,
    ProductCost,
    ProductRetailProfit,
    ProductWholesaleUnitProfit,
    ProductProfitMarginUnitPercent
)
values
( 
    -1,
    -1,
    -1,
    -1,
    'Unknown',
    'Unknown',
    'Unknown',
    -1.0,
    -1.0,
    -1.0,
    -1.0,
    -1.0,
    -1.0   
);

--LOAD DATA
insert into Dim_Product
(
    SourceProductID,
    SourceProductTypeID,
    SourceProductCategoryID,
    ProductName,
    ProductType,
    ProductCategory,
    ProductRetailPrice,
    ProductWholesalePrice,
    ProductCost,
    ProductRetailProfit,
    ProductWholesaleUnitProfit,
    ProductProfitMarginUnitPercent
)
select 
    Staging_Product.ProductID as SourceProductID,
    Staging_ProductType.ProductTypeID as SourceProductTypeID,
    Staging_ProductCategory.ProductCategoryID as SourceProductCategoryID,
    Staging_Product.Product as ProductName,
    Staging_ProductType.ProductType as ProductType,
    Staging_ProductCategory.ProductCategory as ProductCategory,
    Staging_Product.Price as ProductRetailPrice,
    Staging_Product.WholesalePrice as ProductWholesalePrice,
    Staging_Product.Cost as ProductCost,
    ta.ProductRetailProfit as ProductRetailProfit,
    Staging_Product.WholesalePrice - Staging_Product.Cost as ProductWholesaleUnitProfit,
    (Staging_Product.Price - Staging_Product.Cost)/Staging_Product.Cost*100 as ProductProfitMarginUnitPercent
    
from Staging_Product
left join(
    select c.ProductID, sum(b.SalesQuantity*(c.Price - c.Cost)) as ProductRetailProfit
    from Staging_SalesHeader a
    left join Staging_SalesDetail b 
    on a.SalesHeaderID = b.SalesHeaderID
    left join Staging_Product c
    on b.ProductID = c.ProductID
    where a.CustomerID is not null
    group by c.ProductID) ta
on Staging_Product.ProductID = ta.ProductID
left join Staging_ProductType
on Staging_Product.ProductTypeID = Staging_ProductType.ProductTypeID
left join Staging_ProductCategory
on Staging_ProductType.ProductCategoryID = Staging_ProductCategory.ProductCategoryID
;

select * from Dim_Product

