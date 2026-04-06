------------------------------ DIM_CHANNEL
drop table if exists Dim_Channel;

--CREATE TABLE
create or replace table Dim_Channel
(
    DimChannelID integer identity(1,1) constraint PK_DimChannel primary key not null, -- surrogate key
    SourceChannelID integer not null,  -- natural key
    SourceChannelCategoryID integer not null,  -- natural key
    ChannelName varchar(255) not null,
    ChannelCategory varchar(255) not null
);

--LOAD UNKNOWN MEMBER
insert into Dim_Channel
(
    DimChannelID,
    SourceChannelID,
    SourceChannelCategoryID,
    ChannelName,
    ChannelCategory
)
values
( 
    -1,
    -1,
    -1,
    'Unknown',
    'Unknown'
);

--LOAD DATA
insert into Dim_Channel
(
    SourceChannelID,
    SourceChannelCategoryID,
    ChannelName,
    ChannelCategory
)
select 
    Staging_Channel.ChannelID as SourceChannelID,
    Staging_Channel.ChannelCategoryID as SourceChannelCategory,
    Staging_Channel.Channel as ChannelName,
    Staging_ChannelCategory.ChannelCategory as ChannelCategory
    
from Staging_Channel
inner join Staging_ChannelCategory
on Staging_Channel.ChannelCategoryID = Staging_ChannelCategory.ChannelCategoryID;

select * from Dim_Channel


------------------------------ DIM_LOCATION
drop table if exists Dim_Location;

--CREATE TABLE
create or replace table Dim_Location
(
    DimLocationID integer identity(1,1) constraint PK_DimLocation primary key not null, -- surrogate key
    Address varchar(255) not null, 
    City varchar(100) not null, 
    PostalCode varchar(20) not null,
    State_Province varchar(100) not null,
    Country varchar(100) not null
);

--LOAD UNKNOWN MEMBER
insert into Dim_Location
(
    DimLocationID,
    Address,
    City,
    PostalCode,
    State_Province,
    Country
)
values
( 
    -1,
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown'
);

--LOAD DATA
insert into Dim_Location
(
    Address,
    City,
    PostalCode,
    State_Province,
    Country
)
select Address, City, PostalCode, State_Province, Country
from(
select 
    Staging_Store.Address as Address,
    Staging_Store.City as City,
    Staging_Store.PostalCode as PostalCode,
    Staging_Store.StateProvince as State_Province,
    Staging_Store.Country as Country
    
from Staging_Store)
union all(
select 
    Staging_Customer.Address as Address,
    Staging_Customer.City as City,
    Staging_Customer.PostalCode as PostalCode,
    Staging_Customer.StateProvince as State_Province,
    Staging_Customer.Country as Country
    
from Staging_Customer)
union all(
select 
    Staging_Reseller.Address as Address,
    Staging_Reseller.City as City,
    Staging_Reseller.PostalCode as PostalCode,
    Staging_Reseller.StateProvince as State_Province,
    Staging_Reseller.Country as Country
    
from Staging_Reseller);

select * from Dim_Location


------------------------------ DIM_STORE
drop table if exists Dim_Store;

--CREATE TABLE
create or replace table Dim_Store
(
    DimStoreID integer identity(1,1) constraint PK_DimStore primary key not null, -- surrogate key
    DimLocationID integer not null constraint FK_DimLocation references Dim_Location(DimLocationID), -- foreign key
    SourceStoreID integer not null,  -- natural key
    StoreName varchar(255) not null, 
    StoreNumber integer not null,
    StoreManager varchar(255) not null
);

--LOAD UNKNOWN MEMBER
insert into Dim_Store
(
    DimStoreID,
    DimLocationID,
    SourceStoreID,
    StoreName,
    StoreNumber,
    StoreManager
)
values
( 
    -1,
    -1,
    -1,
    'Unknown',
    -1,
    'Unknown'
);

--LOAD DATA
insert into Dim_Store
(
    DimLocationID,
    SourceStoreID,
    StoreName,
    StoreNumber,
    StoreManager
)
select 
    Dim_Location.DimLocationID as DimLocationID,
    Staging_Store.StoreID as SourceStoreID,
    t2.TargetName as StoreName,
    Staging_Store.StoreNumber as StoreNumber,
    Staging_Store.StoreManager as StoreManager
    
from Staging_Store
inner join Dim_Location
on Staging_Store.Address = Dim_Location.Address
and Staging_Store.City = Dim_Location.City
and Staging_Store.PostalCode =  Dim_Location.PostalCode
and Staging_Store.StateProvince = Dim_Location.State_Province
and Staging_Store.Country = Dim_Location.Country
left join(
    select distinct ChannelID, StoreID
    from Staging_SalesHeader
    where StoreID is not null) t1
    on Staging_Store.StoreID = t1.StoreID
left join Staging_Channel
on t1.ChannelID = Staging_Channel.ChannelID
left join(
    select distinct ChannelName, TargetName
    from Staging_TargetDataChannel) t2 
on replace(Staging_Channel.Channel, '-', '') = t2.ChannelName
and right(Staging_Store.StoreNumber, 1) = right(t2.TargetName, 1)
;

select * from Dim_Store


------------------------------ DIM_RESELLER
drop table if exists Dim_Reseller;

--CREATE TABLE
create or replace table Dim_Reseller
(
    DimResellerID integer identity(1,1) constraint PK_DimReseller primary key not null, -- surrogate key
    DimLocationID integer not null constraint FK_DimLocation references Dim_Location(DimLocationID), -- foreign key
    SourceResellerID varchar(255) not null,  -- natural key
    ResellerName varchar(255) not null, 
    ContactName varchar(255) not null,
    PhoneNumber varchar(255) not null,
    Email varchar(255) not null
);

--LOAD UNKNOWN MEMBER
insert into Dim_Reseller
(
    DimResellerID,
    DimLocationID,
    SourceResellerID,
    ResellerName,
    ContactName,
    PhoneNumber,
    Email
)
values
( 
    -1,
    -1,
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown'
);

--LOAD DATA
insert into Dim_Reseller
(
    DimLocationID,
    SourceResellerID,
    ResellerName,
    ContactName,
    PhoneNumber,
    Email
)
select 
    Dim_Location.DimLocationID as DimLocationID,
    Staging_Reseller.ResellerID as SourceResellerID,
    Staging_Reseller.ResellerName as ResellerName,
    Staging_Reseller.Contact as ContactName,
    Staging_Reseller.PhoneNumber as PhoneNumber,
    Staging_Reseller.EmailAddress as Email
    
from Staging_Reseller
inner join Dim_Location
on Staging_Reseller.Address = Dim_Location.Address
and Staging_Reseller.City = Dim_Location.City
and Staging_Reseller.PostalCode =  Dim_Location.PostalCode
and Staging_Reseller.StateProvince = Dim_Location.State_Province
and Staging_Reseller.Country = Dim_Location.Country;

select * from Dim_Reseller


------------------------------ DIM_CUSTOMER
drop table if exists Dim_Customer;

--CREATE TABLE
create or replace table Dim_Customer
(
    DimCustomerID integer identity(1,1) constraint PK_DimCustomer primary key not null, -- surrogate key
    DimLocationID integer not null constraint FK_DimLocation references Dim_Location(DimLocationID), -- foreign key
    SourceCustomerID varchar(255) not null,  -- natural key
    CustomerFullName varchar(255) not null, 
    CustomerFirstName varchar(100) not null,
    CustomerLastName varchar(100) not null,
    CustomerGender varchar(10) not null
);

--LOAD UNKNOWN MEMBER
insert into Dim_Customer
(
    DimCustomerID,
    DimLocationID,
    SourceCustomerID,
    CustomerFullName,
    CustomerFirstName,
    CustomerLastName,
    CustomerGender
)
values
( 
    -1,
    -1,
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown'
);

--LOAD DATA
insert into Dim_Customer
(
    DimLocationID,
    SourceCustomerID,
    CustomerFullName,
    CustomerFirstName,
    CustomerLastName,
    CustomerGender
)
select 
    Dim_Location.DimLocationID as DimLocationID,
    Staging_Customer.CustomerID as SourceCustomerID,
    concat(Staging_Customer.FirstName, ' ', Staging_Customer.LastName) as CustomerFullName,
    Staging_Customer.FirstName as CustomerFirstName,
    Staging_Customer.LastName as CustomerLastName,
    Staging_Customer.Gender as CustomerGender
    
from Staging_Customer
inner join Dim_Location
on Staging_Customer.Address = Dim_Location.Address
and Staging_Customer.City = Dim_Location.City
and Staging_Customer.PostalCode =  Dim_Location.PostalCode
and Staging_Customer.StateProvince = Dim_Location.State_Province
and Staging_Customer.Country = Dim_Location.Country;

select * from Dim_Customer


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


------------------------------ DIM_DATE
drop table if exists Dim_Date;

--CREATE TABLE
create or replace table Dim_Date
(
    DimDateID integer identity(1,1) constraint PK_DimDate primary key not null, -- surrogate key
    FullDate date not null, 
    DayNameofWeek varchar(10) not null,
    DayNumberofMonth integer not null,
    MonthName varchar(10) not null,
    MonthNumberofYear integer not null,
    CalendarYear integer not null
);

--LOAD UNKNOWN MEMBER
insert into Dim_Date
(
    DimDateID,
    FullDate,
    DayNameofWeek,
    DayNumberofMonth,
    MonthName,
    MonthNumberofYear,
    CalendarYear
)
values
( 
    -1,
    '1900-01-01',
    'Unknown',
    -1,
    'Unknown',
    -1,
    -1
);

--LOAD DATA
insert into Dim_Date
(
    FullDate,
    DayNameofWeek,
    DayNumberofMonth,
    MonthName,
    MonthNumberofYear,
    CalendarYear
)
select distinct to_date(Date, 'MM/DD/YY') as FullDate,
dayname(to_date(Date, 'MM/DD/YY')) AS DayNameOfWeek,
day(to_date(Date, 'MM/DD/YY')) as DayNumberofMonth,
monthname(to_date(Date, 'MM/DD/YY')) AS MonthName,
month(to_date(Date, 'MM/DD/YY')) as MonthNumberofYear,
year(to_date(Date, 'MM/DD/YY')) as CalendarYear
from Staging_SalesHeader;

select * from Dim_Date
