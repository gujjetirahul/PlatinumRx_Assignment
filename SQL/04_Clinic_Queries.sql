-- Q1. Revenue from each sales channel in a given year
SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021 
GROUP BY sales_channel
ORDER BY total_revenue DESC;


-- Q2. Top 10 most valuable customers in a given year
SELECT
    c.uid,
    c.name,
    c.mobile,
    SUM(cs.amount)  AS total_spent,
    COUNT(cs.oid)   AS total_orders,
    AVG(cs.amount)  AS avg_order_value
FROM customer c
JOIN clinic_sales cs ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021       -- replace year as needed
GROUP BY c.uid, c.name, c.mobile
ORDER BY total_spent DESC
LIMIT 10;

-- Q3. Month-wise revenue, expense, profit & status for a given year
WITH monthly_revenue AS (
    SELECT
        MONTH(datetime)  AS month,
        SUM(amount)      AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021      -- replace year as needed
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime)  AS month,
        SUM(amount)      AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021      -- replace year as needed
    GROUP BY MONTH(datetime)
)
SELECT
    COALESCE(r.month, e.month)            AS month,
    COALESCE(r.revenue, 0)                AS revenue,
    COALESCE(e.expense, 0)                AS expense,
    COALESCE(r.revenue, 0)
        - COALESCE(e.expense, 0)          AS profit,
    CASE
        WHEN COALESCE(r.revenue, 0)
           - COALESCE(e.expense, 0) >= 0
        THEN 'Profitable'
        ELSE 'Not Profitable'
    END                                   AS status
FROM monthly_revenue  r
LEFT JOIN monthly_expense e ON e.month = r.month
ORDER BY month;

-- Q4. Most profitable clinic per city for a given month
WITH clinic_revenue AS (
    SELECT
        cs.cid,
        SUM(cs.amount) AS revenue
    FROM clinic_sales cs
    WHERE YEAR(cs.datetime)  = 2021    -- replace year as needed
      AND MONTH(cs.datetime) = 10      -- replace month as needed
    GROUP BY cs.cid
),
clinic_expense AS (
    SELECT
        e.cid,
        SUM(e.amount) AS expense
    FROM expenses e
    WHERE YEAR(e.datetime)  = 2021     -- replace year as needed
      AND MONTH(e.datetime) = 10       -- replace month as needed
    GROUP BY e.cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        COALESCE(r.revenue, 0)
            - COALESCE(e.expense, 0)   AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON r.cid = cl.cid
    LEFT JOIN clinic_expense e ON e.cid = cl.cid
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT city, cid, clinic_name, profit
FROM ranked
WHERE rnk = 1
ORDER BY city;

-- Q5. Second least profitable clinic per state for a given month
WITH clinic_revenue AS (
    SELECT
        cs.cid,
        SUM(cs.amount) AS revenue
    FROM clinic_sales cs
    WHERE YEAR(cs.datetime)  = 2021    -- replace year as needed
      AND MONTH(cs.datetime) = 10      -- replace month as needed
    GROUP BY cs.cid
),
clinic_expense AS (
    SELECT
        e.cid,
        SUM(e.amount) AS expense
    FROM expenses e
    WHERE YEAR(e.datetime)  = 2021     -- replace year as needed
      AND MONTH(e.datetime) = 10       -- replace month as needed
    GROUP BY e.cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.state,
        COALESCE(r.revenue, 0)
            - COALESCE(e.expense, 0)   AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON r.cid = cl.cid
    LEFT JOIN clinic_expense e ON e.cid = cl.cid
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT state, cid, clinic_name, profit
FROM ranked
WHERE rnk = 2
ORDER BY state;