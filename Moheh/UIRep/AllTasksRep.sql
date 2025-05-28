with
alltask as
(select
	"DeadLine", "CloseDate", "State", "ReferenceDoc"
from locationmovement
union all
select 
	"DeadLine", "CloseDate", "State", "ReferenceDoc"
from skumovement
union all
select 
	"DeadLine", "CloseDate", "State", "ReferenceDoc"
from countingtask)

, tmpcacldeadline as
(select
	avg("CloseDate" - "DeadLine") as avg_deadline
from alltask
where "DeadLine" != '1970-01-01 00:00:00' and "CloseDate" != '1970-01-01 00:00:00'
and "State" = 'Completed')

, tmpcalcer as 
(select
	avg(at."CloseDate" - er."IncomeDate") as avg_er_deadline
from alltask at
left join expectedreceipt er on er."uuid" = at."ReferenceDoc"
where at."ReferenceDoc" != '' and at."CloseDate" != '1970-01-01 00:00:00' and er."uuid" != '')

, tmpcalcso as
(select
	avg(at."CloseDate" - so."ShippingDate") as avg_so_deadline
from alltask at
left join shippingorder so on so."uuid" = at."ReferenceDoc"
where at."ReferenceDoc" != '' and at."CloseDate" != '1970-01-01 00:00:00' and so."uuid" != '')


select
	t."Nr"
	, t."DisplayBusinessStatus"
	, t."Error_name"
	, t."OperationType_name"
	, e."Name"
	, case
		when er."ERPNr" != '' then er."ERPNr"
		else so."ERPNr"
	end as ref_doc
	, case
		when t."DeadLine" = '1970-01-01 00:00:00' then null
		else t."DeadLine" end
	, case 
		when t."DeadLine" != '1970-01-01 00:00:00' then (select avg_deadline from tmpcacldeadline) + t."DeadLine"
		else (case
			when er."ERPNr" != '' then er."IncomeDate" + (select avg_er_deadline from tmpcalcer)
			else so."ShippingDate" + (select avg_so_deadline from tmpcalcso)
			end)
	end as our_plan_time
from 
	(select 
	"Nr", "DisplayBusinessStatus", "Error_name", "OperationType_name", "DeadLine", "AssigneeRef", "ReferenceDoc"
	from locationmovement
	union all
	select 
	"Nr", "DisplayBusinessStatus", "Error_name", "OperationType_name", "DeadLine", "AssigneeRef", "ReferenceDoc" 
	from skumovement
	union all
	select 
	"Nr", "DisplayBusinessStatus", "Error_name", "OperationType_name", "DeadLine", "AssigneeRef", "ReferenceDoc"
	from countingtask
	) as t
left join employee e on e."uuid" = t."AssigneeRef"
left join expectedreceipt er on er."uuid" = t."ReferenceDoc"
left join shippingorder so on so."uuid" = t."ReferenceDoc"
where er."ERPNr" != '' or so."ERPNr" != ''