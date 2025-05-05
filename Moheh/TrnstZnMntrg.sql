select
	cfd."ZoneName"
	, cfd."LocationName"
	, cfd."LocationQuantity"
	, sd."LocationName"
from cellfullnessdatamart cfd
left join stockdatamart sd on cfd."LocationUUID" = sd."LocationParentUUID"
left join zone z on z."uuid" = cfd."ZoneUUID"
where z."ZoneType" = 'Transit'