--таблица содержит в себе uuid зоны и количество мх, которые должны из нее уйти
with task_count as
(
	select
		lm."SourceZone"
		, count(distinct lm."uuid") as plan
	from locationmovement lm
	left join skumovement sm on sm."LocationMovementTask" = lm."uuid"
	where (
		lm."DisplayBusinessStatus" = 'New'
		or lm."DisplayBusinessStatus" = 'Planned'
		or lm."DisplayBusinessStatus" = 'Activated'
		or lm."DisplayBusinessStatus" = 'Spreading'
	) and (
		sm."DisplayBusinessStatus" = 'New'
		or sm."DisplayBusinessStatus" = 'Planned'
		or sm."DisplayBusinessStatus" = 'Activated'
		or sm."DisplayBusinessStatus" is null
	)
	group by(lm."SourceZone", lm."SourceZone_name") 
)

--основной запрос, показывает транзитную зону, сколько в ней всего МХ, сколько МХ зарезервированно и сколько МХ свободны
select
	l."Zone_name"
	, count(l."uuid")
	, case
		when tc."plan" is null then 0
		else tc."plan"
	end as reserved
	, count(l."uuid") - case when tc."plan" is null then 0 else tc."plan" end as accessible
from location l
left join task_count tc on tc."SourceZone" = l."Zone"
left join zone z on z."uuid" = l."Zone"
where l."LocationClass" = '6d0b855e-943f-4327-9ee9-b01dd98d0001'
and z."ZoneType" = 'Transit'
group by (l."Zone_name", tc."plan")
