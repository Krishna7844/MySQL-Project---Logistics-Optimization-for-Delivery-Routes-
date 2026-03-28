-- TASK 4 - WAREHOUSE PERFORMANCE

-- Task 4.1 - Find the top 3 warehouses with the highest average delay in shipments dispatched.
SELECT 
    Warehouse_ID,
    ROUND(AVG(Delay_Hours), 2) AS Avg_Delay_Hours
FROM dhl_shipments
GROUP BY Warehouse_ID
ORDER BY Avg_Delay_Hours DESC
LIMIT 3;

-- Task 4.2 - Calculate total shipments vs delayed shipments for each warehouse.
SELECT 
    Warehouse_ID,
    COUNT(*) AS Total_Shipments,
    SUM(CASE 
        WHEN Delay_Hours > 0 THEN 1 
        ELSE 0 
    END) AS Delayed_Shipments
FROM dhl_shipments
GROUP BY Warehouse_ID;

-- Task 4.3 - Use CTEs to identify warehouses where average delay exceeds the global average delay.
WITH Global_Avg AS (
    SELECT AVG(Delay_Hours) AS Global_Avg_Delay
    FROM dhl_shipments
),
Warehouse_Avg AS (
    SELECT 
        Warehouse_ID,
        AVG(Delay_Hours) AS Warehouse_Avg_Delay
    FROM dhl_shipments
    GROUP BY Warehouse_ID
)
SELECT 
    w.Warehouse_ID,
    w.Warehouse_Avg_Delay
FROM Warehouse_Avg w
JOIN Global_Avg g
    ON w.Warehouse_Avg_Delay > g.Global_Avg_Delay;

-- Task 4.4 - Rank all warehouses based on on-time delivery percentage.
SELECT 
    Warehouse_ID,
    ROUND(
        (SUM(CASE 
            WHEN Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) * 100, 
        2
    ) AS On_Time_Delivery_Percentage,
    RANK() OVER (
        ORDER BY 
        (SUM(CASE 
            WHEN Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) DESC
    ) AS Warehouse_Rank
FROM dhl_shipments
GROUP BY Warehouse_ID;
