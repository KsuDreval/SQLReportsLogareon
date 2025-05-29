with 
del_data as(
select
    d."uuid"
    , min(lm."StartingDate") as ld_bgn
    , case
      when d."StateName" = 'Completed' then max(case when lm."CloseDate" = '1970-01-01 00:00:00' then null else lm."CloseDate" end) 
      else null end as ld_end
from delivery d
left join shippingorder so on so."Delivery" = d."uuid"
left join locationmovement lm on lm."ReferenceDoc" = so."uuid"
where lm."StartingDate" != '1970-01-01 00:00:00' and lm."OperationType_name" = 'Отгрузка'
group by d."uuid", d."StateName"
)

, tmpcalcavg as(
select
	avg(dd."ld_bgn" - d."ArrivalTime") as avg_ld_bgn
	, avg(dd."ld_end" - d."ArrivalTime") as avg_ld_end
	, avg(case when d."DepartureTime" = '1970-01-01 00:00:00' then null
	else d."DepartureTime" - d."ArrivalTime" end) as avg_dep
from delivery d
left join del_data dd on dd."uuid" = d."uuid"
where d."ArrivalTime" != '1970-01-01 00:00:00'
)

select
  d."ERPNr"
  , d."ResponsiblePerson_name"
  , case 
    when d."ArrivalTime" = '1970-01-01 00:00:00' then null
    else d."ArrivalTime" end as arrtime
  , dd."ld_bgn"
  , case 
    when d."ArrivalTime" = '1970-01-01 00:00:00' then null
    else d."ArrivalTime" end + (select avg_ld_bgn from tmpcalcavg) as exp_ld_bgn
  , dd."ld_end"
  , case 
    when d."ArrivalTime" = '1970-01-01 00:00:00' then null
    else d."ArrivalTime" end + (select avg_ld_end from tmpcalcavg) as exp_ld_end
  , case 
    when d."DepartureTime" = '1970-01-01 00:00:00' then null
    else d."DepartureTime" end as deptime
  , case 
    when d."ArrivalTime" = '1970-01-01 00:00:00' then null
    else d."ArrivalTime" end + (select avg_dep from tmpcalcavg) as exp_dep
from delivery d
left join del_data dd on dd."uuid" = d."uuid"
where d."DeliveryDocumentType" = 'Loading'