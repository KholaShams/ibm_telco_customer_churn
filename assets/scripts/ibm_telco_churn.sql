select *
from telco_customer_churn_demographics;

select *
from telco_customer_churn_location;

select *
from telco_customer_churn_population;

select *
from telco_customer_churn_services;

select *
from telco_customer_churn_status;


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


/*Query 2: What are the feedback or complaints from
those churned customers*/

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

/*Query 3: How does the payment method influence
churn behavior?*/

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
