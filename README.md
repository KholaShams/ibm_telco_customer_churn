# **IBM Telco Customer Churn Data Analysis Project Report**

## **Table of Contents**

1. [**Project Overview**](#project-overview)
2. [**Dataset Overview**](#dataset-overview)
   - [telco_customer_churn_demographics](#telco_customer_churn_demographics)
   - [telco_customer_churn_location](#telco_customer_churn_location)
   - [telco_customer_churn_population](#telco_customer_churn_population)
   - [telco_customer_churn_services](#telco_customer_churn_services)
   - [telco_customer_churn_status](#telco_customer_churn_status)
3. [**Objectives**](#objectives)
4. [**Query 1: Analyzing High-Spending Churned Customers and Creating Personalized Offers**](#query-1-analyzing-high-spending-churned-customers-and-creating-personalized-offers)
   - [Query Objective](#query-objective)
   - [SQL Query](#sql-query)
   - [Query Results](#query-results)
   - [Key Insights](#key-insights)
   - [Tailoring Personalized Offers](#tailoring-personalized-offers)
     - [High Monthly Charges with One-Year Contracts](#high-monthly-charges-with-one-year-contracts)
     - [Month-to-Month Contract with High Charges](#month-to-month-contract-with-high-charges)
     - [Two-Year Contract with High Charges](#two-year-contract-with-high-charges)
   - [General Strategy for Improvement](#general-strategy-for-improvement)
     - [Age-Based Offers](#age-based-offers)
     - [Gender-Specific Offers](#gender-specific-offers)
5. [**Query 2: Understanding Feedback and Complaints from Churned Customers**](#query-2-understanding-feedback-and-complaints-from-churned-customers)
   - [Query Objective](#query-objective-1)
   - [SQL Query](#sql-query-1)
   - [Query Results](#query-results-1)
   - [Key Insights](#key-insights-1)
   - [Potential Actions](#potential-actions)
     - [Competitive Analysis](#competitive-analysis)
     - [Customer Feedback](#customer-feedback)
     - [Targeted Offers](#targeted-offers)
   - [Addressing Churn Due to Competitors](#addressing-churn-due-to-competitors)
     - [Device Offerings](#device-offerings)
     - [Faster Download Speeds](#faster-download-speeds)
     - [Data Offerings](#data-offerings)
     - [Product Dissatisfaction](#product-dissatisfaction)
   - [Recommendations for Personalized Offers](#recommendations-for-personalized-offers)
     - [Targeted Device Upgrades](#targeted-device-upgrades)
     - [Customized Data or Speed Plans](#customized-data-or-speed-plans)
     - [Service Improvement Initiatives](#service-improvement-initiatives)
   - [Personalized Retention Plan](#personalized-retention-plan)
6. [**Query 3: Influence of Payment Method on Churn Behavior**](#query-3-influence-of-payment-method-on-churn-behavior)
   - [Query Objective](#query-objective-2)
   - [SQL Query](#sql-query-2)
   - [Query Results](#query-results-2)
   - [Key Insights](#key-insights-2)
   - [Actionable Recommendations](#actionable-recommendations)


## **Project Overview**

The **IBM Telco Customer Churn** project aimed to analyze customer churn behavior to uncover patterns and insights that could help the telecommunications company improve customer retention. Utilizing the IBM Telco Customer Churn dataset and MySQL Workbench, the analysis focused on understanding the factors influencing churn, such as payment methods, customer demographics, contract types, and customer feedback.

## **Dataset Overview**

The dataset comprises five main tables:

1. **telco_customer_churn_demographics**:
   - Contains customer demographic information like customer ID, gender, age, marital status, and number of dependents.

2. **telco_customer_churn_location**:
   - Includes location details such as country, state, city, and zip code.

3. **telco_customer_churn_population**:
   - Provides population data associated with different zip codes.

4. **telco_customer_churn_services**:
   - Details services used by customers, including phone service, internet type, monthly charges, contract type, and tenure.

5. **telco_customer_churn_status**:
   - Offers information on customer churn status, satisfaction scores, and reasons for churn.

## **Objectives**

The primary objective was to address three key queries using MySQL, derive actionable insights, and propose recommendations to reduce customer churn:

1. **Query 1**: How can personalized offers be tailored based on age, gender, and contract type for the top 5 groups with the highest average monthly charges among churned customers to potentially improve customer retention rates?

2. **Query 2**: What are the feedback or complaints from those churned customers?

3. **Query 3**: How does the payment method influence churn behavior?

---

## **Query 1: Analyzing High-Spending Churned Customers and Creating Personalized Offers**

### **Query Objective**

Identify the top 5 groups of churned customers with the highest average monthly charges and determine how personalized offers can be tailored based on age, gender, and contract type to improve retention rates.

### **SQL Query**

```sql
/*Query 1: Considering the top 5 groups with the highest
average monthly charges among churned customers,
how can personalized offers be tailored based on age,
gender, and contract type to potentially improve
customer retention rates?*/

-- checking for duplicate customer id
select `Customer ID`, count(`Customer ID`)
from telco_customer_churn_services
group by `Customer ID`
having count(`Customer ID`) > 1;

with telco_services as (
select a.`Customer ID`, a.`Contract` as contract_type, 
avg(`Monthly Charge`) over (partition by `Customer ID` order by `Monthly Charge` desc) as average_monthly_charges, b.`Customer Status`
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

### **Query Results**

| Customer ID  | Contract Type   | Avg Monthly Charges | Customer Status | Age | Gender |
|--------------|-----------------|---------------------|-----------------|-----|--------|
| 8199-ZLLSA   | One Year        | 118.35              | Churned         | 53  | Male   |
| 2889-FPWRM   | One Year        | 117.80              | Churned         | 31  | Male   |
| 2302-ANTDP   | Month-to-Month  | 117.45              | Churned         | 76  | Female |
| 9053-JZFKV   | Two Year        | 116.20              | Churned         | 25  | Male   |
| 1444-VVSGW   | One Year        | 115.65              | Churned         | 51  | Male   |

### **Key Insights**

- **High Monthly Charges with One-Year Contracts**:
  - **Customers**: 53 Male, 31 Male, 51 Male.
  - **Observation**: These customers have high average monthly charges and are on one-year contracts.

- **Month-to-Month Contract with High Charges**:
  - **Customer**: 76 Female.
  - **Observation**: This customer has a month-to-month contract with high charges.

- **Two-Year Contract with High Charges**:
  - **Customer**: 25 Male.
  - **Observation**: A younger customer with a two-year contract and high monthly charges.

### **Tailoring Personalized Offers**

#### 1. **High Monthly Charges with One-Year Contracts**

- **Personalized Offer**:
  - **Discounts or Incentives**: Offer discounts or incentives for renewing their contract to a two-year plan.
  - **Benefits Highlight**: Emphasize long-term savings and possibly include a bundled service such as faster internet or additional services.

#### 2. **Month-to-Month Contract with High Charges**

- **Personalized Offer**:
  - **Discounted Long-Term Contract**: Offer a discounted one-year or two-year plan to reduce the monthly rate.
  - **Senior-Specific Plans**: Focus on plans that offer simplicity and ease of use, catering to senior customers.

#### 3. **Two-Year Contract with High Charges**

- **Personalized Offer**:
  - **Tech-Focused Add-Ons**: Provide add-ons like streaming services or discounts on additional services (e.g., mobile, gaming).
  - **Highlight Benefits**: Emphasize the advantages of staying with the current contract and the added value of new services.

### **General Strategy for Improvement**

- **Age-Based Offers**:
  - **Younger Customers**:
    - Likely to value tech upgrades, streaming, or gaming packages.
    - Offering discounts or bundling these services may encourage retention.
  - **Older Customers**:
    - Might prefer simplified service plans with less hassle.
    - Enhanced customer service support could improve satisfaction.

- **Gender-Specific Offers**:
  - While no drastic differences were noted, personalized communication can be fine-tuned based on gender preferences.
  - **Targeted Advertising**: Use different value propositions in marketing campaigns to appeal to specific genders.

---

## **Query 2: Understanding Feedback and Complaints from Churned Customers**

### **Query Objective**

Analyze the feedback or complaints from churned customers to identify common reasons for leaving and develop strategies to address them.

### **SQL Query**

```sql
/*Query 2: What are the feedback or complaints from
those churned customers*/

with telco_services as (
select a.`Customer ID`, a.`Contract` as contract_type, 
avg(`Monthly Charge`) over (partition by `Customer ID` order by `Monthly Charge` desc) as average_monthly_charges, b.`Customer Status`, b.`Churn Reason` as feedback
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

```sql
SELECT s.`Customer ID`, s.`Contract` AS contract_type, s.`Monthly Charge`, st.`Customer Status`, st.`Churn Reason`
FROM telco_customer_churn_services s
JOIN telco_customer_churn_status st
ON s.`Customer ID` = st.`Customer ID`
WHERE st.`Customer Status` = 'churned'
AND st.`Churn Reason` IS NOT NULL;
```

### **Query Results**

| Customer ID  | Contract Type   | Avg Monthly Charges | Customer Status | Feedback                                  | Age | Gender |
|--------------|-----------------|---------------------|-----------------|-------------------------------------------|-----|--------|
| 8199-ZLLSA   | One Year        | 118.35              | Churned         | Competitor had better devices             | 53  | Male   |
| 2889-FPWRM   | One Year        | 117.80              | Churned         | Competitor offered higher download speeds | 31  | Male   |
| 2302-ANTDP   | Month-to-Month  | 117.45              | Churned         | Competitor offered more data              | 76  | Female |
| 9053-JZFKV   | Two Year        | 116.20              | Churned         | Don't know                                | 25  | Male   |
| 1444-VVSGW   | One Year        | 115.65              | Churned         | Product dissatisfaction                   | 51  | Male   |

### **Key Insights**

- **Competitor-Related Reasons**:
  - **Common Themes**: Better devices, higher download speeds, and more data offered by competitors are frequent reasons for churn.

- **Product Dissatisfaction**:
  - Indicates potential issues with service quality or product features.

- **Uncertain Reasons**:
  - Some customers are unsure why they left, highlighting a possible disconnect or lack of engagement.

### **Potential Actions**

#### **Competitive Analysis**

- **Assess Competitors**:
  - Evaluate competitors' strengths in device quality, data packages, and download speeds.
  - Aim to match or surpass their offerings.

#### **Customer Feedback**

- **Gather Detailed Feedback**:
  - Implement regular surveys and feedback mechanisms to pinpoint dissatisfaction.
  - Use insights to drive improvements in products and services.

#### **Targeted Offers**

- **Upgrade or Renewal Options**:
  - For customers on one-year or two-year contracts, offer better upgrade or renewal deals.
  - Tailor promotions to address specific reasons for churn.

### **Addressing Churn Due to Competitors**

#### 1. **Device Offerings**

- **Invest in Device Partnerships**:
  - Collaborate with popular manufacturers to offer competitive devices.
  - Provide exclusive devices or upgrades.

- **Offer Device Upgrades or Trade-In Options**:
  - Allow mid-contract upgrades or trade-ins to keep customers engaged.

- **Device Comparison Marketing**:
  - Transparently compare devices with competitors, highlighting advantages.

#### 2. **Faster Download Speeds**

- **Speed Testing and Improvement**:
  - Conduct assessments to identify areas needing speed enhancements.

- **Tiered Internet Packages**:
  - Offer competitive pricing on higher-speed packages.

- **Communicate Improvements**:
  - Keep customers informed about network upgrades and enhancements.

#### 3. **Data Offerings**

- **Competitive Data Packages**:
  - Reevaluate data plans to offer more flexibility or larger allowances.

- **Unlimited Data Options**:
  - Promote unlimited plans or special deals for data-conscious customers.

- **Usage Monitoring Tools**:
  - Provide tools to help customers manage and optimize their data usage.

#### 4. **Product Dissatisfaction**

- **Service Improvements**:
  - Investigate and address common pain points in service quality.

- **Customer Surveys**:
  - Follow up with dissatisfied customers to understand and resolve issues.

- **Loyalty Programs**:
  - Implement rewards or satisfaction guarantees to retain uncertain customers.

### **Recommendations for Personalized Offers**

#### 1. **Targeted Device Upgrades**

- **Discounted or Free Upgrades**:
  - Offer to customers who cited device issues.

- **Age-Based Personalization**:
  - Younger customers: Focus on cutting-edge devices.
  - Older customers: Emphasize simplicity and functionality.

#### 2. **Customized Data or Speed Plans**

- **Tailored Packages**:
  - Address needs for higher speeds or more data.

- **Contract-Based Promotions**:
  - Offer special deals on extended contracts with enhanced data and speed.

#### 3. **Service Improvement Initiatives**

- **Satisfaction Guarantees**:
  - Allow customers to cancel without penalty if not satisfied after trying improved services.

- **Dedicated Support**:
  - Provide specialized support for customers expressing dissatisfaction.

### **Personalized Retention Plan**

#### **Implementation Steps**

1. **Identify Target Customers**:
   - Use churn feedback to categorize at-risk customers.

2. **Create Marketing Campaigns**:
   - Design targeted promotions highlighting new offers.

3. **Train Customer Service Teams**:
   - Ensure staff are informed about offers and can communicate effectively.

4. **Monitor Outcomes**:
   - Track responses and retention rates to assess effectiveness.

5. **Continuous Feedback Loop**:
   - Adapt offers based on customer feedback and emerging trends.

---

## **Query 3: Influence of Payment Method on Churn Behavior**

### **Query Objective**

Analyze how different payment methods impact churn rates and provide recommendations for improving customer retention through payment options.

### **SQL Query**

```sql
/*Query 3: How does the payment method influence
churn behavior?*/

SELECT s.`Payment Method`, COUNT(st.`Customer ID`) AS total_customers, SUM(CASE WHEN st.`Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN st.`Churn Label` = 'Yes' THEN 1 ELSE 0 END) / COUNT(st.`Customer ID`) * 100, 2) AS churn_rate_percentage
FROM telco_customer_churn_services s
JOIN telco_customer_churn_status st
ON s.`Customer ID` = st.`Customer ID`
GROUP BY s.`Payment Method`
ORDER BY churn_rate_percentage DESC;
```

### **Query Results**

| Payment Method     | Total Customers | Churned Customers | Churn Rate (%) |
|--------------------|-----------------|-------------------|----------------|
| Mailed Check       | 385             | 142               | 36.88          |
| Bank Withdrawal    | 3,909           | 1,329             | 34.00          |
| Credit Card        | 2,749           | 398               | 14.48          |

### **Key Insights**

1. **Mailed Check**:

   - **Churn Rate**: 36.88%
   - **Observation**: Highest churn rate, suggesting dissatisfaction or difficulties with the payment process.

2. **Bank Withdrawal**:

   - **Churn Rate**: 34.00%
   - **Observation**: Significant churn rate indicates potential issues with the withdrawal process or related banking services.

3. **Credit Card**:

   - **Churn Rate**: 14.48%
   - **Observation**: Lowest churn rate, implying higher satisfaction with the payment experience.

### **Analysis**

- **Higher Churn with Mailed Checks and Bank Withdrawals**:
  - Indicates challenges or less engagement with these payment methods.

- **Credit Card Payments**:
  - Preferred due to convenience, security, and possibly rewards.

### **Recommendations**

#### 1. **Address Issues with Mailed Checks**

- **Customer Feedback Analysis**:
  - Gather feedback to identify pain points.

- **Incentives to Switch**:
  - Offer discounts or bonuses for transitioning to electronic payments.

- **Process Improvements**:
  - Streamline mailed check processing and provide clear instructions.

#### 2. **Improve Bank Withdrawal Processes**

- **Identify Common Complaints**:
  - Analyze issues such as failed transactions or delays.

- **Enhanced Communication**:
  - Provide updates on payment status to build trust.

- **Alternative Options**:
  - Introduce direct debit or automatic payment setups.

#### 3. **Promote Credit Card Use**

- **Exclusive Rewards Program**:
  - Implement rewards for credit card users.

- **Highlight Benefits**:
  - Market the convenience and security of credit card payments.

- **Partnerships**:
  - Collaborate with credit card companies for exclusive offers.

#### 4. **Customer Engagement Strategies**

- **Personalized Communication**:
  - Target customers using higher-churn methods with tailored messages.

- **Loyalty Programs**:
  - Reward customers for continued use and preferred payment methods.

- **Regular Follow-Ups**:
  - Check in with customers to address concerns proactively.

### **Implementation Steps**

1. **Month 1**:
   - Analyze feedback from customers using higher-churn payment methods.
   - Launch initial campaigns promoting credit card usage.

2. **Month 2**:
   - Develop and offer incentives for switching payment methods.
   - Improve communication regarding bank withdrawals.

3. **Month 3**:
   - Roll out loyalty programs for credit card users.
   - Collect initial feedback on initiatives.

4. **Ongoing**:
   - Monitor churn rates and refine strategies as needed.

---

## **Conclusion and Recommendations**

Through comprehensive data analysis, the following key strategies have been identified to reduce customer churn:

1. **Personalized Offers Based on Customer Profiles**:

   - Tailor promotions considering age, gender, and contract type.
   - Younger customers may value tech enhancements, while older customers might prioritize simplicity.

2. **Addressing Competitor Challenges**:

   - Enhance device offerings, data packages, and download speeds.
   - Regularly assess market trends to stay competitive.

3. **Improving Payment Methods Experience**:

   - Encourage the use of convenient payment methods like credit cards.
   - Address issues with mailed checks and bank withdrawals through process improvements and customer education.

4. **Engaging with Customer Feedback**:

   - Implement continuous feedback mechanisms.
   - Use insights to drive service improvements and customer satisfaction.

5. **Implementing Targeted Retention Strategies**:

   - Develop marketing campaigns that address specific reasons for churn.
   - Train customer service teams to effectively communicate new offers.

By focusing on these areas, the company can enhance customer loyalty, reduce churn rates, and foster a more satisfied customer base.

---

## **Tools Used**

- **MySQL Workbench**: For querying and analyzing data.
- **IBM Telco Customer Churn Dataset**: As the primary data source for insights.

---
