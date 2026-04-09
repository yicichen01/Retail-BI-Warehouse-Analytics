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

