do $$
declare
  c_cursor cursor for select * from dblink(
  'dbname=DatamartBackup3 user=postgres password=N1cJf4Bh',
  'select *
  from commodity
  order by id asc') 
  as tmp_table(
  id bigint, 
    uuid character varying(40) ,
    parentuuid character varying(40),
    version integer,
    "timestamp" timestamp(3) without time zone,
    "Batch" text,
    "BypassValidation" bit,
    "ChangedProperties" text,
    "IsEmpty" bit,
    "IsModified" bit,
    "Package" text,
    "Package_name" text,
    "PackageConfig" text,
    "PackageConfig_name" text,
    "RemovedProperties" text,
    "SessionId" text,
    "SKU" text,
    "SKU_name" text,
    "SKUStatus" text,
    "SKUStatus_name" text,
    __removed bit,
  "Domain" character varying(40)
    );
  c_row commodity_tmp%rowtype;
begin
  open c_cursor;
  loop
    fetch c_cursor into c_row;
    exit when not found;
    insert into commodity_tmp values (default,
    c_row.uuid,
    c_row.parentuuid,
    c_row.version,
    c_row."timestamp",
    c_row."Batch",
    c_row."BypassValidation",
    c_row."ChangedProperties",
    c_row."IsEmpty",
    c_row."IsModified",
    c_row."Package",
    c_row."Package_name",
    c_row."PackageConfig",
    c_row."PackageConfig_name",
    c_row."RemovedProperties",
    c_row."SessionId",
    c_row."SKU",
    c_row."SKU_name",
    c_row."SKUStatus",
    c_row."SKUStatus_name",
    c_row.__removed,
    c_row."Domain");
  end loop;
  close c_cursor;
end$$;
