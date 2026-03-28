-- Task 3 - Route Optimization Insights 

-- Task 3.1 - Average transit time (in hours) across all shipments.
SELECT 
    Route_ID,
    AVG(TIMESTAMPDIFF(HOUR, Pickup_Date, Delivery_Date)) AS Avg_Transit_Time_Hours
FROM dhl_shipments
WHERE Pickup_Date IS NOT NULL
  AND Delivery_Date IS NOT NULL
GROUP BY Route_ID;

-- Task 3.2 - Average delay (in hours) per route.
SELECT 
    Route_ID,
    AVG(Delay_Hours) AS Avg_Delay_Hours
FROM dhl_shipments
GROUP BY Route_ID;

-- Task 3.3 - Distance-to-time efficiency ratio = Distance_KM / Avg_TransitTime__Hours.
SELECT 
    r.Route_ID,
    r.Distance_KM,
    AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)) AS Avg_Transit_Time_Hours,
    r.Distance_KM / 
    AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)) AS Efficiency_Ratio
FROM dhl_routes r
JOIN dhl_shipments s
    ON r.Route_ID = s.Route_ID
WHERE s.Pickup_Date IS NOT NULL
  AND s.Delivery_Date IS NOT NULL
GROUP BY r.Route_ID, r.Distance_KM;

-- Task 3.4 - Identify 3 routes with the worst efficiency ratio (lowest distance-to-time).
SELECT 
    r.Route_ID,
    r.Distance_KM / 
    AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)) AS Efficiency_Ratio
FROM dhl_routes r
JOIN dhl_shipments s
    ON r.Route_ID = s.Route_ID
WHERE s.Pickup_Date IS NOT NULL
  AND s.Delivery_Date IS NOT NULL
GROUP BY r.Route_ID, r.Distance_KM
ORDER BY Efficiency_Ratio ASC
LIMIT 3;

-- Task 3.5 - Find routes with >20% of shipments delayed beyond expected transit time.
SELECT 
    s.Route_ID,
    COUNT(*) AS Total_Shipments,
    SUM(
        CASE 
            WHEN TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date) 
                 > r.Avg_Transit_Time_Hours 
            THEN 1 
            ELSE 0 
        END
    ) AS Delayed_Shipments,
    (SUM(
        CASE 
            WHEN TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date) 
                 > r.Avg_Transit_Time_Hours 
            THEN 1 
            ELSE 0 
        END
    ) / COUNT(*)) * 100 AS Delay_Percentage
FROM dhl_shipments s
JOIN dhl_routes r
    ON s.Route_ID = r.Route_ID
GROUP BY s.Route_ID
HAVING Delay_Percentage > 20;

-- Task 3.6 - Recommend potential routes or hub pairs for optimization.

-- Routes with low efficiency ratios and high delay percentages should be prioritized for optimization. 
-- Possible improvements include rerouting via less congested hubs, increasing transportation capacity, 
-- or revising expected transit benchmarks.”