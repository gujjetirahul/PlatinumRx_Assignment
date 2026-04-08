-- Q1: For every user in the system, get the user_id and last booked room_no
SELECT u.user_id, b.room_no
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
);

-- Q2: Get booking_id and total billing amount of every booking created in November, 2021
SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01'
  AND b.booking_date <  '2021-12-01'
GROUP BY b.booking_id;

-- Q3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'
  AND bc.bill_date <  '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- Q4. Determine the most ordered and least ordered item of each month of year 2021
WITH monthly_item_totals AS (
    SELECT
        MONTH(bc.bill_date)              AS month,
        bc.item_id,
        i.item_name,
        SUM(bc.item_quantity)            AS total_qty
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), bc.item_id, i.item_name
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rank_desc,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC)  AS rank_asc
    FROM monthly_item_totals
)
SELECT
    month,
    MAX(CASE WHEN rank_desc = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_asc  = 1 THEN item_name END) AS least_ordered_item
FROM ranked
WHERE rank_desc = 1 OR rank_asc = 1
GROUP BY month
ORDER BY month;

-- Q5. Find the customers with the second highest bill value of each month of year 2021
WITH bill_totals AS (
    SELECT
        bc.bill_id,
        b.user_id,
        u.name,
        MONTH(bc.bill_date)              AS month,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN bookings b  ON bc.booking_id = b.booking_id
    JOIN users u     ON b.user_id     = u.user_id
    JOIN items i     ON bc.item_id    = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY bc.bill_id, b.user_id, u.name, MONTH(bc.bill_date)
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_amount DESC) AS rnk
    FROM bill_totals
)
SELECT month, bill_id, user_id, name, bill_amount
FROM ranked
WHERE rnk = 2
ORDER BY month;