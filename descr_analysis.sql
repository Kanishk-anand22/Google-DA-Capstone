--Descriptive analysis

--Average, median, min and max for each member type
SELECT
member_casual, (
 (SELECT MAX(ride_length) FROM
   (SELECT TOP 50 PERCENT ride_length FROM dbo.combined_data ORDER BY ride_length) AS BottomHalf)
 +
 (SELECT MIN(ride_length) FROM
   (SELECT TOP 50 PERCENT ride_length FROM dbo.combined_data ORDER BY ride_length DESC) AS TopHalf)
) / 2 AS Median, AVG(CAST(ride_length AS bigint)) AS average_ride_length, MIN(ride_length) AS minimum_ride_duration, MAX(ride_length) AS max_ride_duration
INTO
	cyclistic_trip_data.dbo.summ_membertype
FROM
	dbo.combined_data
GROUP BY
	member_casual;

select * from dbo.summ_membertype;

--calculating avg, median, min and max for each member type on each weekday
SELECT 
	member_casual, [weekday], COUNT(DISTINCT ride_id) AS number_of_rides, (
 (SELECT MAX(ride_length) FROM
   (SELECT TOP 50 PERCENT ride_length FROM dbo.combined_data ORDER BY ride_length) AS BottomHalf)
 +
 (SELECT MIN(ride_length) FROM
   (SELECT TOP 50 PERCENT ride_length FROM dbo.combined_data ORDER BY ride_length DESC) AS TopHalf)
) / 2 AS Median, AVG(CAST(ride_length AS bigint)) AS average_ride_length, MIN(ride_length) AS minimum_ride_duration, MAX(ride_length) AS max_ride_duration
FROM 
	dbo.combined_data
GROUP BY 
	member_casual, [weekday]
ORDER BY
	member_casual ASC,
	CASE
		WHEN [weekday] = 'Sunday' THEN 1
		WHEN [weekday] = 'Monday' THEN 2
		WHEN [weekday] = 'Tuesday' THEN 3
		WHEN [weekday] = 'Wednesday' THEN 4
		WHEN [weekday] = 'Thursday' THEN 5
		WHEN [weekday] = 'Friday' THEN 6
		WHEN [weekday] = 'Saturday' THEN 7
	END ASC;

--calculating mode of day of week
SELECT TOP 3 [weekday] AS [mode_weekday], COUNT(DISTINCT ride_id) AS number_of_rides FROM dbo.combined_data GROUP BY [weekday] ORDER BY COUNT(*) DESC;


--exporting top 3 weekdays summary statistics into a table
SELECT 
	TOP 3 [weekday] AS [mode_weekday], COUNT(DISTINCT ride_id) AS number_of_rides 
INTO
	cyclistic_trip_data.dbo.top3weekdays
FROM 
	dbo.combined_data 
GROUP BY 
	[weekday] 
ORDER BY 
	number_of_rides DESC;

--exporting avg, median, min and max for each member type on each weekday into a table
SELECT 
	member_casual, [weekday], COUNT(DISTINCT ride_id) AS number_of_rides, (
 (SELECT MAX(ride_length) FROM
   (SELECT TOP 50 PERCENT ride_length FROM dbo.combined_data ORDER BY ride_length) AS BottomHalf)
 +
 (SELECT MIN(ride_length) FROM
   (SELECT TOP 50 PERCENT ride_length FROM dbo.combined_data ORDER BY ride_length DESC) AS TopHalf)
) / 2 AS Median, AVG(CAST(ride_length AS bigint)) AS average_ride_length, MIN(ride_length) AS minimum_ride_duration, MAX(ride_length) AS max_ride_duration
INTO
	cyclistic_trip_data.dbo.summstats
FROM 
	dbo.combined_data
GROUP BY 
	member_casual, [weekday]
ORDER BY
	member_casual ASC,
	CASE
		WHEN [weekday] = 'Sunday' THEN 1
		WHEN [weekday] = 'Monday' THEN 2
		WHEN [weekday] = 'Tuesday' THEN 3
		WHEN [weekday] = 'Wednesday' THEN 4
		WHEN [weekday] = 'Thursday' THEN 5
		WHEN [weekday] = 'Friday' THEN 6
		WHEN [weekday] = 'Saturday' THEN 7
	END ASC;

SELECT * FROM dbo.summstats

--exporting ride_type
SELECT 
	rideable_type, COUNT(DISTINCT ride_id) AS number_of_rides
INTO
	cyclistic_trip_data.dbo.ridetype
FROM
	dbo.combined_data
GROUP BY
	rideable_type;

SELECT * FROM dbo.ridetype;