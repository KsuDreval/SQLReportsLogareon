with 
del_data as(
select
		d."uuid"
		-- начало выгрузки - первая операция предв. приемки или приемки ГМ
		, min(lm."StartingDate") as unl_bgn 
		-- конец выгрузки - последняя операция предв. приемки или приемки ГМ
		, case
			when d."StateName" = 'Completed' then max(lm."CloseDate") 
			else null end as unl_end
		-- ожидаемая дата прибытия - наименьшяя дата поступления у ОП в составе рейса
		, min(er."IncomeDate") as exp_arrvl
	from delivery d
	left join expectedreceipt er on d."uuid" = er."Delivery"
	left join 
		(select "StartingDate", "CloseDate", "ReferenceDoc"
		from locationmovement 
		where "StartingDate" != '1970-01-01 00:00:00' and "CloseDate" != '1970-01-01 00:00:00'
		and ("OperationType_name" = 'Предварительная приемка' or "OperationType_name" = 'Приемка грузовых мест')
		union all 
		select "StartingDate", "CloseDate", "ReferenceDoc"
		from countingtask 
		where "StartingDate" != '1970-01-01 00:00:00' and "CloseDate" != '1970-01-01 00:00:00'
		and "OperationType_name" = 'Приемка (пересчет)')
	as lm on lm."ReferenceDoc" = er."uuid"
	--and d."StateName" = 'Completed'
	group by d."uuid", d."StateName"
)

, tmpcalcarr as(
select
	-- среднее время между прибытием на склад и началом выгрузки
	avg(dd."unl_bgn" - d."ArrivalTime") as avg_unl_bgn
	-- среднее время между прибытием на склад и окончанием выгрузки
	, avg(dd."unl_end" - d."ArrivalTime") as avg_unl_end
	-- среднее время между прибытием на склад и убтием со склада
	, avg(d."DepartureTime" - d."ArrivalTime") as avg_dep
from delivery d
left join del_data dd on dd."uuid" = d."uuid"
where d."ArrivalTime" != '1970-01-01 00:00:00' 
)

, tmpcalcdep as(
select
	avg(d."DepartureTime" - d."ArrivalTime") as avg_dep
from delivery d
where d."ArrivalTime" != '1970-01-01 00:00:00' and d."DepartureTime" != '1970-01-01 00:00:00'
)

select
	d."ERPNr"
	, d."ResponsiblePerson_name"
	, case 
		when d."ArrivalTime" = '1970-01-01 00:00:00' then null
		else d."ArrivalTime" end as arrtime
	, dd."exp_arrvl"
	, dd."unl_bgn"
	, case 
		when d."ArrivalTime" = '1970-01-01 00:00:00' then dd."exp_arrvl"
		else d."ArrivalTime" end + (select avg_unl_bgn from tmpcalcarr) as exp_unl_bgn
	, dd."unl_end"
	, case 
		when d."ArrivalTime" = '1970-01-01 00:00:00' then dd."exp_arrvl"
		else d."ArrivalTime" end + (select avg_unl_end from tmpcalcarr) as exp_unl_end
	, case 
		when d."DepartureTime" = '1970-01-01 00:00:00' then null
		else d."DepartureTime" end as deptime
	, case 
		when d."ArrivalTime" = '1970-01-01 00:00:00' then dd."exp_arrvl"
		else d."ArrivalTime" end + (select avg_dep from tmpcalcdep) as exp_dep
from delivery d
left join del_data dd on dd."uuid" = d."uuid"