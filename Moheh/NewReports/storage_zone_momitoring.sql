with 
--таблица содержащая все ОХ с их весом и объемом
sku_lwh as
(
	select
		sku."uuid"
		, sku."Name"
		, p."Weight"/1000 as weight
		, p."Depth"*p."Height"*p."Length"/1000000 as volume
	from sku
	left join package p on p."SKU" = sku."uuid"
	where p."ProcessingMultiplicity" = 'Unit'
),
--таблица, отображающая заполненность всех паллет, расположенных в ячейках
pallets_utilization as
(
	select
		sd."LocationUUID"
		, sd."LocationParentUUID"
		, sum(sl.weight*sd."Quantity") as allweight
		, sum(sl.volume*sd."Quantity") as allvolume
	from stockdatamart sd
	left join sku_lwh sl on sl."uuid" = sd."SKUUUID"
	left join zone z on sd."ZoneUUID" = z."uuid"
	where sd."SKUName" != 'Предопределенный ОХ' and sd."LocationParentUUID" != '' and z."ZoneType" = 'Storage'
	group by(sd."LocationParentUUID", sd."LocationUUID")
),
--таблица, отображающая заполненность всех ячеек (без учета паллет в них)
cells_utilization as
(
	select
		sd."LocationUUID"
		, sum(sl.weight*sd."Quantity") as allweight
		, sum(sl.volume*sd."Quantity") as allvolume
	from stockdatamart sd
	left join sku_lwh sl on sl."uuid" = sd."SKUUUID"
	left join zone z on sd."ZoneUUID" = z."uuid"
	where sd."SKUName" != 'Предопределенный ОХ' and sd."LocationParentUUID" = '' and sd."ZoneName" != 'МХ без зоны' and z."ZoneType" = 'Storage'
	group by(sd."LocationUUID")
),
--таблица, содержащая в себе объем и вес фактитеский и максимально возможный по всем зонам
zone_stats as
(
	select
		l."Zone_name"
		, l."Zone"
		, sum (case
			when (pu."LocationUUID" is null) then cu."allvolume"
			else pu."allvolume"
		end) as zone_volume
		, sum(lt."Depth"*lt."Height"*lt."Length"/1000000) as zone_max_volume
		, sum(case
			when (pu."LocationUUID" is null) then cu."allweight"
			else pu."allweight"
		end) as zone_weight
		, sum(lt."AbsCapacity"/1000) as zone_max_weight
	from location l
	left join pallets_utilization pu on pu."LocationParentUUID" = l."uuid"
	left join cells_utilization cu on cu."LocationUUID" = l."uuid"
	left join locationtype lt on lt."uuid" = l."LocationType"
	where l."Removed" = '0'
	group by (l."Zone_name", l."Zone")
)

select
	zs."Zone_name"
	, case 
		when zs.zone_volume is null then 0
		else zs.zone_volume
	end as zone_volume
	, zs.zone_max_volume
	, case 
		when (zs.zone_max_volume = 0 or zs.zone_volume is null) then 0
		else zs.zone_volume/zs.zone_max_volume*100
	end as volume_coefficient
	, case 
		when zs.zone_weight is null then 0
		else zs.zone_weight
	end as zone_weight
	, zs.zone_max_weight
	, case 
		when (zs.zone_max_weight = 0 or zs.zone_weight is null) then 0
		else zs.zone_weight/zs.zone_max_weight*100
	end as weight_coefficient
from zone_stats zs
left join zone z on zs."Zone" = z."uuid"
where z."ZoneType" = 'Storage'
