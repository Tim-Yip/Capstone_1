-- Territory: Texas
USE sample_sales;

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?
-- Total revenue: 8,208,311.29
-- Dates: 01/01/2022 - 12/31/2025
SELECT
	SUM(Sale_Amount) Total_Sales,
	MIN(Transaction_Date) Start_Date,
	MAX(Transaction_Date) Latest_date
FROM (
	SELECT 
		ss.Sale_Amount,
		ss.Transaction_Date
	FROM store_sales ss
	JOIN store_locations sl
		ON ss.Store_ID = sl.StoreID
	WHERE sl.State = 'Texas'
	UNION ALL
	SELECT 
		SalesTotal,
        `Date`
	FROM online_sales
	WHERE ShiptoState = 'Texas'
) combined_sales;

-- What is the revenue breakdown by year and month for the sales territory?
-- Total revenue in Texas for each month of each year. 
SELECT
	YEAR(Transaction_Date) 'Year',
    MONTH(Transaction_Date) 'Month',
    SUM(Sale_Amount) Total_Sales
FROM (
	SELECT 
		ss.Sale_Amount,
		ss.Transaction_Date
	FROM store_sales ss
	JOIN store_locations sl
		ON ss.Store_ID = sl.StoreID
	WHERE sl.State = 'Texas'
	UNION ALL
	SELECT 
		SalesTotal,
        `Date`
	FROM online_sales
	WHERE ShiptoState = 'Texas'
) combined_sales
GROUP BY 
	YEAR(Transaction_Date),
    MONTH(Transaction_Date);
    
-- Total revenue in Texas for each specific year.
SELECT
	YEAR(Transaction_Date) 'Year',
    SUM(Sale_Amount) Total_Sales
FROM (
	SELECT 
		ss.Sale_Amount,
		ss.Transaction_Date
	FROM store_sales ss
	JOIN store_locations sl
		ON ss.Store_ID = sl.StoreID
	WHERE sl.State = 'Texas'
	UNION ALL
	SELECT 
		SalesTotal,
        `Date`
	FROM online_sales
	WHERE ShiptoState = 'Texas'
) combined_sales
GROUP BY 
	YEAR(Transaction_Date);

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.

-- What is the number of transactions per month and average transaction amount by product category for the sales territory?

-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?

-- What is your recommendation for where to focus sales attention in the next quarter?