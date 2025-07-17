	INSERT INTO commodity (
	"uuid",
    "parentuuid",
    "version",
    "timestamp",
    "Batch",
    "BypassValidation",
    "ChangedProperties",
    "IsEmpty",
    "IsModified",
    "Package",
    "Package_name",
    "PackageConfig",
    "PackageConfig_name",
    "RemovedProperties",
    "SessionId",
    "SKU",
    "SKU_name",
    "SKUStatus",
    "SKUStatus_name",
    "__removed",
    "Domain"
)
SELECT 
	"uuid",
    "parentuuid",
    "version",
    "timestamp",
    "Batch",
    "BypassValidation",
    "ChangedProperties",
    "IsEmpty",
    "IsModified",
    "Package",
    "Package_name",
    "PackageConfig",
    "PackageConfig_name",
    "RemovedProperties",
    "SessionId",
    "SKU",
    "SKU_name",
    "SKUStatus",
    "SKUStatus_name",
    "__removed",
    "Domain" 
FROM commodity_new
WHERE NOT EXISTS (
    SELECT 1 FROM commodity 
    WHERE 
		commodity."uuid" = commodity_new."uuid"
    and commodity."parentuuid" = commodity_new."parentuuid"
    and commodity."version" = commodity_new."version"
    and commodity."timestamp" = commodity_new."timestamp"
    and commodity."Batch" = commodity_new."Batch"
    and commodity."BypassValidation" = commodity_new."BypassValidation"
    and commodity."ChangedProperties" = commodity_new."ChangedProperties"
    and commodity."IsEmpty" = commodity_new."IsEmpty"
    and commodity."IsModified" = commodity_new."IsModified"
    and commodity."Package" = commodity_new."Package"
    and commodity."Package_name" = commodity_new."Package_name"
    and commodity."PackageConfig" = commodity_new."PackageConfig"
    and commodity."PackageConfig_name" = commodity_new."PackageConfig_name"
    and commodity."RemovedProperties" = commodity_new."RemovedProperties"
    and commodity."SessionId" = commodity_new."SessionId"
    and commodity."SKU" = commodity_new."SKU"
    and commodity."SKU_name" = commodity_new."SKU_name"
    and commodity."SKUStatus" = commodity_new."SKUStatus"
    and commodity."SKUStatus_name" = commodity_new."SKUStatus_name"
    and commodity."__removed" = commodity_new."__removed"
    and commodity."Domain" = commodity_new."Domain"
);