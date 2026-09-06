WITH CalculatedLogistics AS (
    SELECT 
        Category,
        Courier_Partner,
        AWB_Number,
        -- NULLIF handles blank strings safely, casting to true dates
        CAST(NULLIF(Delivered_Date, '') AS DATE) AS clean_delivered_date,
        CAST(NULLIF(Dispatch_Date, '') AS DATE) AS clean_dispatch_date
    FROM meesho_logistics_fact
),
TransitMetrics AS (
    SELECT 
        Category,
        Courier_Partner,
        AWB_Number,
        -- Calculate the transit duration once in days
        (clean_delivered_date - clean_dispatch_date) AS days_in_transit
    FROM CalculatedLogistics
)
SELECT 
    Category,
    Courier_Partner,
    COUNT(AWB_Number) AS total_rto_incidents,
    ROUND(AVG(days_in_transit), 1) AS avg_days_in_transit_loop,
    MAX(days_in_transit) AS max_network_delay_days
FROM TransitMetrics
GROUP BY Category, Courier_Partner
ORDER BY total_rto_incidents DESC;
