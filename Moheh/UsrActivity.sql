select
to_char("Date", 'DD-MM-YYYY') as date1
, e."Name"
, "Queue"
, count(*)
from
	(select lm."Date", lm."AssigneeRef", lmd."Queue", lm."StateName" 
	from locationmovement lm
	left join locationmovementdatamart lmd on lmd."ObjectId" = lm."uuid"
	where lm."StateName" = 'Completed'
	union all
	select sm."Date", sm."AssigneeRef", smd."Queue", sm."StateName" 
	from skumovement sm
	left join skumovementdatamart smd on smd."ObjectId" = sm."uuid"
	where sm."StateName" = 'Completed'
	union all
	select ct."Date", ct."AssigneeRef", ctd."Queue", ct."StateName" 
	from countingtask ct
	left join countingdatamart ctd on ctd."ObjectId" = ct."uuid"
	where ct."StateName" = 'Completed') as tasks
left join employee e on e."uuid" = "AssigneeRef"
group by date1, e."Name", "Queue"