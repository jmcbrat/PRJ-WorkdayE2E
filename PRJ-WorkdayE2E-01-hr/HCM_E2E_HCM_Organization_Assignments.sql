/*organization assignments */

SELECT 
/*left(hr_earndist.gl_key,3)
,FMK.*
,hr_emppay.uniqueid
,'    end of test codes'
--531

,*/
trim(hr_empmstr.id) as 'WorkerID'
,'AZ-Org' as 'SourceSystem'
,'' as 'PositionID'
--,hr_emppay.position as 'PositionID'
,'' as 'O-EffectiveDate'
--,ISNULL(dept_codes_list2.Description,hr_empmstr.DEPARTMENT)
,CASE
  WHEN hr_empmstr.DEPARTMENT = 'BOC' THEN 'BOARD OF COMMISSION'
  WHEN hr_empmstr.DEPARTMENT = 'SHF' THEN 'COUNTY SHERIFF'
  WHEN hr_empmstr.DEPARTMENT = 'REG' THEN 'MACOMB COUNTY CLERK'
  WHEN hr_empmstr.DEPARTMENT = 'CLK' THEN 'MACOMB COUNTY CLERK'
  WHEN hr_empmstr.DEPARTMENT = 'TRS' THEN 'MACOMB COUNTY TREASURER'
  WHEN hr_empmstr.DEPARTMENT = 'PRS' THEN 'PROSECUTING ATTORNEY'
  WHEN hr_empmstr.DEPARTMENT = 'PWK' THEN 'PUBLIC WORKS COMMISSIONER'
  WHEN hr_empmstr.DEPARTMENT = 'CIR' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'DC1' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'DC2' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'FOC' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'FCJ' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'PCW' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'PDO' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'CIP' THEN 'COUNTY SHERIFF'
  WHEN hr_empmstr.DEPARTMENT = 'RETG' THEN 'Retirees - General'
  --WHEN hr_empmstr.DEPARTMENT = 'RETirees' THEN 'use sup_orgs'  /*IS THIS REAL*/
  WHEN hr_empmstr.DEPARTMENT = 'RETS' THEN 'RETIREES - Sheriff'
  WHEN hr_empmstr.DEPARTMENT = 'RETR' THEN 'RETIREES - ROADS'
  WHEN hr_empmstr.DEPARTMENT = 'RETM' THEN 'Retirees - Martha T Berry'
  ELSE 'OFFICE OF COUNTY EXECUTIVE'  /* would rather define them than catcha all */
  END -- needs to be CC codes
  as 'CostCenterOrganization'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/)  as 'CompanyOrganization'
,'' as 'RegionOrganization'
,'' as 'BusinessUnit'
,CASE
  WHEN hr_empmstr.ENTITY_ID in ('ROOT','ROAD') THEN DEPT_CODES_LIST2.[Description]
  WHEN hr_empmstr.ENTITY_ID = 'PENS' THEN RDEPT_CODES_LIST2.[Description]
  ELSE ''
  END as 'Department'
,CASE 
  WHEN hr_empmstr.id = 'R006884' THEN 531
  WHEN left(hr_earndist.gl_key,3) = 221 THEN 101
  WHEN left(hr_earndist.gl_key,3) = 274 THEN 232
  ELSE FMK.WORKDAY_value
  END as 'Fund'
,'' as 'CustomOrg2'
,'' as 'CustomOrg3'
,'' as 'CustomOrg4'

from [production_finance].[dbo].[hr_empmstr] 
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	    and hr_emppay.rec_type = 'PM'
		 --and hr_emppay.CALC_END > '12/1/2022'
	    and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
	  left join [production_finance].[dbo].[hr_earndist]
	  on hr_emppay.uniqueid = hr_earndist.uniqueid
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2]
	  on trim(hr_empmstr.DEPARTMENT) = DEPT_CODES_LIST2.DEPTCD
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2] rDEPT_CODES_LIST2
	  on trim(hr_empmstr.HR10) = rDEPT_CODES_LIST2.DEPTCD
	  LEFT JOIN [IT.Macomb_DBA].[dbo].[Fund_Mapping_Key] as FMK
	  on left(hr_earndist.gl_key,3) = FMK.fund_part_1
where --hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
  --and 
  /*hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')*/
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
  /*and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
E021809 - dup
) */
--and FMK.WORKDAY_value is null
--and hr_empmstr.DEPARTMENT is null
order by 1