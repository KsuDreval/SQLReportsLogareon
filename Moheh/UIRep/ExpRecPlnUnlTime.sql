with
minmaxtime as
(select
	er."uuid"
	, er."IncomeDate"
	, min(case when tasks."StartingDate" = '1970-01-01 00:00:00' then null else tasks."StartingDate" end) as bgn_time
	, max(case when (er."State" = 'Taken' or er."State" = 'Taken' or er."State" = 'NotCounted') and tasks."CloseDate" != '1970-01-01 00:00:00' then tasks."CloseDate" else null end) as end_time
from
	(select "StartingDate", "CloseDate", "ReferenceDoc" from locationmovement
	where "OperationType_name" = 'Предварительная приемка' or "OperationType_name" = 'Приемка грузовых мест'
	union all
	select "StartingDate", "CloseDate", "ReferenceDoc" from countingtask
	where "OperationType_name" = 'Приемка (пересчет)') as tasks
left join expectedreceipt er on er."uuid" = tasks."ReferenceDoc"
group by er."uuid", er."IncomeDate")

, tmpcalc as
(select
	avg("bgn_time" - "IncomeDate") as avg_bgn_time
	, avg("end_time" - "IncomeDate") as avg_end_time
from minmaxtime)

select
	"IncomeDate"
	, "IncomeDate" + (select "avg_bgn_time" from tmpcalc) as exp_bgn
	, "IncomeDate" + (select "avg_end_time" from tmpcalc) as exp_end
from expectedreceipt