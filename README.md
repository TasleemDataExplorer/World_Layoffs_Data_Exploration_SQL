# Project Overview

The goal of this project is to use SQL for exploratory data analysis (EDA) for worldwide layoff data. Understanding layoff trends across companies, industries, countries, and time periods is the aim of this analysis. Patterns like which companoes and industries were most affected, how layoffs evolved over time, and when significant layoff events took place are also sought after.

## Dataset Description

The dataset includes information related to company layoffs across the world, with key columns such as:
- Company
- Location
- Industry
- Total employees laid off
- Percentage laid off
- Date of layoff
- Company stage
- Country
- Funds raised (in millions)

## Key Analysis Performed

Using SQL, I explored the data to answer business-relevant and trend-based questions, including:

- Maximum layoffs recorded in a single event

- Companies with the highest total layoffs

- Industries most affected by layoffs

- Countries with the largest number of layoffs

- Layoff trends over time (yearly and monthly)

- Rolling total of layoffs to observe growth patterns

- Companies that laid off 100% of their workforce

- Year-wise ranking of companies based on total layoffs

- Top companies responsible for layoffs in each year

## Tools & Technologies

- SQL (MySQL)

#### Concepts used:

- Aggregations

- CTEs (Common Table Expressions)

- Window Functions (ROW_NUMBER, DENSE_RANK, SUM OVER)

- Date functions

- Grouping and filtering
