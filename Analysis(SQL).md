# Capstone data analysis(SQL Server)

Switch to the database you want to use

```{sql eval=FALSE}
USE cyclistic_trip_data
```

## Data collection
Since data was in different CSV sheets for each month, load them into tables and combine the data. I used less data in SQL as compared to R due to some technical issues with using SQL server.

```{sql eval=FALSE}
FROM
(
Select *
from dbo.trip_data_2021_06
union all
select *
from dbo.trip_data_2021_07
union all
select *
from dbo.trip_data_2021_08
union all
select *
from dbo.trip_data_2021_09
union all
select *
from dbo.trip_data_2021_10
union all
select *
from dbo.trip_data_2021_11
)a
```

## Cleaning data

Adding a column to calculate the trip time in seconds

```{sql eval=FALSE}
alter table dbo.combined_data add [ride_length] as (DATEDIFF(SECOND, started_at, ended_at));
```

Check if there are any negative values

```{sql eval=FALSE}
SELECT MIN(ride_length) FROM dbo.combined_data;
```

Deleting negative values of ride length

```{sql eval=FALSE}
DELETE 
	FROM dbo.combined_data 
WHERE
	ride_length<0;
```

Check if there are only 2 values in the membership column

```{sql eval=FALSE}
SELECT 
	COUNT(member_casual) AS subscription_distribution
FROM
	dbo.combined_data
GROUP BY
	member_casual;
```

Segregate date from the started_at field to aggregate and analyze data based on weekdays(and even seasons)

```{sql eval=FALSE}
ALTER TABLE 
	dbo.combined_data
ADD
	[date]
AS
	CONVERT(DATE,[started_at]);
```

Segregate time from the started_at field

```{sql eval=FALSE}
ALTER TABLE
	dbo.combined_data
ADD
	[time]
AS
	CONVERT(TIME(0),[started_at]);
```

ADDING A YEAR COLUMN

```{sql eval=FALSE}
ALTER TABLE
	dbo.combined_data
ADD
	[year]
AS
	YEAR(started_at)
```

ADDING A MONTH COLUMN

```{sql eval=FALSE}
ALTER TABLE
	dbo.combined_data
ADD
	[month]
AS
	MONTH(started_at);
```

ADDING WEEKDAY COLUMN

```{sql eval=FALSE}
ALTER TABLE
	dbo.combined_data
ADD
	[weekday]
AS
	DATENAME(dw,[started_at]);
```

ADDING DAY COLUMN

```{sql eval=FALSE}
ALTER TABLE
	dbo.combined_data
ADD
	[day]
AS
	DAY(started_at);
```

checking data type of the column ride_length

```{sql eval=FALSE}
SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
     TABLE_NAME = 'combined_data' AND 
     COLUMN_NAME = 'ride_length';
```

## Descriptive analysis

Average, median, min and max for each member type

```{sql eval=FALSE}
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
```

calculating avg, median, min and max for each member type on each weekday

```{sql eval=FALSE}
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
```

calculating mode of day of week

```{sql eval=FALSE}
SELECT TOP 3 [weekday] AS [mode_weekday], COUNT(DISTINCT ride_id) AS number_of_rides FROM dbo.combined_data GROUP BY [weekday] ORDER BY COUNT(*) DESC;
```

exporting top 3 weekdays summary statistics into a table

```{sql eval=FALSE}
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
```

exporting avg, median, min and max for each member type on each weekday into a table

```{sql eval=FALSE}
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
```

exporting ride_type

```{sql eval=FALSE}
SELECT 
	rideable_type, COUNT(DISTINCT ride_id) AS number_of_rides
INTO
	cyclistic_trip_data.dbo.ridetype
FROM
	dbo.combined_data
GROUP BY
	rideable_type;

SELECT * FROM dbo.ridetype;
```
