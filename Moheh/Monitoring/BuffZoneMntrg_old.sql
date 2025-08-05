select
	cfd."ZoneName"
	, cfd."LocationName"
	, case when  sd."Name" is null then 0
    else 1 end as quantity
	, sd."Name" as mh
from cellfullnessdatamart cfd
left join location sd on cfd."LocationUUID" = sd."ParentID"
where 
cfd."ZoneUUID" = '67ce5af3-4cc2-4182-9fba-ca73aba4a7e1' --Буфер Зоны Экспедиции (Филиалы)
or cfd."ZoneUUID" = 'baee2971-2e0b-4a46-95c4-c4ffef416844' --Буфер Зоны Экспедиции (Регионы)
or cfd."ZoneUUID" = 'ba79e9f5-d240-4602-8ed1-fa7614410231' --Буфер Зоны Экспедиции (РФ)
or cfd."ZoneUUID" = '63899d4f-c723-4e29-9625-a6316912a27f' --Буферная зона
or cfd."ZoneUUID" = 'cb3eb69d-dfa4-4682-9835-35964962642f' --Буферная зона (глушители)
