select
e."Name"
-- если у пользователя есть хотя бы 1 задача в работе -> статус недоступен
,case
	when count(case when tasks."StateName" = 'InWork' or tasks."StateName" = 'Recieved'then 1 end) > 0  then 'Недоступен'
	else 'Доступен'
	end as usrdost
from employee e
left join (select lm."AssigneeRef", lm."StateName" 
	from locationmovement lm
	where date("Date") = date(current_date)
	union all
	select sm."AssigneeRef", sm."StateName" 
	from skumovement sm
	where date("Date") = date(current_date)
	union all
	select ct."AssigneeRef", ct."StateName" 
	from countingtask ct
	where date("Date") = date(current_date)) as tasks 
on tasks."AssigneeRef" = e."uuid"
group by e."Name"
