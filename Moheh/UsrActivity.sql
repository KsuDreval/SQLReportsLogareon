select
"Date"::date as date1
, e."Name"
, "Queue"
, count(*)
from
	(select lm."Date", lm."AssigneeRef", lmd."Queue" 
	from locationmovement lm
	left join locationmovementdatamart lmd on lmd."ObjectId" = lm."uuid"
	where lm."StateName" = 'Completed'
	union all
	select sm."Date", sm."AssigneeRef", smd."Queue" 
	from skumovement sm
	left join skumovementdatamart smd on smd."ObjectId" = sm."uuid"
	where sm."StateName" = 'Completed'
	union all
	select ct."Date", ct."AssigneeRef", ctd."Queue" 
	from countingtask ct
	left join countingdatamart ctd on ctd."ObjectId" = ct."uuid"
	where ct."StateName" = 'Completed') as tasks
left join employee e on e."uuid" = "AssigneeRef"
where e."Name" != 'System'
group by date1, e."Name", "Queue"
order by date1 desc
