SELECT *
	INTO dbo.combined_data
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
