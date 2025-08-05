select
	cfd."ZoneName"
	, cfd."LocationName"
	, cfd."LocationQuantity"
	, case 
		when sd."Quantity" is null then 0 
		else sd."Quantity" 
		end as qnt
	, case 
		when sd."Quantity" is null then 0 
		else sd."Quantity" / p."pckg"
		end AS pckgq
from cellfullnessdatamart cfd
left join (select 
	"Quantity"
	, case
  		when sd."LocationParentUUID" = '' then sd."LocationUUID"
  		else sd."LocationParentUUID" end as yach
	, "SKUUUID"
from stockdatamart sd) as sd on cfd."LocationUUID" = sd."yach"
left join (select 
	"SKU",
	CASE
	WHEN COUNT(CASE WHEN "Ratio" != 1 THEN 1 END) > 0 
	THEN  MAX(CASE WHEN "Ratio" != 1 THEN "Ratio" END)
	ELSE
	1
	END AS pckg
from package p
group by "SKU") as p on sd."SKUUUID" = p."SKU"
left join zone z on z."uuid" = cfd."ZoneUUID"
where z."ZoneType" = 'Storage' 
