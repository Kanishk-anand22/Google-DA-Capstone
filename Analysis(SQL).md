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
