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

