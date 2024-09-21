
### **IBM Telco Customer Churn Data Analysis Project Report**

#### **Project Overview**

This project aimed to analyze churn behavior among customers of a telecommunications company using the **IBM Telco Customer Churn Dataset**. The goal was to uncover patterns and insights that could help the company reduce churn and improve customer retention. The analysis was carried out using MySQL Workbench, where I explored various factors influencing churn, such as payment methods, customer demographics, contract types, and feedback from churned customers.

#### **Dataset Overview**

The dataset consists of five main tables:

1. **telco_customer_churn_demographics**:
   - Contains demographic information such as customer ID, gender, age, marital status, number of dependents, etc.

2. **telco_customer_churn_location**:
   - Holds location-based information such as country, state, city, and zip code.

3. **telco_customer_churn_population**:
   - Stores population data for different zip codes.

4. **telco_customer_churn_services**:
   - Contains information about services used by the customer, such as phone service, internet type, monthly charges, contract type, and tenure.

5. **telco_customer_churn_status**:
   - Provides the churn status, satisfaction scores, and churn reasons for each customer.

#### **Objective**

The primary objective was to answer three key queries using MySQL, derive insights, and propose actionable recommendations for reducing customer churn.

---

### **Query 1: Analyzing High-Spending Churned Customers and Creating Personalized Offers**

**Query Objective:**  
To identify the top 5 groups of churned customers with the highest average monthly charges and determine how personalized offers could be tailored based on age, gender, and contract type to improve retention rates.

#### **SQL Query:**

```sql
select `Customer ID`, count(`Customer ID`)
from telco_customer_churn_services
group by `Customer ID`
having count(`Customer ID`) > 1;

with telco_services as (
select a.`Customer ID`, a.`Contract` as contract_type, avg(`Monthly Charge`) over (partition by `Customer ID` order by `Monthly Charge` desc) as average_monthly_charges, b.`Customer Status`
from telco_customer_churn_services a
join telco_customer_churn_status b
on a.`Customer ID` = b.`Customer ID`
where b.`Customer Status` = "churned")
select a.*, b.`Age`, b.`Gender`
from telco_services a
join telco_customer_churn_demographics b
on a.`Customer ID` = b.`Customer ID`
order by a.average_monthly_charges desc
limit 5;
```

**Key Insights:**
- **Customer Profiles:** The query returned the top 5 churned customers with the highest average monthly charges, including their age, gender, and contract type. The customers spanned different contract types such as "Month-to-Month," "One Year," and "Two Year."
  
| Customer ID | Contract Type   | Avg Monthly Charges | Customer Status | Age | Gender |
|-------------|-----------------|---------------------|-----------------|-----|--------|
| 8199-ZLLSA  | One Year        | 118.35              | Churned         | 53  | Male   |
| 2889-FPWRM  | One Year        | 117.80              | Churned         | 31  | Male   |
| 2302-ANTDP  | Month-to-Month  | 117.45              | Churned         | 76  | Female |
| 9053-JZFKV  | Two Year        | 116.20              | Churned         | 25  | Male   |
| 1444-VVSGW  | One Year        | 115.65              | Churned         | 51  | Male   |

- **Customer Demographics:** Customers with high average monthly charges are diverse in terms of age and gender, though many are on "One Year" contracts. 
- **Personalized Offers Recommendations:**
  1. **Age-Based Offers:**
     - For younger customers (e.g., the 25-year-old), targeted offers around tech-related benefits like faster speeds or more data could help.
     - For older customers (e.g., 76-year-old), consider offering plans with enhanced customer service and reliability.
  2. **Gender-Specific Promotions:**
     - For male customers, who form the majority of this group, bundle services such as streaming or premium tech support may appeal.
  3. **Contract-Type Offers:**
     - Month-to-month customers could be offered incentives for switching to long-term contracts by offering discounts.
     - Yearly contract customers could benefit from loyalty programs or renewal bonuses.

---

### **Query 2: Understanding Feedback and Complaints from Churned Customers**

**Query Objective:**  
To analyze the feedback or complaints from churned customers to identify common reasons for leaving.

#### **SQL Query:**

```sql
SELECT 
    s.`Customer ID`, 
    s.`Contract` AS contract_type, 
    s.`Monthly Charge`, 
    st.`Customer Status`, 
    st.`Churn Reason`
FROM 
    telco_customer_churn_services s
JOIN 
    telco_customer_churn_status st
ON 
    s.`Customer ID` = st.`Customer ID`
WHERE 
    st.`Customer Status` = 'churned'
AND 
    st.`Churn Reason` IS NOT NULL;
```

```sql
with telco_services as (
select a.`Customer ID`, a.`Contract` as contract_type, avg(`Monthly Charge`) over (partition by `Customer ID` order by `Monthly Charge` desc) as average_monthly_charges, b.`Customer Status`, b.`Churn Reason` as feedback
from telco_customer_churn_services a
join telco_customer_churn_status b
on a.`Customer ID` = b.`Customer ID`
where b.`Customer Status` = "churned")
select a.*, b.`Age`, b.`Gender`
from telco_services a
join telco_customer_churn_demographics b
on a.`Customer ID` = b.`Customer ID`
order by a.average_monthly_charges desc
limit 5;
```

**Key Insights:**

| Customer ID | Contract Type   | Avg Monthly Charges | Customer Status | Feedback                                  | Age | Gender |
|-------------|-----------------|---------------------|-----------------|-------------------------------------------|-----|--------|
| 8199-ZLLSA  | One Year        | 118.35              | Churned         | Competitor had better devices             | 53  | Male   |
| 2889-FPWRM  | One Year        | 117.80              | Churned         | Competitor offered higher download speeds | 31  | Male   |
| 2302-ANTDP  | Month-to-Month  | 117.45              | Churned         | Competitor offered more data              | 76  | Female |
| 9053-JZFKV  | Two Year        | 116.20              | Churned         | Don’t know                                | 25  | Male   |
| 1444-VVSGW  | One Year        | 115.65              | Churned         | Product dissatisfaction                   | 51  | Male   |

- **Common Complaints:** Most customers cited competitors offering better devices, higher download speeds, or more data as reasons for leaving.
- **Actionable Insights:** To prevent churn, the company should focus on:
  1. **Competitive Edge:** Offering similar or better device options, faster download speeds, and higher data allowances could win back customers.
  2. **Product Satisfaction:** Conduct surveys to understand dissatisfaction with products and services and address them through improvements.
  3. **Educating Customers:** For customers unsure why they left, provide better communication about the advantages of staying with the service.

---

### **Query 3: Influence of Payment Method on Churn Behavior**

**Query Objective:**  
To analyze how different payment methods impact churn rates and provide recommendations for improving customer retention through payment options.

#### **SQL Query:**

```sql
SELECT 
    s.`Payment Method`, 
    COUNT(st.`Customer ID`) AS total_customers,
    SUM(CASE WHEN st.`Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN st.`Churn Label` = 'Yes' THEN 1 ELSE 0 END) / COUNT(st.`Customer ID`) * 100, 2) AS churn_rate_percentage
FROM 
    telco_customer_churn_services s
JOIN 
    telco_customer_churn_status st
ON 
    s.`Customer ID` = st.`Customer ID`
GROUP BY 
    s.`Payment Method`
ORDER BY 
    churn_rate_percentage DESC;

```

**Key Insights:**

| Payment Method     | Total Customers | Churned Customers | Churn Rate (%) |
|--------------------|-----------------|-------------------|----------------|
| Mailed Check       | 385             | 142               | 36.88          |
| Bank Withdrawal    | 3909            | 1329              | 34.00          |
| Credit Card        | 2749            | 398               | 14.48          |

- **High Churn for Mailed Checks:** Customers who paid by mailed checks had the highest churn rate at 36.88%, likely due to the inconvenience of the method.
- **Low Churn for Credit Cards:** Credit card users had a significantly lower churn rate of 14.48%, likely due to ease of payment and automation.
- **Recommendations:**
  1. **Promote Credit Card Payments:** Encourage customers to switch to credit card payments through rewards or discounts for auto-pay setups.
  2. **Simplify Mailed Check Payments:** For those who prefer mailed checks, offer faster payment processing or easy reminders to reduce churn.

---

### **Conclusion and Recommendations**

Through this data analysis, several actionable insights were uncovered that can help reduce customer churn:

1. **Personalized Offers:** Tailor offers based on customer demographics (age, gender) and contract type. Younger customers may value high-tech solutions, while older customers may prioritize service reliability and ease of use.
  
2. **Addressing Feedback:** Competitors are luring customers away with better offers. The company should focus on improving device offerings, data packages, and product satisfaction to match or exceed competitors.

3. **Payment Method Optimization:** Encouraging customers to switch to automated, convenient payment methods like credit cards can significantly reduce churn

.

Implementing these strategies could potentially help the company improve customer retention, reduce churn, and enhance overall customer satisfaction.

---

**Tools Used:**
- MySQL Workbench for querying and data analysis.
- IBM Telco Customer Churn Dataset for insights generation.

