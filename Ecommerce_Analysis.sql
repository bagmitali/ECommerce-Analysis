Use ecommerce

-- Total Number of orders 
Select count(order_id) as Total_Orders
from [Order Details]

-- Total Number of orders 
Select sum(Quantity) as Total_Quantity
from [Order Details]

-- Total profit
Select sum(Profit)
from [Order Details]

-- No of customers 
Select count(Distinct CustomerName)
from [List of Orders]


-- Method 1: Using Group by and Top/Limit 
-- Least and the most expensive products 
Select top 1 Category, sub_category, Min(Amount) as Least_Expensive_Product
from [Order Details]
group by Category, sub_category
order by Least_Expensive_Product asc

-- Method 2 : Using Row Number and subquery
Select 	 x1.Category, x1.sub_category, x1.Expensive_Product from
	(Select top 1 Category, sub_category, Max(Amount) as Expensive_Product,
	ROW_NUMBER() over (order by Max(Amount) desc) as rn
	from [Order Details]
	group by Category,sub_category) x1
where rn = 1


-- Find out total Cost for each order ID 
Select Order_ID, sum(Amount * Quantity) as Total_Cost_Price
from [Order Details]
group by Order_ID

-- Which category gets the most orders?
select  Category, count(Order_ID) as Total_orders
from [order details] 
group by Category
order by Total_orders desc

-- Which Sub_category gets the most orders?
select  Sub_Category, count(Order_ID) as Total_orders
from [order details] 
group by Sub_Category
order by Total_orders desc

-- Which categories is generating the most profit
Select Category, SUM(Profit) AS Profit
from [Order Details] 
Group by Category
order by Profit desc

-- How many orders are Profitable?
Select Case When Profit > 0 Then 'Profitable'
When Profit < 0 Then 'Loss'
Else 'None'
End as Profit_Status,
COUNT(Order_ID) AS Total_Orders
From [Order Details]
Group by 
 Case When Profit > 0 Then 'Profitable'
When Profit < 0 Then 'Loss'
Else 'None'
End
Order by Total_Orders DESC

-- TOP 3 Profitable Sub-Categories for each category 
With Profitable_Category as (
	Select Category, Sub_Category, sum(Profit) As Profit,
	DENSE_RANK() over(partition by Category order by  sum(Profit) desc) as ranks
	from [Order Details]
	Group by Category, Sub_Category)
Select Category, Sub_Category, Profit
From Profitable_Category
where ranks = 3

-- Top 5 profitable State
select Top 5 l.State, sum(Profit) as Profit
from [List of Orders] l
inner join [Order Details] o on l.Order_ID = o.Order_ID
Group by State
order by Profit desc

-- No of customers state-wise 
SELECT state, COUNT(Order_ID) AS Count_Customers
from [List of Orders] 
GROUP BY state
ORDER BY state; 

-- Total Revenue Generated 
SELECT Sum((Amount * Quantity) + profit) AS SellPrice
FROM [Order Details]

-- Total Revenue by category 
SELECT  Category, Sum((Amount * Quantity) + profit) AS SellPrice
FROM [Order Details]
group by  Category

-- Sales Targets for each category 
SELECT category, SUM(target) AS Target_Sale 
FROM [Sales target]
GROUP BY category 
ORDER BY category; 

--Which Category is achieving targeted Sale
select x1.Category, x1.Revenue, x1.Target,
Case when x1.Revenue > x1.Target then 'Achieved'
else 'Not Achieved'
end as Revenue_achieved
from
	(select o.Category, sum(o.Amount * o.Quantity) as Revenue, sum(S.Target) as Target
	from [Order Details] o
	Inner join [Sales target] s on o.Category = s.Category
	group by o.Category) x1

-- Count of orders for each month 
Select  MONTH(Order_Date) as Month, COUNT(Order_ID) as Orders
from [List of Orders] l
Group by MONTH(Order_Date)
Order by Month 

-- Which Month is Profitable
select MONTH(l.Order_Date) as Month, SUM(Profit) As Profit
from [Order Details] o
Inner Join [List of Orders] l on o.Order_ID=l.Order_ID
Group by MONTH(l.Order_Date)
Order by Profit Desc


