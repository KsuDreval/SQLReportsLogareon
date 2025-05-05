select
	so."Number"
	, max(lm."DeadLine")
from shippingorder so
left join locationmovement lm on lm."ReferenceDoc" = so."uuid"
where so."Delivery" = '' and so."State" = 'ReadyForShipment'
group by so."Number"