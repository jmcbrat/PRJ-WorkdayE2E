/*HR_EMP_terminations*/

SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE 
  WHEN hr_empmstr.HR_STATUS = 'I' THEN replace(convert(varchar,isnull(hr_empmstr.enddt,hr_empmstr.lastdaywrk),106),' ','-')
  --WHEN hr_empmstr.HR_STATUS = 'A' THEN dateadd(day,-1,hr_empmstr.hdt)
  ELSE null
  END as 'TerminationDate'
,CASE
WHEN hr_empmstr.lastdaywrk is null 
  and DATEPART(dw,hr_empmstr.enddt) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_empmstr.enddt), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is null 
  and DATEPART(dw,hr_empmstr.enddt) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_empmstr.enddt), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is null 
  and DATEPART(dw,hr_empmstr.enddt) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_empmstr.enddt), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is NOT null 
  and DATEPART(dw,hr_empmstr.lastdaywrk) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_empmstr.lastdaywrk), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is NOT null 
  and DATEPART(dw,hr_empmstr.lastdaywrk) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_empmstr.lastdaywrk), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is NOT null 
  and DATEPART(dw,hr_empmstr.lastdaywrk) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_empmstr.lastdaywrk), 106),' ','-')
ELSE ''
END  as 'LastDayofWork'
,CASE 
	WHEN hr_empmstr.termcode = 'DFRC' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'DFRT' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode = 'DISC' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'NOTR' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'NVST' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'RDIS' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'RESN' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode = 'RETR' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'REXP' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'RIF' THEN 'Terminate_Employee_Involuntary_Reduction_in_Force'
	WHEN hr_empmstr.termcode = 'RTDF' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'SUME' THEN 'Terminate_Employee_Involuntary_Contract_Ended'
	WHEN hr_empmstr.termcode = 'TERM' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'TRNS' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = '10YR' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode = 'DFRF' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode = 'DFRT' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode = 'PAID' THEN 'Terminate_Employee_Voluntary_Compensation'
	ELSE ''
	END as 'PrimaryReason'
,CASE 
	WHEN hr_empmstr.termcode2 = 'DFRC' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'DFRT' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode2 = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode2 = 'DISC' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'NOTR' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'NVST' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'RDIS' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'RESN' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode2 = 'RETR' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'REXP' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'RIF' THEN 'Terminate_Employee_Involuntary_Reduction_in_Force'
	WHEN hr_empmstr.termcode2 = 'RTDF' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'SUME' THEN 'Terminate_Employee_Involuntary_Contract_Ended'
	WHEN hr_empmstr.termcode2 = 'TERM' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'TRNS' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = '10YR' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode2 = 'DFRF' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode2 = 'DFRT' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode2 = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode2 = 'PAID' THEN 'Terminate_Employee_Voluntary_Compensation'
	ELSE ''
	END  as 'SecondaryReason'
,'' as 'LocalTerminationReason'
,'' as 'PayThroughDate'
,'' as 'ResignationDate'
,'' as 'NotifyEmployeeByDate'
,'' as 'Regrettable'
,'' as 'EligibleforRehire'

from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  		 and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)

where /*(hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')
		AND hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
		AND hr_empmstr.termcode <> 'NVST')
	OR (hr_empmstr.ENTITY_ID IN ('PENS')
		AND hr_empmstr.hr_status = 'A')*/
( /*(hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD','PENS'))
  no enddate on actives......
 OR*/ 
/*  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT')
  and hr_empmstr.termcode in ('DFRT','DFRC')
  )
 OR */
  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT')
  and hr_empmstr.enddt = '12/31/2014'
  and hr_empmstr.department = 'MTB'
  )
   OR (hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD') 
	 and hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'
 )
  )
order by 1
-- E007944 --no term date
-- E003026 --no term date