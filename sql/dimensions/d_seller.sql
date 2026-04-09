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

