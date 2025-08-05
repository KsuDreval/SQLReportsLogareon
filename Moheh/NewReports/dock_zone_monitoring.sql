--запрос показывает транзитную зону, сколько в ней всего может быть МХ, сколько МХ зарезервированно и сколько МХ свободны
select
	l."Zone_name"
    --строку с count убрать и заменить на строку с вместимостью ячейки, когда будет создана витрина по задаче
	, count(l."uuid")
	, count(case when l."State" = 'Reserved' then 1 end) as reserved
	, count(l."uuid") - count(case when l."State" = 'Reserved' then 1 end) as accessible
from location l
where l."LocationClass" = '6d0b855e-943f-4327-9ee9-b01dd98d0001'
and (
	l."Zone" = 'ba79e9f5-d240-4602-8ed1-fa7614410231' --Буфер Зоны Экспедиции (РФ)
	or l."Zone" = 'baee2971-2e0b-4a46-95c4-c4ffef416844' --Буфер Зоны Экспедиции (Регионы)
	or l."Zone" = '67ce5af3-4cc2-4182-9fba-ca73aba4a7e1' --Буфер Зоны Экспедиции (Филиалы)
	or l."Zone" = '63899d4f-c723-4e29-9625-a6316912a27f' --Буферная зона
	or l."Zone" = 'cb3eb69d-dfa4-4682-9835-35964962642f' --Буферная зона (глушители)
	or l."Zone" = '538025ed-8457-482b-8040-abb0386bfe1c' --Зона Экспедиции (Филиалы) Буферная
)
group by (l."Zone_name")
