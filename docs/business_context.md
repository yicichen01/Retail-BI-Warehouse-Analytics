# Business Context and Analytical Framing

## Overview

This project began with a business scenario rather than a predefined dashboard template. The core objective was to translate open-ended retail performance questions into an analytical framework that could support actionable decision-making.

The analysis centered on Store 5 and Store 8 and aimed to answer a set of practical business questions: how each store was performing against target, whether either store should be considered for closure, what actions could improve profits in the following year, how bonus pools should be allocated based on category performance, how sales varied by day of week, and how stores in states with multiple stores compared with stores that were the only store in their state.

These questions are important because they are not isolated KPI checks. Together, they represent a broader decision-support problem that combines target tracking, profitability analysis, assortment insights, staffing and incentive implications, and geographic performance context. This project was designed to build the analytical foundation required to answer those questions in a structured and reusable way.

## Business Problem

Retail leaders often need to make operational and strategic decisions with incomplete context. In this scenario, the business needed more than a sales report. It needed a way to evaluate store performance against targets, understand what was driving results, and translate those findings into concrete decisions for the next planning cycle.

At a practical level, the business questions fell into six themes:

1. **Target attainment**  
   Determine how Store 5 and Store 8 performed relative to target and whether either store was on track to meet its yearly target.

2. **Store portfolio decision-making**  
   Assess whether either store should be closed and support that decision with evidence rather than intuition.

3. **Profit maximization**  
   Identify what should be done in the next year to improve profits, using product, store, and channel level performance.

4. **Performance-based incentives**  
   Recommend separate bonus amounts for two years, specifically grounded in sales performance for Men’s Casual and Women’s Casual product types.

5. **Weekly sales behavior**  
   Analyze sales by day of week to identify recurring sales patterns that could inform planning, promotion timing, or resource allocation.

6. **Geographic store comparison**  
   Compare stores in states with multiple stores against those in states with only one store, in order to understand whether store density may relate to performance.

## Why This Required a BI Pipeline

These questions could not be answered well through ad hoc charting alone. They required a structured warehouse design because the answers depend on joining multiple business entities across time, product, channel, location, and customer context.

The source data included channel, product, product type, sales detail, sales header, store, and multiple target datasets. The analysis framework explicitly called for key-based joins, aggregation, metric calculations, and multi-dimensional analysis to answer the business questions. That made a dimensional model a natural fit.

Instead of treating the project as a one-off dashboard exercise, I approached it as a business intelligence workflow:

- frame the business questions clearly
- determine what data structures were needed
- design fact and dimension tables around analytical grain
- build a Snowflake ELT flow from staging into warehouse tables
- create analytical views for reporting
- use Tableau to tell the decision story

This approach made the final dashboard more credible because the visuals were built on a warehouse structure intentionally designed around decision support.

## Analytical Objectives

To make the business problem answerable, I translated the scenario into several analytical objectives:

### 1. Measure actual performance against target

This required aligning transaction-level sales with target data at compatible grains. Since the project involved both actual sales and targets, the warehouse needed to support meaningful actual-vs-target comparisons rather than simple descriptive reporting. The dimensional design document reflects this by defining separate fact tables for actual sales and targets.

### 2. Evaluate product-category contribution

The bonus recommendation and profit-maximization questions depended heavily on category and product-type performance, especially Men’s Casual and Women’s Casual. That meant product dimensions needed to support category slicing and related profitability analysis. 

### 3. Support store-level and geographic comparison

Because the questions involved Store 5 vs. Store 8 and also comparisons across states with single-store vs. multi-store presence, the model needed store and geography structures that could support location-aware analysis. The dimensional design explicitly treated geography as an outrigger to reduce redundancy while preserving location context.

### 4. Surface temporal sales patterns

Day-of-week analysis required a date dimension that went beyond raw timestamps and supported weekday-based slicing. The dimensional design document explicitly identifies Dim_Date as supporting date-related analysis such as day-of-week trends.

## Framing the Story for Decision Support

A key part of this project was not just computing metrics, but deciding how to communicate them in a way that supported decision-making. In the analysis framework, I mapped each business question to a visualization logic:

- bullet-style or target-vs-actual comparison for store performance
- product and category comparisons to support profit recommendations
- day-of-week trends to show weekly sales patterns
- grouped store comparisons to analyze geographic performance differences

