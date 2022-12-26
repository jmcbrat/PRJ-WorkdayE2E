/*worker addresses*/

select 
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'AddressEffectiveDate'
,'Y' as 'Primary' -- where is the field and the work address
,'Home' as 'UsageType' -- where is this???
,'N' as 'Public' -- where is this???
,trim(hr_empmstr.country) as 'CountryISOCode'
-- E2E990, E2E991, E2E993 Start
--c&p 
, CASE 
    WHEN hr_empmstr.st_2 is null THEN trim(hr_empmstr.st_1)
	WHEN hr_empmstr.st_1 is null THEN trim(hr_empmstr.st_2)
	WHEN hr_empmstr.st_1 is NOT null and hr_empmstr.st_2 is NOT null  THEN CONCAT (trim(hr_empmstr.st_1),', ',trim(hr_empmstr.st_2))
	ELSE hr_empmstr.st_2
	END as 'AddressLine_1'
--,IIF(hr_empmstr.st_2 is null, trim(hr_empmstr.st_1),CONCAT (trim(hr_empmstr.st_1),', ',trim(hr_empmstr.st_2))) as 'AddressLine_1'
--,trim(hr_empmstr.st_1) as 'AddressLine#1'
,CASE
   WHEN hr_empmstr.st_1 is null AND hr_empmstr.st_2 is NOT null THEN ''
   WHEN hr_empmstr.st_1 is NOT null and hr_empmstr.st_2 is NOT null THEN ''
   WHEN hr_empmstr.st_2 is NOT null THEN hr_empmstr.st_2 
   --trim(hr_empmstr.st_2) 
   END as 'AddressLine#2'
--END E2E990, E2E991, E2E993
,trim(hr_empmstr.city) as 'City'
,IIF(hr_empmstr.id ='R001197' --Panama Res.
	,'PAN-10'
	,trim(hr_empmstr.country) + '-' + trim(hr_empmstr.state)) as 'Region'
,trim(hr_empmstr.zip) as 'PostalCode'
,'' as 'UseForReference1'
,'' as 'UseForReference2'
,IIF(hr_empmstr.id = 'E022064','Y','') as 'Work_From_home_address'

from [production_finance].[dbo].[hr_empmstr]
where /*hr_empmstr.ENTITY_ID in ('ROOT','ROAD','PENS')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))*/
((hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD','PENS'))
 OR
  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT')
  and hr_empmstr.termcode in ('DFRT','DFRC')
  )
 OR 
  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT')
  and hr_empmstr.enddt = '12/31/2014'
  and hr_empmstr.department = 'MTB'
  )
   OR (hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD','PENS')
	 and hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'
 )
  )
  AND hr_empmstr.CITY is not null -- E2E990, E2E991, E2E993

/*hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) */
/*AND hr_empmstr.id in (
'R001197'
)--*/
order by 1
