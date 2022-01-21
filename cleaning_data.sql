USE cyclistic_trip_data

--Adding a column to calculate the trip time in seconds
alter table dbo.combined_data add [ride_length] as (DATEDIFF(SECOND, started_at, ended_at));

SELECT TOP 10 * FROM dbo.combined_data;

--to check if there is any negative values
SELECT MIN(ride_length) FROM dbo.combined_data;

--deleting negative values of ride length
DELETE 
	FROM dbo.combined_data 
WHERE
	ride_length<0;

--to check if there are only 2 values in the membership column
SELECT 
	COUNT(member_casual) AS subscription_distribution
FROM
	dbo.combined_data
GROUP BY
	member_casual;

--to segregate date from the started_at field
ALTER TABLE 
	dbo.combined_data
ADD
	[date]
AS
	CONVERT(DATE,[started_at]);

--to segregate time from the started_at field
ALTER TABLE
	dbo.combined_data
ADD
	[time]
AS
	CONVERT(TIME(0),[started_at]);

--ADDING A YEAR COLUMN
ALTER TABLE
	dbo.combined_data
ADD
	[year]
AS
	YEAR(started_at)

--ADDING A MONTH COLUMN
ALTER TABLE
	dbo.combined_data
ADD
	[month]
AS
	MONTH(started_at);

SELECT TOP 10 * FROM dbo.combined_data;

--ADDING WEEKDAY COLUMN
ALTER TABLE
	dbo.combined_data
ADD
	[weekday]
AS
	DATENAME(dw,[started_at]);

--ADDING DAY COLUMN
ALTER TABLE
	dbo.combined_data
ADD
	[day]
AS
	DAY(started_at);

--checking data type of the column ride_length
SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
     TABLE_NAME = 'combined_data' AND 
     COLUMN_NAME = 'ride_length';