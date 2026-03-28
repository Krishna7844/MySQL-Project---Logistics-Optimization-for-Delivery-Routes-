-- Task 7 - Advanced KPI Reporting

-- Task 7.1 - Average Delivery Delay per Source_Country.
SELECT 
    r.Source_Country,
    ROUND(AVG(s.Delay_Hours), 2) AS Avg_Delay_Hours
FROM dhl_shipments s
JOIN dhl_routes r
    ON s.Route_ID = r.Route_ID
GROUP BY r.Source_Country
ORDER BY Avg_Delay_Hours DESC;

-- Task 7.2 - On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100.
SELECT 
    ROUND(
        (SUM(CASE 
            WHEN Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) * 100, 
        2
    ) AS On_Time_Delivery_Percentage
FROM dhl_shipments;

-- Task 7.3 - Average Delay (in hours) per Route_ID.
SELECT
    Route_ID,
    ROUND(AVG(Delay_Hours), 2) AS Avg_Delay_Hours
FROM dhl_shipments
GROUP BY Route_ID
ORDER BY Avg_Delay_Hours;

-- Task 7.4 - Warehouse Utilization % = (Shipments_Handled / Capacity_per_day) * 100.
-- Shipments count per warehouse
SELECT 
    Warehouse_ID,
    COUNT(*) AS Shipments_Handled
FROM dhl_shipments
GROUP BY Warehouse_ID;

-- Calculating utilization by joining warehouses table
SELECT 
    w.Warehouse_ID,
    w.Capacity_per_day,
    COUNT(s.Shipment_ID) AS Shipments_Handled,
    ROUND(
        (COUNT(s.Shipment_ID) / w.Capacity_per_day) * 100,
        2
    ) AS Warehouse_Utilization_Percentage
FROM dhl_warehouses w
LEFT JOIN dhl_shipments s
    ON w.Warehouse_ID = s.Warehouse_ID
GROUP BY w.Warehouse_ID, w.Capacity_per_day;



