-- Task 1 - Data Cleaning and Preparation

-- Task 1.1 - Identify and delete duplicate Order_ID or Shipment_ID records.
-- For orders
SELECT Order_ID, COUNT(*) AS duplicate_count
FROM dhl_orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;
-- For shipments
SELECT Shipment_ID, COUNT(*) AS duplicate_count
FROM dhl_shipments
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;

-- Result - No duplicates of order_id and shipments_id found

-- Task 1.2 - Replace null or missing Delay Hours values in the Shipments Table with the average delay for that Route ID.

SELECT COUNT(*) AS null_delays
FROM dhl_shipments
WHERE Delay_Hours IS NULL;

-- No null vales found

-- Task 1.3 - Convert all date columns (Order_Date, Pickup_Date, Delivery_Date) into YYYY-MM-DDHH:MM:SS format using SQL date functions.

-- For orders dataset
UPDATE dhl_orders
SET Order_Date = STR_TO_DATE(Order_Date, '%Y-%m-%d %H:%i:%s');

-- For shipments dataset
UPDATE dhl_shipments
SET Pickup_Date = STR_TO_DATE(Pickup_Date, '%Y-%m-%d %H:%i:%s'),
    Delivery_Date = STR_TO_DATE(Delivery_Date, '%Y-%m-%d %H:%i:%s');

-- Task 1.4 - Ensure that no Delivery_Date occurs before Pickup_Date

SELECT *
FROM dhl_shipments
WHERE Delivery_Date < Pickup_Date;

-- No devlivery date before pickup date found

-- Task 1.5 - Validate referential integrity between Orders, Routes, Warehouses, and Shipments.

-- Check invalid order_id
SELECT s.Order_ID
FROM dhl_shipments s
LEFT JOIN dhl_orders o ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

-- Check invalid warehouse ID
SELECT s.Warehouse_ID
FROM dhl_shipments s
LEFT JOIN dhl_warehouses w ON s.Warehouse_ID = w.Warehouse_ID
WHERE w.Warehouse_ID IS NULL;

-- Check invalid route id
SELECT s.Route_ID
FROM dhl_shipments s
LEFT JOIN dhl_routes r ON s.Route_ID = r.Route_ID
WHERE r.Route_ID IS NULL;

