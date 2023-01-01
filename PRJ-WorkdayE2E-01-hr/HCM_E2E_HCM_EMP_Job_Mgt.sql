/*HR_EMP-JobMgt*/

-- begin
SELECT
/*IIF(
   IIF( hr_empmstr.beg<hr_empmstr.hdt
  ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) > IIF(hr_empmstr.beg>hr_empmstr.possenr
      ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
	  ,replace(convert(varchar,ISNULL(hr_empmstr.possenr,hr_empmstr.beg),106),' ','-')
	) 
  ,1,IIF(
   IIF( hr_empmstr.beg<hr_empmstr.hdt
  ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) < IIF(hr_empmstr.beg>hr_empmstr.possenr
      ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
	  ,replace(convert(varchar,ISNULL(hr_empmstr.possenr,hr_empmstr.beg),106),' ','-')
	) 
   ,2,0
  )
)
,
hr_empmstr.possenr,hr_empmstr.beg
,*/
/*hr_emppay.indx_key,
hr_empmstr.hr_status,
hr_empmstr.ENTITY_ID,
hr_empmstr.enddt,
hr_empmstr.termcode,
*/

trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'RETIREE'
  WHEN hr_empmstr.type = 'RETS' THEN 'BENEFICIARY'
  WHEN hr_empmstr.type = 'RETM' THEN 'RETM'
  WHEN hr_empmstr.type = 'RETG' THEN 'RETG'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'EO' THEN 'Regular'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Regular'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Temporary'
  WHEN hr_empmstr.type = 'SUMR' THEN 'JTP Senior'
  ELSE ''
  END as 'EmployeeType'
,'Hire_Employee_Hire_Employee_Conversion' as 'HireReason'
,'' as 'FirstDayofWork'
,IIF( hr_empmstr.beg<hr_empmstr.hdt
  ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'HireDate'
,'' as 'ProbationStartDate'
,'' as 'ProbationEndDate'
,'' as 'EndEmploymentDate'
,IIF(hr_empmstr.beg>hr_empmstr.possenr
      ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
	  ,replace(convert(varchar,ISNULL(hr_empmstr.possenr,hr_empmstr.beg),106),' ','-')
	)  as 'PositionStartDateforConversion'  -- Solves E2E944 
,CASE
  WHEN hr_empmstr.entity_id in ('ROOT','ROAD') THEN 'Sup_Terminated Workers'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETG' THEN 'Sup_Retiree General'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETM' THEN 'Sup_Retiree MTB'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETS' THEN 'Sup_Retiree Sheriff'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETR' THEN 'Sup_Retiree Roads'
ELSE ''
END as 'SupervisoryOrganizationID'
,CASE /*need to upda this with new died, paid, termed and deferd*/
  WHEN hr_empmstr.entity_id in ('PENS') THEN '90000'
  WHEN isnull(substring(hr_emppay.indx_key,4,3),716)='004' THEN '05E'
  WHEN isnull(substring(hr_emppay.indx_key,4,3),716)='011' THEN '42B'
  WHEN isnull(substring(hr_emppay.indx_key,4,3),716)='007' THEN '62B'
  ELSE isnull(substring(hr_emppay.indx_key,4,3),716)
  END as 'JobCode'
,isnull((select TOP 1 trim(hr_pcntble.long_desc) 
  FROM [production_finance].[dbo].hr_pcntble 
  WHERE substring(hr_emppay.indx_key,4,3)+left(hr_emppay.indx_key,2) = hr_pcntble.jobcode ),'Terminated worker no job code')
 as 'PositionTitle'
,'' as 'BusinessTitle'
,CASE
  WHEN hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN hr_empmstr.department in('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN hr_empmstr.department in('SHF','COR') THEN 'LOC014' /*Solves E2E956*/
  WHEN hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN hr_empmstr.department IN ('CIR','PMC','PCW','RMB','CLK') THEN 'LOC019'
  WHEN hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB','MTB','PLN','PRS','RSK','TRS') THEN 'LOC023'
  WHEN hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN hr_empmstr.department IN ('MIS','ROAD','ESC') THEN 'LOC035' /*Solves E2E956*/
  WHEN hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  WHEN hr_empmstr.department IN ('HTH') THEN 'LOC028' /*Solves E2E956*/
  ELSE hr_empmstr.department
END as 'WorkLocation'
,'' as 'WorkSpace'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  isnull(hr_emppay.[actl_hrs],0)*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 WHEN hr_empmstr.entity_id = 'PENS' THEN  0
 ELSE 0
 END  as 'DefaultWeeklyHours' -- Solves E2E949
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  isnull(hr_emppay.[actl_hrs],0)*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 WHEN hr_empmstr.entity_id = 'PENS' THEN  0
 ELSE 0
 END  as 'ScheduledWeeklyHours' --Solves E2E952
,'' as 'PaidFTE'
,'' as 'WorkingFTE'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETS' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETM' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETG' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'EO' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'SUMR' THEN 'Part_Time'
  ELSE ''
 END  as 'TimeType'
,CASE
  WHEN hr_empmstr.Entity_id = 'ROADS' THEN 'Salary'
  WHEN hr_emppay.re_calc='A' THEN 'Salary'
  WHEN hr_emppay.re_calc='H' THEN 'Hourly'
  WHEN hr_empmstr.Entity_id = 'PENS' THEN 'Salary' /*Solves E2E955*/
  ELSE 'hourly'
  END as 'PayRateType'
,'' as 'CompanyInsiderType'
,'' as 'WorkShift'
,'' as 'AdditionalJobClassification#1'
,'' as 'AdditionalJobClassification#2'
,'' as 'AdditionalJobClassification#3'
,'' as 'AdditionalJobClassification#4'

from [production_finance].[dbo].[hr_empmstr]
     left join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
	  --left join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  --on hr_empmstr.id = EMP_Position_Mgt.emp_id 
where 
 ((hr_empmstr.hr_status = 'A' and hr_empmstr.ENTITY_ID in ('PENS'))
 OR
  (hr_empmstr.hr_status = 'I' and hr_empmstr.ENTITY_ID in ('ROOT','ROAD') and hr_empmstr.termcode in ('DFRT','DFRC')
  )
 OR 
  (hr_empmstr.hr_status = 'I' and hr_empmstr.ENTITY_ID in ('ROOT') and hr_empmstr.enddt = '12/31/2014' and hr_empmstr.department = 'MTB'
  )
  OR 
  (hr_empmstr.hr_status = 'I' and hr_empmstr.ENTITY_ID in ( 'ROOT', 'ROAD','PENS') and hr_empmstr.enddt > convert(datetime,'12/31/2021')
   and hr_empmstr.termcode <> 'NVST'
   ))
   and hr_empmstr.id NOT in ('R006862','R006869','R006875','R006877','R006879','R006880','R006881','R006886','R006887','R006891','R006897','R006898','R006899')
   and hr_empmstr.id NOT in ('E022340' ,'E022341' ,'E022342' ,'E022343' ,'E022344')
  order by 1


