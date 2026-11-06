USE sample_sales;
-- Territory: Texas

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?
-- Total revenue: $3417850.01
-- Dates: 01/01/2022 - 12/31/2025
SELECT
	SUM(Sale_Amount) Total_Sales,
	MIN(Transaction_Date) Start_Date,
	MAX(Transaction_Date) Latest_date
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas';

-- What is the revenue breakdown by year and month for the sales territory?
SELECT
YEAR(Transaction_Date) 'Year',
MONTH(Transaction_Date) 'Month',
SUM(Sale_Amount) Total_Sales
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY 
	YEAR(Transaction_Date),
    MONTH(Transaction_Date);

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
-- Texas sales: $3,417,850.01
-- Region sales: $7,996,850.12
-- Difference: $4,579,000.11
-- Texas percentage = 42.74%
SELECT
	(SELECT SUM(ss.Sale_Amount)
    FROM store_sales ss
    JOIN store_locations sl
		ON ss.Store_ID = sl.StoreID
	WHERE sl.State = 'Texas') Texas_Sales,
    (SELECT SUM(ss.Sale_Amount)
    FROM store_sales ss
    JOIN store_locations sl
		ON ss.Store_ID = sl.StoreID
	JOIN management m
		ON sl.State = m.State
	WHERE m.Region = 'South') Region_Sales;

-- What is the number of transactions per month and average transaction amount by product category for the sales territory?
SELECT
	YEAR(Transaction_Date) Year,
    MONTH(Transaction_Date) Month,
    ic.Category Category,
    COUNT(Sale_Amount) Transaction_Count,
    ROUND(AVG(Sale_Amount), 2) Average_Sales
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreID
JOIN products p
	ON p.ProdNum = ss.Prod_Num
JOIN inventory_categories ic
	ON ic.Categoryid = p.Categoryid
WHERE sl.State = 'Texas'
GROUP BY
	YEAR(Transaction_Date),
    MONTH(Transaction_Date),
    ic.Category;
    
-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
SELECT
	sl.StoreLocation,
    sl.StoreID,
    SUM(ss.Sale_Amount) TotalSales
    FROM store_locations sl
    JOIN store_sales ss
		ON sl.StoreID = ss.Store_ID
	WHERE sl.State = 'Texas'
    GROUP BY 
		StoreLocation,
        StoreID
    ORDER BY TotalSales DESC;

-- What is your recommendation for where to focus sales attention in the next quarter?
/*
I would focus more on sales for the store located in Dallas because their total sales are very low only coming out to $54,444.05
while other stores are pulling in at least $260k or more in Texas. The data shows that the average transaction amount in Dallas are
comparable to other store locations. However, Dallas has significantly fewer total transactions accross all categories.
Another area I would focus on is the store located in Georgetown. It shows that there are no sales for art supplies and merchandise.
While their overall sales are not falling behind too much compared to other stores, missing these items can be a reason why the average total sales
is slightly lower. 
*/

-- Extra: Sales by store and product category in Texas.
SELECT
	sl.StoreID,
    sl.StoreLocation,
    ic.Category,
    SUM(ss.Sale_Amount) TotalSales,
    ROUND(AVG(ss.Sale_Amount), 2) AverageSales,
    COUNT(*) TotalTransactions
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreID
JOIN products p
	ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
	ON p.CategoryID = ic.CategoryID
WHERE sl.State = 'Texas'
GROUP BY
	sl.StoreID,
    sl.StoreLocation,
    ic.Category
ORDER BY
	sl.StoreLocation,
    ic.Category;
    
-- Checks if Dallas was present during all years.
SELECT
	SUM(ss.Sale_Amount) TotalSales,
    YEAR(ss.Transaction_Date) 'Year'
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY 
    YEAR(ss.Transaction_Date);