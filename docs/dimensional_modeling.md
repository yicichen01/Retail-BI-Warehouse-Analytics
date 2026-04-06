# Dimensional Modeling and Warehouse Design

## Overview

The warehouse design for this project was built to answer business questions that required flexible analysis across products, stores, dates, channels, customers, resellers, and targets. Rather than loading all source tables directly into Tableau, I designed a dimensional model that supports scalable aggregation, cleaner joins, and more consistent business logic.

The model includes fact tables for actual sales and sales targets, dimension tables for core business entities, and outrigger tables for reusable context such as geography and segment. This design reflects the classic BI principle that reporting becomes more trustworthy and reusable when metrics are built on a clear grain and a stable analytical schema. The design decisions described here are grounded in the dimensional design document, which specifies the purpose, grain, and structure of each table.

## Why a Dimensional Model Was Necessary

The business questions in this project required comparing performance across multiple axes at once:

- actual sales versus targets
- store-level differences
- category and product-type performance
- day-of-week trends
- single-store versus multi-store state comparisons

A dimensional model was the right approach because it enables:

- consistent metric aggregation
- simpler downstream dashboarding
- clear grain definition
- reuse across multiple analytical questions
- easier slicing across shared dimensions

Without this structure, the final analysis would have required repeated ad hoc joins, inconsistent business logic, and a much higher risk of incorrect comparisons.

## Fact Tables

### Fact_Sales

The core fact table captures individual sales activity at a granular level. According to the design document, its purpose is to track each individual sale, including what was sold, where, when, how, and to whom. Its grain is one individual sales transaction for a specific product, at a specific store, through a specific channel, by a specific customer or reseller, on a specific date.

This fact structure was important because many of the business questions required flexible rollups across multiple dimensions. For example:

- store target comparisons require aggregation by store and year
- category performance requires aggregation by product type
- day-of-week trends require aggregation by date attributes
- geographic comparisons require rollups across store location context

The fact table therefore serves as the central analytical event table in the warehouse.

### Fact_Targets

The design also included a target fact structure to support performance-to-target comparisons. The design document describes this table as tracking daily sales targets at an atomic level, either quantity-based or amount-based, and supporting flexible aggregation across store, product, channel, and date dimensions.

This was a strong modeling choice because the business scenario explicitly required comparing actual sales to target and evaluating whether stores would meet their targets. By modeling targets as facts rather than as a loose lookup table, the design preserved analytical consistency and made actual-vs-target reporting much cleaner.

## Dimension Tables

### Dim_Store

Dim_Store was designed to represent one specific store and to hold store-related attributes, including store numbers and geographic links. It supports store-level performance analysis and store comparison logic. The design document also notes that it links to geography and subsegment-related context through surrogate keys.

This dimension is central because the project’s main scenario revolves around Store 5 and Store 8.

### Dim_Channel

Dim_Channel stores the channel name and category, with one row per channel. The design document notes that this helps determine how products are distributed and informs future profit maximization.

Including channel as a dimension allows the warehouse to support not only descriptive breakdowns, but also strategy questions around distribution and performance by sales path.

### Dim_Product

Dim_Product was designed at the grain of one specific product and includes product identifiers, product type, product category, and financial attributes such as price, wholesale price, and cost. The design document explicitly notes that this dimension supports identifying product types for bonus allocation and comparing product performance for future profit-maximizing strategy.

This table is especially important for the Men’s Casual and Women’s Casual questions because those recommendations depend on category-aware product analysis.

### Dim_Customer

Dim_Customer stores customer-related attributes, including identity and geographic context. Its design supports analysis of who is making purchases as a customer and enables more refined downstream slicing when needed.

### Dim_Reseller

Dim_Reseller captures reseller-related attributes and was designed at the grain of one specific reseller. Including this dimension keeps the warehouse flexible enough to support alternate purchaser types rather than assuming all sales belong to a single buyer entity model.

### Dim_Date

Dim_Date stores temporal attributes such as full date, weekday name, day-of-month, month, and year. The design document explicitly identifies this table as supporting analysis of sales trends across different days of the week.

This table is essential for the weekly sales pattern question in the scenario.

## Outrigger Tables

### Geography

The Geography table was designed to store reusable location attributes such as address, city, state, and country, and to avoid redundant geographic storage across multiple core dimensions. The design document explicitly notes that it helps compare store performance across different states.

This choice was valuable because the scenario required comparing stores in states with multiple stores to those in states with only one store.

### Segment

The Segment outrigger stores segment and subsegment context and helps avoid repeating classification attributes across multiple dimensions. It also supports finer-grained analysis where segment context may matter.

## Grain and Key Design

One of the most important aspects of this project was explicitly defining analytical grain rather than relying on source-system assumptions. The design document clearly states the grain for each fact and dimension table, which is what made the warehouse reliable for downstream aggregation.

I also used surrogate keys to support:

- cleaner dimensional joins
- abstraction from source-system identifiers
- more stable warehouse logic
- easier reuse across fact tables

This mattered because the source data came from multiple CSV files and business questions required combining them in analytical rather than operational ways.


