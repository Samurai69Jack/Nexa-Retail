use db;

CREATE TABLE nexa_retail (
    Order_Date VARCHAR(20),
    Customer_Name VARCHAR(100),
    Customer_Type VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Total_Amount VARCHAR(20),
    source_month VARCHAR(20)
);

select * from nexa_retail;


UPDATE nexa_retail SET Total_Amount = REPLACE(Total_Amount, ',', '');
ALTER TABLE nexa_retail MODIFY Total_Amount DECIMAL(12,2);

alter table nexa_retail MODIFY Order_Date date;


-- Q1
SELECT
    QUARTER(Order_Date) AS Quarter,
    round(sum(Total_Amount),2) AS Total_Revenue
FROM nexa_retail
WHERE YEAR(Order_Date) = 2023
GROUP BY Quarter
ORDER BY Quarter;

-- Revenue trend across quarter reveals seasonal demand patterns, that helps 
-- businesses plan inventory and staffing around peak months rather than spreading
-- resources evenly


-- Q2

SELECT Customer_Name, City, ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM nexa_retail
GROUP BY Customer_Name, City
ORDER BY Total_Revenue DESC
LIMIT 5;

-- These 5 stores are the stronghold of the Company,and no they are not located
-- in the same city but rather spread out in 5 different cities altogether
--

-- Q3

SELECT Category, ROUND(AVG(Total_Amount), 2) AS Avg_Revenue_Per_Transaction
FROM nexa_retail
GROUP BY Category
ORDER BY Avg_Revenue_Per_Transaction DESC
LIMIT 1;

-- the category Atta generates the most value per sale, making it a natural focus
-- for premium shelf placement, cross selling or bundling with lower-margin items
-- it also suggests where marketing spend could yield the highest return 
-- per customer interaction

-- Q4
-- Data insufficient


-- Q5

SELECT 
    source_month,
    ROUND(SUM(Total_Amount), 2) AS Monthly_Revenue,
    ROUND(LAG(SUM(Total_Amount)) OVER (ORDER BY MIN(Order_Date)), 2) AS Prev_Month_Revenue,
    ROUND(
        (SUM(Total_Amount) - LAG(SUM(Total_Amount)) OVER (ORDER BY MIN(Order_Date)))
        / LAG(SUM(Total_Amount)) OVER (ORDER BY MIN(Order_Date)) * 100
    , 2) AS MoM_Growth_Rate
FROM nexa_retail
GROUP BY source_month
ORDER BY MIN(Order_Date);

-- or use the approach below:
WITH monthly AS (
    SELECT 
        source_month,
        MIN(Order_Date) AS month_date,
        ROUND(SUM(Total_Amount), 2) AS Monthly_Revenue
    FROM nexa_retail
    GROUP BY source_month
),
growth AS (
    SELECT 
        m1.source_month,
        ROUND((m1.Monthly_Revenue - m2.Monthly_Revenue) / m2.Monthly_Revenue * 100, 2) AS MoM_Growth_Rate
    FROM monthly m1
    LEFT JOIN monthly m2 
        ON m2.month_date = DATE_SUB(m1.month_date, INTERVAL 1 MONTH)
)
SELECT source_month, MoM_Growth_Rate
FROM growth
WHERE MoM_Growth_Rate IS NOT NULL
ORDER BY MoM_Growth_Rate ASC
LIMIT 1;

-- The MoM trend shows how the business is scaling, whether it is steady or
-- experiencing volatile swings. here we can see that there are months that have seen
-- negative growth in some months and some months have seen really good positive growth
-- with the sharpest decline being in aug 2023 at -21% which needs to be looked into
-- to better understand the factors causing or influencing it like whether its the season
-- or supply disruption or competition activity or any other deeper operational issue


-- Q6

select City, round(avg(Total_Amount),2) as Avg_Basket_Size from nexa_retail
group by City
order by Avg_Basket_Size desc;

-- or: 

SELECT * FROM (
    SELECT City, ROUND(AVG(Total_Amount), 2) AS Avg_Basket_Size, 'Highest' AS Rank_Label
    FROM nexa_retail
    GROUP BY City
    ORDER BY Avg_Basket_Size DESC
    LIMIT 1
) AS highest

UNION ALL

SELECT * FROM (
    SELECT City, ROUND(AVG(Total_Amount), 2) AS Avg_Basket_Size, 'Lowest' AS Rank_Label
    FROM nexa_retail
    GROUP BY City
    ORDER BY Avg_Basket_Size ASC
    LIMIT 1
) AS lowest;

-- OR: 

WITH city_basket AS (
    SELECT City, ROUND(AVG(Total_Amount), 2) AS Avg_Basket_Size,
        RANK() OVER (ORDER BY AVG(Total_Amount) DESC) AS high_rank,
        RANK() OVER (ORDER BY AVG(Total_Amount) ASC) AS low_rank
    FROM nexa_retail
    GROUP BY City
)
SELECT City, Avg_Basket_Size,
    CASE WHEN high_rank = 1 THEN 'Highest' WHEN low_rank = 1 THEN 'Lowest' END AS Rank_Label
FROM city_basket
WHERE high_rank = 1 OR low_rank = 1;

-- The highest avg basket size is of Solapur which indicates stronger purchasing power
-- or more effective in-store upselling that makes them a good candidate for
-- higher return product rollouts.
-- The lowest avg basket size is Kolhapur which signifies that it needs more offers,
-- loyalty discounts or pricing review to lift transactional value

-- Q7

SELECT Customer_Type,
    COUNT(DISTINCT Customer_Name) AS Total_Stores,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue,
    ROUND(SUM(Total_Amount) / COUNT(DISTINCT Customer_Name), 2) AS Revenue_Per_Store
FROM nexa_retail
GROUP BY Customer_Type
ORDER BY Revenue_Per_Store DESC;

-- OR: 

SELECT Customer_Type, 
    ROUND(AVG(store_revenue), 2) AS Revenue_Per_Store
FROM (
    SELECT Customer_Name, Customer_Type,
        SUM(Total_Amount) AS store_revenue
    FROM nexa_retail
    GROUP BY Customer_Name, Customer_Type
) AS store_totals
GROUP BY Customer_Type
ORDER BY Revenue_Per_Store DESC;

-- overall both models are contributing almost same Revenue per Store
-- However taking into account taht 10 supermarkets are generating Revenue that is
-- almost equivalent to that of 30 Kirana stores signifies that they are a better fit
-- for further expansion and partnership investment in the future if more stores
-- need to be opened


-- Q8

WITH units_per_month AS (
    SELECT Product_Name, source_month,
        MIN(Order_Date) AS month_date,
        SUM(Quantity) AS Units_Sold
    FROM nexa_retail
    GROUP BY Product_Name, source_month
),
growth_vol AS (
    SELECT Product_Name, source_month, Units_Sold,
        LAG(Units_Sold) OVER (PARTITION BY Product_Name ORDER BY month_date) AS Prev_Units_Sold,
        ROUND(
            (Units_Sold - LAG(Units_Sold) OVER (PARTITION BY Product_Name ORDER BY month_date))
            / LAG(Units_Sold) OVER (PARTITION BY Product_Name ORDER BY month_date) * 100
        , 2) AS Rate_of_Decline_Incline
    FROM units_per_month
),
product_avg_decline AS (
    SELECT Product_Name,
        ROUND(AVG(Rate_of_Decline_Incline), 2) AS Avg_Growth_Rate
    FROM growth_vol
    WHERE Rate_of_Decline_Incline IS NOT NULL  -- excludes first month (no previous to compare)
    GROUP BY Product_Name
)
SELECT Product_Name, Avg_Growth_Rate
FROM product_avg_decline
ORDER BY Avg_Growth_Rate ASC
LIMIT 3;

-- These 3 products are losing demand despite pricing being the same,
-- which suggests that there is shift in customer preference rather than
-- price issue
-- there needs to be a change in how they are sold or handled in order to
-- prevent them from affecting the revenue


-- Q9

with top_10_percent_stores as (
	select Customer_Name, sum(Total_Amount) as Total_Revenue
	from nexa_retail
	group by Customer_Name
	order by Total_Revenue desc
	limit 4
),
total_rev as (
select sum(Total_Amount) as Total_Rev from nexa_retail
)

select round(sum(t.Total_Revenue)/max(tr.Total_Rev) *100,2) as Top_10_Percent_Stores_Revenue_Share
from top_10_percent_stores t
cross join total_rev tr;

-- OR: 

with store_revenue as (
	select Customer_Name, sum(Total_Amount) as Revenue,
    rank() over(order by sum(Total_Amount) desc) as rnk
    from nexa_retail
    group by Customer_Name
),
total_rev as (
	select sum(Total_Amount) as Total_Revenue from nexa_retail
),
top_10 as (
	select sum(Revenue) as top_store_rev from store_revenue
    where rnk<=(select ceil(count(Customer_Name)*0.10) from store_revenue)
)
select round(t.top_store_rev/tt.Total_Revenue*100,2) as Top_10_Percent_Store_Revenu_Share
from top_10 t cross join total_rev tt;

-- The top 10% stores generate close to 11% Revenue which is a good number but also
-- highlights a dependency risk that if even one of these stores is affected,
-- the overall revenue would take a big hit of atleast 3-4%



-- Q10
with bottom_3 as (
	select Product_Name, sum(Total_Amount) as Revenue from nexa_retail
	group by Product_Name
	order by Revenue asc
	limit 3),
total_rev as (
	select sum(Total_Amount) as Total_Revenue from nexa_retail
)
select round(sum(b.Revenue)/max(t.Total_Revenue)*100,2) as Percentage_of_Revenue_Lost
from bottom_3 b cross join
total_rev t;

-- OR:

with products_ranked as (
	select Product_Name, sum(Total_Amount) as Revenue, rank()
    over(order by sum(Total_Amount) asc) as rnk from nexa_retail
    group by Product_Name
),
Total_Rev as (
	select sum(Total_Amount) as Total_Revenue from nexa_retail
)
select round(sum(p.Revenue)/max(t.Total_Revenue)*100,2) as Percentage_of_Revenue
from products_ranked p cross join Total_Rev t
where p.rnk<=3;

-- if bottom 3 products are discontinued, they contribute to approx 3% of the revenue
-- which shows that they can be phased out in a proper manner over time without
-- letting it affect the revenue and free up space for new products




