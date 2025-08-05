select 
	sm."DestinationZone"
	,smd."SKUName"
	,smd."Quantity"
	,smd."PackageQuantity"
from skumovementdatamart smd
left join skumovement sm on sm."uuid" = smd."ObjectId"
where (sm."State" = 'InWork' or sm."State" = 'Recieved')
and sm."OperationType" = '9730f3c7-84ea-4148-8d01-1d6b7bf40001' --полонение объектами хранения
