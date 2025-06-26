create table uber(
	request_id INT,
	pickup_point Varchar(50),
	driver_id varchar(50),
	trip_status varchar(50),
	request_timestamp TIMESTAMP,
	drop_timestamp TIMESTAMP
);


Insights
1) Trip Status Distribution
select trip_status ,count(*) As total
from uber
Group By trip_status

2)Hourly Request Volume
SELECT EXTRACT(HOUR FROM request_timestamp) AS hour, COUNT(*) AS total_requests
FROM uber
GROUP BY hour
ORDER BY total_requests DESC;

3. 📅 Daily Trip Trends

SELECT Date(request_timestamp) AS trip_date, COUNT(*) AS total_requests
FROM uber
GROUP BY trip_date
ORDER BY trip_date;

4. 📍 Pickup Point vs Status Comparison
SELECT pickup_point, trip_status, COUNT(*) AS count
FROM uber
GROUP BY pickup_point, trip_status
ORDER BY pickup_point, count DESC;

5. 📈 Trip Fulfillment Rate
SELECT 
  COUNT(*) FILTER (WHERE trip_status = 'Trip Completed') * 100.0 / COUNT(*) AS fulfillment_rate
FROM uber;

Cancellation Rate by Pickup Point
SELECT pickup_point,
       COUNT(*) FILTER (WHERE trip_status = 'Cancelled') * 100.0 / COUNT(*) AS cancel_rate
FROM uber
GROUP BY pickup_point;

7. ❌ No Car Availability by Hour
SELECT EXTRACT(HOUR FROM request_timestamp) AS hour, COUNT(*) AS no_car_count
FROM uber
WHERE trip_status = 'No Cars Available'
GROUP BY hour
ORDER BY hour Desc;


8. 📊 Completion vs Cancellation by Hour
SELECT 
  EXTRACT(HOUR FROM request_timestamp) AS hour,
  COUNT(*) FILTER (WHERE trip_status = 'Trip Completed') AS completed,
  COUNT(*) FILTER (WHERE trip_status = 'Cancelled') AS cancelled
FROM uber
GROUP BY hour
ORDER BY hour;



11. 🔄 Driver Utilization: Trips Per Driver
SELECT driver_id, COUNT(*) AS trips
FROM uber
WHERE trip_status = 'Trip Completed'
GROUP BY driver_id
ORDER BY trips DESC
LIMIT 10;

14. 📈 Day-of-Week Demand Pattern
SELECT 
    DATE(request_timestamp) AS request_date,
    TO_CHAR(request_timestamp, 'Day') AS day_name,
    COUNT(*) AS total_requests
FROM uber
GROUP BY request_date, day_name
ORDER BY request_date;


✅ Final Query: Daily Trip Status Summary
SELECT 
    DATE(request_timestamp) AS request_date,
    TRIM(TO_CHAR(request_timestamp, 'Day')) AS day_name,
    COUNT(*) FILTER (WHERE trip_status = 'Trip Completed') AS completed_trips,
    COUNT(*) FILTER (WHERE trip_status = 'Cancelled') AS cancelled_trips,
    COUNT(*) FILTER (WHERE trip_status = 'No Cars Available') AS no_car_trips,
    COUNT(*) AS total_requests
FROM uber
WHERE trip_status IS NOT NULL
GROUP BY request_date, day_name
ORDER BY request_date;

15. 🎯 Trip Status % Breakdown
SELECT trip_status,
       COUNT(*) AS count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uber), 2) AS percentage
FROM uber
GROUP BY trip_status;


🔹 Q6: Which day most of car unavailable?
SELECT TO_CHAR(request_timestamp, 'Day') AS weekday,
       COUNT(*) AS no_car_requests
FROM uber
WHERE trip_status = 'No Cars Available'
GROUP BY weekday
ORDER BY no_car_requests DESC;

🔹 Q7: Which day most of car cancel?

SELECT TO_CHAR(request_timestamp, 'Day') AS weekday,
       COUNT(*) AS cancelled_requests
FROM uber
WHERE trip_status = 'Cancelled'
GROUP BY weekday
ORDER BY cancelled_requests DESC;
