/*HCM_BENEFITS_Additional_Benefits_Election*/

SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Jen Smiley' as 'SourceSystem'
,IIF(hr_cdhassgn.beg < convert(date,'1/1/2022')
   ,replace(convert(date,convert(date,'1/1/2022'),106),' ','-')
	,replace(convert(date,hr_cdhassgn.beg,106),' ','-')) as 'EventDate'
,'Conversion_Additional_Benefits' as 'BenefitEventType'
/*,Look at hr_cdhassgn.no (which is the cdh code which corresponds to the benefit and use that as the look up value for look up key below for plan name)*/
,CASE
  WHEN hr_cdhassgn.no = '2465' THEN 'PetInsurance'
  WHEN hr_cdhassgn.no = '2419' THEN 'Legal Shield'
  WHEN hr_cdhassgn.no = '2417' THEN 'ID Shield'						--koahills: CNP549
  WHEN hr_cdhassgn.no = '2418' THEN 'Legal and ID Shield Combined'	--koahills: CNP549
  ELSE ''
  END as 'AdditionalBenefitsPlan'
,'' as 'AdditionalBenefitsCoverageTarget'
,replace(convert(date,hr_cdhassgn.beg,106),' ','-') as 'OriginalCoverageBeginDate'
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [production_finance].[dbo].hr_cdhassgn ON hr_empmstr.id = hr_cdhassgn.id
	  AND hr_cdhassgn.no in ('2419','2417','2418')
WHERE hr_empmstr.Entity_id in ('ROOT','ROAD') -- Removed PENS and ZINS  Solves E2E940
AND hr_empmstr.hr_status = 'A'
ORDER BY 1