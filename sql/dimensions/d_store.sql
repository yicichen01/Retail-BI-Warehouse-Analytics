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

