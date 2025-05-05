with tmpcalc as(
select 
	avg(d."DepartureTime" - d."ArrivalTime") as averagetime
from  delivery d
where d."ArrivalTime" != '1970-01-01 00:00:00'
and d."DepartureTime" != '1970-01-01 00:00:00')

select 
	"Number"
	, "ArrivalTime" + (select averagetime from tmpcalc) as expectedtime
from delivery
where "StateName" = 'OnTheTerritory' or "StateName" = 'AtTheGate'