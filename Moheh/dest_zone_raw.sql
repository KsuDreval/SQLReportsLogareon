--количество ОХ по каждой зоне
with sku_count as
(
	select
		sd."ZoneUUID"
		, sd."SKUUUID"
		, sum(sd."Quantity") as skuquantity
	from stockdatamart sd
	where sd."ZoneName" != 'МХ без зоны' and sd."SKUName" != 'Предопределенный ОХ'
	group by(sd."ZoneUUID", sd."SKUUUID")
)

select
	sz."Zone_name"
	, sz."SKU_name"
	, case when sc."skuquantity" > sz."QuantityMax" or sc."skuquantity" < sz."QuantityMax" then 0 else 1 end
	
from skuzone sz
left join sku_count sc on sc."ZoneUUID" = sz."Zone"
where sc."SKUUUID" = sz."SKU"
