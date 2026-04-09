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

