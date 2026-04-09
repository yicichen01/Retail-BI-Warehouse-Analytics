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

