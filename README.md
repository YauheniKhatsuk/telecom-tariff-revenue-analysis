# Telecom Tariff Revenue Analysis (PostgreSQL)

## 📌 Project Overview

This project analyzes customer behavior and revenue structure of a telecom company offering two tariff plans: **Smart** and **Ultra**.

The goal was to evaluate:

- Customer monthly usage
- Revenue per client
- Overlimit usage behavior
- Average spending per tariff plan
- Share of active users exceeding their tariff limits

The analysis was performed using PostgreSQL.

---

## 🎯 Business Context

The product team plans to redesign the tariff structure.  
To support decision-making, it was necessary to:

1. Calculate monthly customer spending.
2. Identify users exceeding tariff limits.
3. Compare average revenue across tariff plans.
4. Estimate average overpayment per tariff.

---

## 🛠 Tech Stack

- PostgreSQL
- CTE
- JOIN
- Aggregations (SUM, COUNT, AVG)
- CASE statements
- Revenue calculation logic

---

## 📂 Project Structure

</> Code

---

## 🔎 Analytical Steps

### 1. Data Validation
- Checked missing values
- Identified duplicates
- Validated tariff information
- Checked anomalies in usage data

### 2. Data Preparation
- Aggregated monthly usage per user
- Calculated:
  - Total call duration (rounded up)
  - Total internet usage
  - Total messages
- Built a monthly usage dataset

### 3. Revenue Calculation
- Added monthly subscription fee
- Calculated overlimit charges
- Computed total monthly revenue per user
- Calculated average revenue per tariff
- Identified overlimit users

---

## 📊 Key Results

Based on monthly aggregated usage data:

### Tariff Usage Behavior

- Ultra users did not exceed included limits for calls, internet, or SMS during the analyzed period.
- Smart users exceeded the internet traffic limit in several months.
- Overlimit behavior was primarily driven by mobile internet usage rather than calls or SMS.

### Overlimit Structure

- Internet traffic is the main driver of additional revenue.
- Call duration and SMS usage rarely exceed the included limits.
- Some Smart users generated additional charges due to exceeding monthly internet limits.

### Data Observations

- Missing SMS values (NaN) were identified for certain users.
- Overlimit indicators confirm that excess usage occurs mainly on the Smart tariff.

### Business Implications

- Smart tariff internet limit may be insufficient for active users.
- Ultra tariff appears to be underutilized relative to its included package.
- There is potential to introduce:
  - An intermediate tariff plan
  - Internet-focused add-on packages
  - Personalized upsell offers for high-traffic users

---


## 📊 Product Insights

- Internet traffic is the primary revenue expansion driver.
- Smart tariff users are more likely to exceed limits, indicating mismatch between usage behavior and tariff design.
- Ultra users rarely exceed limits, suggesting potential overpricing or oversized package.
- The company could optimize tariff structure by:
  - Increasing Smart internet allowance
  - Creating a mid-tier tariff
  - Implementing targeted data add-ons
---

## 📌 Project Status

Course project completed as part of Data Analyst training.  
Demonstrates SQL analytics and revenue modeling skills.
