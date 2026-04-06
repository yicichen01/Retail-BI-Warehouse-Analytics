CREATE DATABASE STAGING;

USE DATABASE STAGING;

USE SCHEMA PUBLIC;
-------------------------
DROP TABLE IF EXISTS STAGING_CHANNEL;

CREATE OR REPLACE TABLE STAGING_CHANNEL (
    ChannelID INTEGER,
    ChannelCategoryID INTEGER,
    Channel VARCHAR(255),
    CreatedDate VARCHAR(255),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(255),
    ModifiedBy VARCHAR(255)
);
---------------------------
DROP TABLE IF EXISTS STAGING_CHANNELCATEGORY;

CREATE OR REPLACE TABLE STAGING_CHANNELCATEGORY (
    ChannelCategoryID INTEGER,
    ChannelCategory VARCHAR(255),
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255)
);
-------------------------------
DROP TABLE IF EXISTS STAGING_CUSTOMER;

CREATE OR REPLACE TABLE STAGING_CUSTOMER (
    CustomerID VARCHAR(50),
    SubSegmentID INTEGER,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Gender VARCHAR(10),
    EmailAddress VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(100),
    StateProvince VARCHAR(100),
    Country VARCHAR(100),
    PostalCode VARCHAR(20),
    PhoneNumber VARCHAR(20),
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255)
);
--------------------------------
DROP TABLE IF EXISTS STAGING_PRODUCT;

CREATE OR REPLACE TABLE STAGING_PRODUCT (
    ProductID INTEGER,
    ProductTypeID INTEGER,
    Product VARCHAR(255),
    Color VARCHAR(100),
    Style VARCHAR(100),
    UnitofMeasureID INTEGER,
    Weight FLOAT,
    Price FLOAT,
    Cost FLOAT,
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255),
    WholesalePrice FLOAT
);
-----------------------------------
DROP TABLE IF EXISTS STAGING_PRODUCTCATEGORY;

CREATE OR REPLACE TABLE STAGING_PRODUCTCATEGORY (
    ProductCategoryID INTEGER,
    ProductCategory VARCHAR(255),
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255)
);
------------------------------------
DROP TABLE IF EXISTS STAGING_PRODUCTTYPE;

CREATE OR REPLACE TABLE STAGING_PRODUCTTYPE (
    ProductTypeID INTEGER,
    ProductCategoryID INTEGER,
    ProductType VARCHAR(255),
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255)
);
-----------------------------------------
DROP TABLE IF EXISTS STAGING_RESELLER;

CREATE OR REPLACE TABLE STAGING_RESELLER (
    ResellerID STRING,
    Contact VARCHAR(255),
    EmailAddress VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(100),
    StateProvince VARCHAR(100),
    Country VARCHAR(100),
    PostalCode VARCHAR(20),
    PhoneNumber VARCHAR(50),
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255),
    ResellerName VARCHAR(255)
);
---------------------------------------
DROP TABLE IF EXISTS STAGING_SALESDETAIL;

CREATE OR REPLACE TABLE STAGING_SALESDETAIL (
    SalesDetailID INTEGER,
    SalesHeaderID INTEGER,
    ProductID INTEGER,
    SalesQuantity INTEGER,
    SalesAmount FLOAT,
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255)
);
----------------------------------------
DROP TABLE IF EXISTS STAGING_SALESHEADER;

CREATE OR REPLACE TABLE STAGING_SALESHEADER (
    SalesHeaderID INTEGER,
    Date VARCHAR(50),
    ChannelID INTEGER,
    StoreID INTEGER,
    CustomerID VARCHAR(50),
    ResellerID VARCHAR(50),
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255)
);
----------------------------------------
DROP TABLE IF EXISTS STAGING_STORE;

CREATE OR REPLACE TABLE STAGING_STORE (
    StoreID INTEGER,
    SubSegmentID INTEGER,
    StoreNumber INTEGER,
    StoreManager VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    StateProvince VARCHAR(255),
    Country VARCHAR(255),
    PostalCode VARCHAR(20),
    PhoneNumber VARCHAR(20),
    CreatedDate VARCHAR(50),
    CreatedBy VARCHAR(255),
    ModifiedDate VARCHAR(50),
    ModifiedBy VARCHAR(255)
);
-----------------------------------------
DROP TABLE IF EXISTS STAGING_TARGETDATACHANNEL;

CREATE OR REPLACE TABLE STAGING_TARGETDATACHANNEL (
    Year INTEGER,
    ChannelName VARCHAR(255),
    TargetName VARCHAR(255),
    TargetSalesAmount DECIMAL(18,2)
);
------------------------------------------
DROP TABLE IF EXISTS STAGING_TARGETDATAPRODUCT;

CREATE OR REPLACE TABLE STAGING_TARGETDATAPRODUCT (
    ProductID INTEGER,
    Product VARCHAR(255),
    Year INTEGER,
    SalesQuantityTarget DECIMAL(18,2)
);
