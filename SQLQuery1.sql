SELECT 
    Category,
    Courier_Partner,
    COUNT(AWB_Number) AS total_rto_incidents,
    -- Safely casting the text dates to true PostgreSQL DATES to find the average loop duration
    ROUND(AVG(CAST(Delivered_Date AS DATE) - CAST(Dispatch_Date AS DATE)), 1) AS avg_days_in_transit_loop,
    -- Pinpointing the longest operational delays
    MAX(CAST(Delivered_Date AS DATE) - CAST(Dispatch_Date AS DATE)) AS max_network_delay_days
FROM meesho_logistics_fact
GROUP BY Category, Courier_Partner
ORDER BY total_rto_incidents DESC;
