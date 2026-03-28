-- Task 2 - Delivery delay analysis

-- Task 2.1 - Calculate delivery delay (in hours) for each shipment using Delivery_Date – Pickup_Date.
SELECT 
    Shipment_ID,
    TIMESTAMPDIFF(HOUR, Pickup_Date, Delivery_Date) AS Calculated_Delay_Hours
FROM dhl_shipments
WHERE Pickup_Date IS NOT NULL
  AND Delivery_Date IS NOT NULL;

-- Task 2.2 - Find the Top 10 delayed routes based on average delay hours.
SELECT 
    Route_ID,
    AVG(Delay_Hours) AS Avg_Delay_Hours
FROM dhl_shipments
GROUP BY Route_ID
ORDER BY Avg_Delay_Hours DESC
LIMIT 10;

-- Task 2.3 - Use SQL window functions to rank shipments by delay within each Warehouse_ID.
SELECT 
    Shipment_ID,
    Warehouse_ID,
    Delay_Hours,
    RANK() OVER (
        PARTITION BY Warehouse_ID 
        ORDER BY Delay_Hours DESC
    ) AS Delay_Rank
FROM dhl_shipments;

-- Task 2.4 - Identify the average delay per Delivery_Type (Express / Standard) to compare service-level efficiency.
SELECT 
    o.Delivery_Type,
    AVG(s.Delay_Hours) AS Avg_Delay_Hours
FROM dhl_shipments s
JOIN dhl_orders o
    ON s.Order_ID = o.Order_ID
GROUP BY o.Delivery_Type;