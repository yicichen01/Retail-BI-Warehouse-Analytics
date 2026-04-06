# Dashboard Storytelling and Decision Support

## Overview

The final Tableau dashboard was designed as a decision-support artifact, not just a visual summary of data. Its purpose was to answer the original business questions in a structured way and guide action around store performance, target attainment, product-category decisions, incentive allocation, and broader store strategy.

The business scenario focused on Store 5 and Store 8, asking whether they were meeting targets, whether either should be closed, what should be done to maximize profit, how bonuses should be allocated for Men’s Casual and Women’s Casual performance, what weekday sales patterns looked like, and whether stores in states with multiple stores behaved differently from stores that were the only store in their state.

The dashboard therefore had to do more than present a few KPIs. It had to support a sequence of business interpretations.

## Dashboard Design Philosophy

I approached the dashboard as a narrative structure with multiple analytical sections, each tied to a specific decision theme. Instead of separating everything into disconnected sheets, I designed the dashboard to bring related questions together so the viewer could move naturally from target tracking to category performance to temporal and geographic comparison.

This design choice was intentional. A strong business dashboard should reduce the effort needed to answer linked questions. In this case, the dashboard was built to let a stakeholder quickly assess:

- whether Store 5 or Store 8 was underperforming
- where category strength or weakness appeared
- how weekly patterns differed
- whether store density by state might relate to performance
- what those patterns implied for future action

## Section 1: Sales Target vs. Real

One of the most important dashboard sections compares actual sales with targets for Store 5 and Store 8. This directly answers the first scenario question: how the two stores are performing relative to target and whether they appear likely to meet 2014 expectations. The analysis framework explicitly planned a bullet-style target comparison for this purpose.

This section is valuable because target attainment is often the first filter in performance assessment. Before making decisions about closure, investment, or incentives, a stakeholder needs a clean view of actual versus expected performance.

## Section 2: Men’s and Women’s Casual Performance

The dashboard also dedicates a section to Men’s Casual and Women’s Casual performance, including quantity, amount, and profit views. This ties directly to the scenario’s bonus-allocation requirement, which asked for recommendations based on how well the stores were selling those product types.

This section is more than a category breakdown. It supports a compensation and resource-allocation question. That makes it a strong example of analytics being used for operational decision support rather than descriptive reporting alone.

## Section 3: Detailed Product Performance

The detailed table within the dashboard supports a more granular look at products within the Men’s and Women’s Casual categories. This adds interpretive depth to the broader category charts and helps identify which specific items are contributing most to performance differences between Store 5 and Store 8.

Including this detail layer was important because strategic recommendations often depend on moving from high-level patterns to actionable specifics.

## Section 4: Weekly Sales Quantity Trend

The weekly sales trend section addresses the day-of-week question from the business scenario. The analysis framework explicitly planned to use a line plot to examine whether weekends, weekdays, or particular days behaved differently in sales volume.

This section matters because weekly patterns can influence:

- promotion timing
- staffing decisions
- inventory planning
- tactical store-level actions

A store that underperforms overall may still have valuable demand concentration on specific days, which can change the business interpretation.

## Section 5: Store Distribution

The dashboard includes a geographic distribution view that supports state-level interpretation. This helps connect store performance with location structure and complements the scenario’s broader comparison between single-store and multi-store state contexts.

This section is useful because geographic context often changes the meaning of performance. A store’s results should not always be interpreted in isolation from network structure.

## Section 6: Average Sales by Store Type

The dashboard also compares average sales for stores in states with multiple stores versus those that are the only store in a state. This directly supports the final business question in the analysis framework.

This comparison helps elevate the dashboard from store-specific reporting to broader structural insight. It allows the viewer to think not only about Store 5 and Store 8, but also about what network context may imply for future expansion, consolidation, or performance expectations.

