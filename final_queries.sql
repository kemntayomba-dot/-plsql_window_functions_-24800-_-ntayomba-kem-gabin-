1.	Step 1
Type of Business: Online retailer (like "SwiftCart")
Division: Marketing and Sales Activities
Industry: Data Challenge in Consumer Electronics
At the moment, the leadership team is unable to see client purchase patterns and localised performance. We must ascertain which products are leading particular areas and whether our sales increase is steady from month to month. The marketing department cannot use moving averages to forecast inventory demands or efficiently segment clients for high-value loyalty promotions without this detailed data.
Anticipated Result
A list of the best-performing items by region will be ranked by the study, and growth indicators will give a clear picture of the financial momentum. This will enable management to create a tiered "VIP" rewards program based on consumer spending quartiles and reallocate marketing expenditures to underperforming locations.

Step 2
The project will be deemed successful in our e-commerce scenario if we accomplish the following five quantifiable analytical objectives:
Product Regional Ranking: To prioritise local inventory, use the RANK() function to get the top 5 highest-grossing electronics products within each geographic region.
Cumulative Revenue Tracking: To track your progress toward yearly goals, use SUM() OVER() to determine the running total of monthly revenues for the fiscal year.
Growth Momentum Analysis: Use the LAG() function to compare current monthly totals to prior months in order to calculate the percentage of month-over-month sales growth.
client Value Segmentation: Use NTILE(4) to separate "Platinum" from "Budget" customers by dividing the client base into four equal groups (quartiles) based on lifetime lifetime spend. Sales Trend Smoothing: To eliminate weekly "noise" and spot long-term demand changes, use AVG() OVER() to create a three-month moving average of order volumes.
Comprehending Window Features
The project's concentration on window functions makes it easier to see how they vary from conventional "Group By" aggregates. A window function allows you to do calculations across a set of rows while maintaining the visibility of the individual row data, whereas a standard aggregate collapses rows.
step 4 part a
inner join
SELECT s.sale_id, c.customer_name, p.product_name, s.total_amount
FROM Sales s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Products p ON s.product_id = p.product_id;
 
2.	Left join
Find customers who have never made a purchase
SELECT c.customer_name, s.sale_id
FROM Customers c
LEFT JOIN Sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
 


3.Right join
Detect products that have never been sold
SELECT p.product_name, s.sale_id
FROM Sales s
RIGHT JOIN Products p ON s.product_id = p.product_id
WHERE s.sale_id IS NULL;
 
4.full outer join
SELECT c.customer_name, p.product_name
FROM Customers c
LEFT JOIN Sales s ON c.customer_id = s.customer_id
LEFT JOIN Products p ON s.product_id = p.product_id
UNION
SELECT c.customer_name, p.product_name
FROM Customers c
RIGHT JOIN Sales s ON c.customer_id = s.customer_id
RIGHT JOIN Products p ON s.product_id = p.product_id;
 

5.Self join
Compares customers in the same region
SELECT a.customer_name AS Customer_1, b.customer_name AS Customer_2, a.region
FROM Customers a
INNER JOIN Customers b ON a.region = b.region
WHERE a.customer_id < b.customer_id;
 \
Step 5 part b
Ranking function
This allows the sale team to see the top tier products based on price with each category:
SELECT product_name, category, unit_price,
RANK() OVER (PARTITION BY category ORDER BY unit_price DESC) as price_rank
FROM Products;
 
Aggregate window function
This tracks our cumulative growth day by day:
SELECT sale_date, total_amount,
SUM(total_amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM Sales;
 
Navigation function
This allows us to perform period to period comparison:
SELECT sale_id, total_amount,
LAG(total_amount) OVER (ORDER BY sale_date) as previous_sale_amt
FROM Sales;
 
Distribution function
This creates a vip tier system:
SELECT customer_id, 
SUM(total_amount) as total_spend,
NTILE(4) OVER (ORDER BY SUM(total_amount) DESC) as customer_tier
FROM Sales
GROUP BY customer_id;
 

