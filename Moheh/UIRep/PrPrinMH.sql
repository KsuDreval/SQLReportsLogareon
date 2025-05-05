select
lmjd."LocationName"
, lmjd."SourceLocationName"
, l."LocationType_name"
from locationmovementjournaldatamart lmjd
left join location l on l."uuid" = lmjd."LocationUUID"
left join locationmovement lm on lm."uuid" = lmjd."InitiatorTaskUUID"
where (lmjd."OperationType" = 'Предварительная приемка' or lmjd."OperationType" = 'Приемка грузовых мест')
and lmjd."AssigneeName" != lmjd."SourceLocationName"
and lm."ReferenceDoc" = @UUIDS
