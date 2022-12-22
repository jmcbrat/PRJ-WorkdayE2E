/*EMP-Position Mgt*/


SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
--,trim(hr_emppay.position)+'-'+ 
--     convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_emppay.position ORDER BY hr_emppay.position)) as 'PositionID'
, CASE 
    WHEN hr_empmstr.ENTITY_ID = 'ROAD' THEN DOR.BUDGETED_PCN
	 ELSE EMP_Position_Mgt.Position_Number 
	 END as 'PositionID'

,CASE
  WHEN hr_empmstr.type  = 'FTBU' THEN 'Regular' 
  WHEN hr_empmstr.type  = 'PTBU'THEN 'Regular'
  WHEN hr_empmstr.type  = 'EO' THEN 'Regular'
  WHEN hr_empmstr.type  = 'ROAD' THEN 'Regular'
  WHEN hr_empmstr.type  = 'TEMP' THEN 'Regular' --'Temporary'
  WHEN hr_empmstr.type  = 'SUMR' THEN 'JTP Senior'
  ELSE ''
 END as 'EmployeeType'
,'Hire_Employee_Hire_Employee_Conversion'  as 'HireReason'
,''  as 'FirstDayofWork'
,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')  as 'HireDate'
,''  as 'ProbationStartDate'
,''  as 'ProbationEndDate'
,''  as 'EndEmploymentDate'
,''  as 'PositionStartDateforConversion'
,iif(EMP_Position_Mgt.supervisory_org is null, 'SUP_UNASSIGNED',EMP_Position_Mgt.supervisory_org) as 'SupervisoryOrganizationID'
/* C&P,trim(hr_postble.LONG_DESC)  as 'R-JobPostingTitle(forthePosition)'*/
,CASE 
   WHEN hr_empmstr.ENTITY_ID = 'ROAD' THEN BUDGETED_TITLE
	ELSE substring(hr_emppay.indx_key,4,3)+Left(hr_emppay.indx_key,2) 
	END as 'JobPostingTitle(forthePosition)'
,CASE 
  WHEN hr_empmstr.ENTITY_ID = 'ROAD' THEN substring(DOR.BUDGETED_PCN,3,3) 
  ELSE substring(hr_emppay.indx_key,4,3) 
  END as 'JobCode'
,''  as 'PositionTitle'
,''  as 'BusinessTitle'
,CASE
  WHEN  hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN  hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN  hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN  hr_empmstr.department IN ('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN  hr_empmstr.department = 'SHF' THEN 'LOC014'
  WHEN  hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN  hr_empmstr.department IN ('CIR','DCP','PCM','PCW','RMB','CLK') THEN 'LOC019'
  WHEN  hr_empmstr.department = 'JJC' THEN 'LOC020'
  WHEN  hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB'
        ,'MTB','PLN','PRS','RSK','TRS','RETG','RETS','RETR','RETM') THEN 'LOC023'
  WHEN  hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN  hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN  hr_empmstr.department = 'PRK' THEN 'LOC027'
  WHEN  hr_empmstr.department = 'HTH' THEN 'LOC028'
  WHEN  hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN  hr_empmstr.department IN ('MIS','ROAD','COR','ESC') THEN 'LOC035'
  WHEN  hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN  hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN  hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  ELSE hr_empmstr.department
  END as 'WorkLocation'
,''  as 'WorkSpace'

,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END as 'DefaultWeeklyHours'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END as 'ScheduledWeeklyHours'
,''  as 'PaidFTE'
,''  as 'WorkingFTE'

,CASE
  WHEN hr_empmstr.type  = 'FTBU' THEN 'Full_Time' 
  WHEN hr_empmstr.type  = 'PTBU'THEN 'Part_Time'
  WHEN hr_empmstr.type  = 'EO' THEN 'Full_Time'
  WHEN hr_empmstr.type  = 'ROAD' THEN 'Full_Time'
  WHEN hr_empmstr.type  = 'TEMP' THEN 'Part_Time'
  WHEN hr_empmstr.type  = 'SUMR' THEN 'Part_Time'
  ELSE ''
 END  as 'TimeType'
--Part time has 3 types Temp, SUMR, PTBU
/*C&P,iif(hr_emppay.re_calc='A','Salary','Hourly')  as 'R-PayRateType'*/
,CASE
  WHEN hr_empmstr.type in ('Temp','SUMR','PTBU') THEN 'Hourly'
  WHEN hr_empmstr.id = 'E005412' THEN 'Salary'
  WHEN hr_empmstr.Entity_id = 'ROAD' THEN 'Salary'
  WHEN hr_emppay.re_calc='A' THEN 'Salary'
  WHEN hr_emppay.re_calc='H' THEN 'Hourly'
  WHEN hr_empmstr.Entity_id = 'PENS' THEN 'Salary'
  ELSE hr_emppay.re_calc
  END as 'PayRateType'
-- payRateType = h=hourly, A=Salary, ( not used: d =day or p =period)
,''  as 'CompanyInsiderType'
,''  as 'WorkShift'
,''  as 'AdditionalJobClassification#1'
,''  as 'AdditionalJobClassification#2'
,''  as 'AdditionalJobClassification#3'
,''  as 'AdditionalJobClassification#4'

from [production_finance].[dbo].[hr_empmstr]
     left join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
	  left join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  on hr_empmstr.id = EMP_Position_Mgt.emp_id 
	  left join [it.Macomb_DBA].[dbo].Department_of_Roads as DOR
	  on hr_empmstr.id = DOR.EE_ID

WHERE
 ((hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD'))

  )

order by 1 /*hr_emppay.position*/

--E005818 --v two rows 