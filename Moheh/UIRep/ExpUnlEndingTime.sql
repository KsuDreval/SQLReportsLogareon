with tmpcalc as(
select 
	avg(lm."CloseDate" - d."ArrivalTime") as averagetime
from  expectedreceipt er
left join delivery d on d."uuid" = er."Delivery"
left join locationmovement lm on lm."ReferenceDoc" = er."uuid"
where d."ArrivalTime" != '1970-01-01 00:00:00'
and lm."CloseDate" != '1970-01-01 00:00:00'
and (lm."OperationType_name" = 'Предварительная приемка' or lm."OperationType_name" = 'Приемка грузовых мест'))

select 
	"Number"
	, "ArrivalTime" + (select averagetime from tmpcalc) as expectedtime
from delivery
where "StateName" = 'OnTheTerritory' or "StateName" = 'AtTheGate'
