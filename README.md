# Retail BI Warehouse Analytics

This project translates a retail business scenario into a full business intelligence workflow: business-question framing, dimensional modeling, Snowflake ELT, analytical views, and Tableau dashboards.

It was designed to support performance-to-target analysis, profit-oriented decision making, and store-level strategy recommendations.

## Business Context

The analysis focuses on a set of business questions around Store 5 and Store 8, including target attainment, closure decisions, profit maximization, bonus allocation, weekday sales trends, and differences between stores in single-store vs. multi-store states. See `docs/business_context.md` for details.

## Dimensional Model

![Dimensional Model](assets/dimensional_model.png)

This dimensional model organizes sales, targets, products, stores, channels, customers, resellers, dates, and geography into a warehouse structure that supports flexible slicing, aggregation, and decision support.

## Dashboard Output

![Dashboard Overview](assets/dashboard_overview.png)

The final Tableau dashboard combines target-vs-actual analysis, product-category performance, weekday trends, store distribution, and store-type comparisons into one decision-support view.

## Workflow

The project was built in five stages:

1. Framed the business questions and analysis requirements  
2. Designed the dimensional model and defined table grain  
3. Implemented staging and ELT workflows in Snowflake  
4. Built analytical views for downstream reporting  
5. Developed a Tableau dashboard for business storytelling  

## What This Project Demonstrates

- Dimensional data modeling  
- Snowflake staging and ELT implementation  
- Fact and dimension design with grain definition  
- Analytical view design for BI workflows  
- Dashboard storytelling for decision support  

## Repository Structure

- `assets/` images used in the README  
- `docs/business_context.md` business problem and analytical framing  
- `docs/dimensional_modeling.md` schema design, grain, and key decisions  
- `docs/snowflake_elt.md` staging and ELT workflow in Snowflake  
- `docs/dashboard_storytelling.md` dashboard logic and business storytelling  
- `sql/` optional space for staging, dimension, fact, and view SQL scripts  
- `links.md` external links including Tableau Public  

## Live Dashboard

See the published Tableau dashboard in `links.md`.
