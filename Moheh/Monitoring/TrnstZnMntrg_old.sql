select
	cfd."ZoneName"
	, cfd."LocationName"
	, case when  sd."Name" is null then 0
    else 1 end as quantity
	, sd."Name" as mh
from cellfullnessdatamart cfd
left join location sd on cfd."LocationUUID" = sd."ParentID"
left join zone z on z."uuid" = cfd."ZoneUUID"
where z."ZoneType" = 'Transit'
