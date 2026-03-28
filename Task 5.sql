-- Task 5 - Delivery Agent Performance

-- Task 5.1 - Rank delivery agents (per route) by on-time delivery percentage.
SELECT 
    s.Route_ID,
    s.Agent_ID,
    ROUND(
        (SUM(CASE 
            WHEN s.Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) * 100, 
        2
    ) AS On_Time_Percentage,
    RANK() OVER (
        PARTITION BY s.Route_ID
        ORDER BY 
        (SUM(CASE 
            WHEN s.Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) DESC
    ) AS Agent_Rank
FROM dhl_shipments s
GROUP BY s.Route_ID, s.Agent_ID;

-- Task 5.2 - Find agents whose on-time % is below 85%.
SELECT 
    Agent_ID,
    ROUND(
        (SUM(CASE 
            WHEN Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) * 100, 
        2
    ) AS On_Time_Percentage
FROM dhl_shipments
GROUP BY Agent_ID
HAVING On_Time_Percentage < 85;

-- Tasl 5.3 - Compare the average rating and experience (in years) of the top 5 vs bottom 5 agents using subqueries.

-- Top 5 best agents
WITH Agent_Performance AS (
    SELECT 
        s.Agent_ID,
        (SUM(CASE 
            WHEN s.Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) * 100 AS On_Time_Percentage
    FROM dhl_shipments s
    GROUP BY s.Agent_ID
)
SELECT 
    a.Agent_ID,
    a.Avg_Rating,
    a.Experience_Years,
    p.On_Time_Percentage
FROM Agent_Performance p
JOIN dhl_delivery_Agents a
    ON p.Agent_ID = a.Agent_ID
ORDER BY p.On_Time_Percentage DESC
LIMIT 5;

-- Top 5 worst agents
WITH Agent_Performance AS (
    SELECT 
        s.Agent_ID,
        (SUM(CASE 
            WHEN s.Delay_Hours = 0 THEN 1 
            ELSE 0 
        END) / COUNT(*)) * 100 AS On_Time_Percentage
    FROM dhl_shipments s
    GROUP BY s.Agent_ID
)
SELECT 
    a.Agent_ID,
    a.Avg_Rating,
    a.Experience_Years,
    p.On_Time_Percentage
FROM Agent_Performance p
JOIN dhl_delivery_Agents a
    ON p.Agent_ID = a.Agent_ID
ORDER BY p.On_Time_Percentage ASC
LIMIT 5;

-- Task 5.4 - Suggest training or workload balancing strategies for low-performing agents based on insights.
-- "Agents with low on-time delivery percentages should receive focused training and workload balancing. High-performing
-- agents can be assigned to complex routes or used as mentors. Performance-based incentives may further improve delivery
-- efficiency."

