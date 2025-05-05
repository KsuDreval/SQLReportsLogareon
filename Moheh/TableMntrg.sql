select
	cfd."ZoneName"
	, cfd."LocationName"
	, cfd."LocationQuantity"
	, '4' as vmest
from cellfullnessdatamart cfd
where 
cfd."ZoneUUID" = '479c3ef1-120a-448d-a809-cbe0d52535e5' --Сортировка 2 эт.
or cfd."ZoneUUID" = 'f7b1b04e-a804-46f3-949e-3ea1bbc455fc' --Сортировка 4 эт.
or cfd."ZoneUUID" = '4d37836d-5ef8-460a-bb22-0b4da9e60e1e' --Сортировка КД
or cfd."ZoneUUID" = '1ff155f2-f8dd-4d54-ae8b-14b1a0342e14' --Сортировка 5 эт.
or cfd."ZoneUUID" = '698d2f6d-8aa3-4be6-927a-33c563b8bab6' --Сортировка 1 эт.
or cfd."ZoneUUID" = '4a5171da-add5-4d76-92b6-fbb1f6e4cf64' --Зона приемки миксов
or cfd."ZoneUUID" = 'db88a0b7-7927-4a34-bb1e-9cccad34b792' --Зона приемки монопаллет
or cfd."ZoneUUID" = 'fa95bd9d-e20d-4a42-9dc4-786eaab49955' --Зона фасовки (1 этаж)
or cfd."ZoneUUID" = '249a49ad-acde-4edf-a77c-9973773615ed' --Зона фасовки (5 этаж)