-- Task 6 - Shipment Tracking Analytics 

-- Task 6.1 -- For each shipment, display the latest status (Delivered, In Transit, or Returned) along with the latest Delivery_Date.
SELECT 
    Shipment_ID,
    Delivery_Status,
    MAX(Delivery_Date) AS Latest_Delivery_Date
FROM dhl_shipments
GROUP BY Shipment_ID, Delivery_Status;

-- Task 6.2 - Identify routes where the majority of shipments are still “In Transit” or “Returned”.
SELECT 
    Route_ID,
    COUNT(*) AS Total_Shipments,
    SUM(CASE 
        WHEN Delivery_Status IN ('In Transit', 'Returned') THEN 1 
        ELSE 0 
    END) AS Problematic_Shipments,
    (SUM(CASE 
        WHEN Delivery_Status IN ('In Transit', 'Returned') THEN 1 
        ELSE 0 
    END) / COUNT(*)) * 100 AS Problematic_Percentage
FROM dhl_shipments
GROUP BY Route_ID;

-- Task 6.3 - Find the most frequent delay reasons (if available in delay-related columns or flags).
SELECT 
    CASE 
        WHEN Delay_Hours = 0 THEN 'No Delay'
        WHEN Delay_Hours BETWEEN 1 AND 24 THEN 'Minor Delay'
        WHEN Delay_Hours BETWEEN 25 AND 72 THEN 'Moderate Delay'
        ELSE 'Severe Delay'
    END AS Delay_Category,
    COUNT(*) AS Shipment_Count
FROM dhl_shipments
GROUP BY Delay_Category
ORDER BY Shipment_Count DESC;

-- Task 6.4 - Identify orders with exceptionally high delay (>120 hours) to investigate potential bottlenecks.
SELECT 
    Shipment_ID,
    Order_ID,
    Route_ID,
    Warehouse_ID,
    Delay_Hours
FROM dhl_shipments
WHERE Delay_Hours > 120
ORDER BY Delay_Hours DESC;




