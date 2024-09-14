USE ecommerce

-- Q1) Which category gets the most orders?
select  Category, count(Order_ID) as Total_orders
from [order details] 
group by Category
order by Total_orders desc

-- Q2) Which categories is generating the most profit and revenue.
Select Category, sum(Amount* Quantity) as Revenue, SUM(Profit) AS Profit
from [Order Details] 
Group by Category
order by Revenue desc, Profit desc

-- Q3) Top 5 Sub-category generating most profit
Select top 5 Sub_Category, Category, sum(Profit) as Profit
from [Order Details]
Group by Sub_Category, Category
order by Profit desc

-- Q4) Which Sub-category is making Loss
Select Sub_Category, SUM(Profit) AS Profit
from [Order Details] 
Group by Sub_Category
order by Profit asc

-- Q5) How many orders are Profitable?
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
Order by Total_Orders DESC;

-- Q6) Which Category is achieving targeted Sale?
select x1.Category, x1.Revenue, x1.Target,
Case when x1.Revenue > x1.Target then 'Achieved'
else 'Not Achieved'
end as Revenue_achieved
from
	(select o.Category, sum(o.Amount * o.Quantity) as Revenue, sum(S.Target) as Target
	from [Order Details] o
	Inner join [Sales target] s on o.Category = s.Category
	group by o.Category) x1

-- Q7) Which Month is Profitable
select MONTH(l.Order_Date) as Month, SUM(Profit) As Profit
from [Order Details] o
Inner Join [List of Orders] l on o.Order_ID=l.Order_ID
Group by MONTH(l.Order_Date)
Order by Profit Desc

-- Q8) Which State is Profitable?
select l.State, sum(Profit) as Profit
from [List of Orders] l
inner join [Order Details] o on l.Order_ID = o.Order_ID
Group by State
order by Profit desc
