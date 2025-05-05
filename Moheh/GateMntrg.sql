select
	cfd."LocationName"
	, sd."LocationName" as mh
from cellfullnessdatamart cfd
left join stockdatamart sd on sd."LocationParentUUID" = cfd."LocationUUID"
where
cfd."LocationUUID" = '94475756-8696-4c28-a7a6-95f316b7a2f0' --Ворота отгрузки №1
or cfd."LocationUUID" = '73ce2b4e-e5a4-4062-8893-9a74ddaa6f4c' --Ворота отгрузки №2
or cfd."LocationUUID" = '03b247d4-b859-4063-a6cd-60ef5fea7069' --Ворота отгрузки №3
or cfd."LocationUUID" = '35d48647-b4cf-4bbf-8ffa-0c6ea2141619' --Ворота отгрузки №4
or cfd."LocationUUID" = '1192aa5c-0034-40a6-8cf0-f863ad8532cf' --Ворота отгрузки №5
or cfd."LocationUUID" = '2618f259-4f47-4a6a-a68b-bf3ded1ac1ee' --Ворота отгрузки №6
or cfd."LocationUUID" = '5f58d575-6835-4305-b162-772a2655fd97' --Ворота отгрузки №7
or cfd."LocationUUID" = 'a516194c-4d6d-40d6-acd9-6e83501d13db' --Ворота приемки №1
or cfd."LocationUUID" = '5dec28ef-f307-4483-884a-4fd8693cca6d' --Ворота приемки №2
or cfd."LocationUUID" = 'f8225121-e7e4-4e55-b8cb-6d3be4a44ff2' --Ворота приемки №3
or cfd."LocationUUID" = '5b649ac2-dcfd-40ca-a214-6b42f44fab72' --Ворота приемки №4
or cfd."LocationUUID" = '3d47b1fb-5190-447d-8746-8fbfa09eaf30' --Ворота приемки №5
or cfd."LocationUUID" = '0aad9ca6-fa35-4bba-b3ec-6bc4a620bb55' --Ворота приемки №6
or cfd."LocationUUID" = '68b7b97a-64a2-4cde-b014-77f27bd120f8' --Ворота приемки №7
