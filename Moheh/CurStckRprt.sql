select
sd."SKUName"
, sd."SKUArticle"
, sd."StatusName"
, sd."BatchName"
, b."Number"
, date(b."ManufactureDate") as proizv
, date(b."BestBefore") as sg
, sd."Quantity"
, sd."Quantity" / p."pckg"
, sd."LocationParentName"
, sd."LocationName"
, sd."ZoneName"
from stockdatamart sd
left join batch b on b."uuid" = sd."BatchUUID"
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