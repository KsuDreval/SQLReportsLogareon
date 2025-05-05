select
	cfd."ZoneName"
	, cfd."LocationName"
	, cfd."SKUQuantity"
	, cfd."SKUQuantity" / p."pckg" as ypakovka
from cellfullnessdatamart cfd
left join stockdatamart sd on cfd."LocationUUID" = sd."LocationParentUUID"
left join (select 
	"SKU",
	CASE
	WHEN COUNT(CASE WHEN "Ratio" != 1 THEN 1 END) > 0 
	THEN  MAX(CASE WHEN "Ratio" != 1 THEN CAST("Ratio" AS float) END)
	ELSE
	1
	END AS pckg
from package p
group by "SKU") as p on p."SKU" = sd."SKUUUID"
left join zone z on z."uuid" = cfd."ZoneUUID"
where z."ZoneType" = 'Storage'
