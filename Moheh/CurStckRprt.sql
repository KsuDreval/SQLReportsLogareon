select
sd."SKUName"
, sd."SKUArticle"
, sd."StatusName"
, sd."BatchName"
, b."Number"
, to_char(b."ManufactureDate", 'DD-MM-YY') as proizv
, to_char(b."BestBefore", 'DD-MM-YY') as sg
, sd."Quantity"
, sd."Quantity" / p."pckg" as pckgq
, case
  when sd."LocationParentName" = '' then sd."LocationName"
  else sd."LocationParentName" end as yach
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
where sd."SKUArticle" != 'PredefinedSKU'
