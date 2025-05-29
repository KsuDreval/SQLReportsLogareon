with
so_data as
(select
	so."uuid"
	, so."ShippingDate"
	, min(case when lm."StartingDate" = '1970-01-01 00:00:00' then null else lm."StartingDate" end) as bgn_time
	, max(case when (so."State" = 'Shipped') and lm."CloseDate" != '1970-01-01 00:00:00' then lm."CloseDate" else null end) as end_time
from locationmovement lm
left join shippingorder so on so."uuid" = lm."ReferenceDoc"
where lm."OperationType_name" = 'Отгрузка'
group by so."uuid", so."ShippingDate")

, tmp_calc_avg as
(select
	avg("end_time" - "ShippingDate") as avg_end_time
from so_data)

select
	--"uuid"
	"bgn_time"
	, "end_time"
	, "ShippingDate" + (select "avg_end_time" from tmp_calc_avg) as exp_end_time
from so_data
where so."uuid" = @UUIDS