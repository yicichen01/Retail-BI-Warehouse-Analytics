# Snowflake ELT and Staging Workflow

## Overview

After defining the dimensional model, the next step was to implement the warehouse pipeline in Snowflake. I approached this as a structured ELT workflow rather than a direct load into reporting tables. The process began with staging, where source data was ingested and validated, and then progressed into dimensional and fact table loading to support downstream views and dashboarding.

This workflow was important because the source data came from multiple CSV files with different structures and data type behaviors. In practice, that meant the pipeline needed more than simple file loading. It needed schema alignment, staging validation, and careful source-to-target mapping before analytical tables could be trusted. The staging reflection document captures this especially well, including specific problems I ran into with data type mismatches during ingestion.

## Why Staging Was Necessary

A staging layer served several purposes:

- preserve source data structure before transformation
- validate data types and detect load issues early
- reduce the risk of pushing malformed data into core warehouse tables
- support cleaner source-to-target logic for dimension and fact loading

This was not just a formality. One of the main lessons from the Snowflake staging work was that source columns that looked similar across files did not always share the same true data types. The reflection specifically notes a mismatch involving values like `2013/1/1 20:56:10`, where a column initially assumed to be a timestamp turned out to be stored as a VARCHAR in one file but as a TIMESTAMP in another. That mismatch caused load failure and had to be corrected by aligning staging definitions with source reality.

That experience is exactly why staging matters in real BI pipelines.

## Source-to-Staging Workflow

The source data included multiple files related to sales, stores, channels, products, and targets. The analysis framework lists these source files and emphasizes key-based joins as the basis for later analytical work.

In Snowflake, the staging process involved:

1. identifying the appropriate source files and fields
2. defining staging tables that matched source structure
3. loading data from external storage into staging tables
4. checking warnings and failures during load
5. validating loaded data with SELECT statements
6. correcting schema mismatches where necessary

The staging reflection shows that I was explicitly checking query results for staged tables and validating that records had landed correctly.

## Real Implementation Challenge: Data Type Mismatch

A particularly important part of this project was handling schema mismatch during staging. The reflection document explains that timestamp-like values caused problems because the same-named field could behave differently across files. For example, a `CreatedDate` field that looked like a timestamp in one file was actually stored as VARCHAR in another. Defining those columns incorrectly caused data load failures.

This is a small but meaningful engineering detail, because it demonstrates that I was not just following an idealized pipeline. I was dealing with real ingestion issues that required:

- careful source inspection
- correction of staging schema definitions
- awareness that similar-looking fields across files may not be semantically or structurally identical

## From Staging to Dimensions and Facts

Once the staging layer was stable, the next step was to load the dimensional model. This required:

- mapping source fields into dimension attributes
- generating or assigning surrogate keys
- building fact records at the correct analytical grain
- preserving relationships between business entities for downstream reporting

The dimensional design document guided this process by clearly defining the purpose and grain of each fact and dimension table.

For example:

- sales facts had to support one individual sales transaction at atomic grain
- target facts had to support actual-vs-target analysis
- product, store, channel, date, customer, reseller, and geography dimensions had to provide reusable analytical context

This separation ensured that Tableau reporting later relied on warehouse logic rather than raw source joins.

## Analytical Views

After loading the warehouse tables, I created views to support easier downstream analysis. This was an important layer because dashboards often benefit from business-ready views rather than direct access to raw fact tables. Views help centralize metric logic, simplify Tableau modeling, and reduce repeated calculation complexity in the BI layer.

Even if the dashboard audience never sees those views directly, they improve maintainability and keep analytical logic more organized.

