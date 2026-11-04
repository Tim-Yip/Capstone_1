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
-- Total revenue in Texas for each month of each year. 
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
    
-- Total revenue in Texas for each specific year.
SELECT
	YEAR(Transaction_Date) 'Year',
    SUM(Sale_Amount) Total_Sales
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Texas'
GROUP BY 
	YEAR(Transaction_Date);

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
WHERE State = 'Texas'
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
	WHERE State = 'Texas'
    GROUP BY 
		StoreLocation,
        StoreID
    ORDER BY TotalSales DESC;

-- What is your recommendation for where to focus sales attention in the next quarter?
-- I would focus more on sales for the store located in Dallas because their total sales are very low only coming out to $54,444.05 while other stores are pulling in at least $260k or more in Texas. 