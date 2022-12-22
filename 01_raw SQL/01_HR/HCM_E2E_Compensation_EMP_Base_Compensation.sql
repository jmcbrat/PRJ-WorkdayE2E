/*HR EMP-Base Compensation*/

SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id )  as 'Sequence#'
,CASE
  WHEN hr_empmstr.entity_id = 'PENS' AND hr_empmstr.hr13 = 'EB' THEN 'Request_Compensatin_Change_Retiree_Options_Option_EB_50%_Joint_Survivor_with_pop-up'
  WHEN hr_empmstr.entity_id = 'PENS' AND hr_empmstr.hr13 = 'A' THEN 'Request_Compensation_Change_Retiree_Options_Option_A_-_100%_Joint_Survivor'
  WHEN hr_empmstr.entity_id = 'PENS' AND hr_empmstr.hr13 = 'B' THEN 'Request_Compensation_Change_Retiree_Options_Option_B_-_50%_Joint_Survivor'
  WHEN hr_empmstr.entity_id = 'PENS' AND hr_empmstr.hr13 = 'C' THEN 'Request_Compensation_Change_Retiree_Options_Option_C _10_years_Certain_Life'
  WHEN hr_empmstr.entity_id = 'PENS' AND hr_empmstr.hr13 = 'EA' THEN 'Request_Compensation_Change_Retiree_Options_Option_EA_-_100%_Joint_Survivor_with_pop_up'
  WHEN hr_empmstr.entity_id = 'PENS' AND hr_empmstr.hr13 = 'SL' THEN 'Retiree Options- Straight Life'
  ELSE 'Request_Compensation_Change_Conversion_Conversion' 
  END as 'CompensationChangeReason'
,'' as 'PositionID'

,IIF(hr_empmstr.hdt>hr_emppay.pay_beg
  ,replace(convert(varchar,hr_empmstr.hdt, 106),' ','-')
  ,replace(convert(varchar,hr_emppay.pay_beg, 106),' ','-')) as 'EffectiveDate'
,'General_Compensation_Package' as 'CompensationPackage'	--koahills:CNP398

/*,substring(hr_emppay.indx_key,4,3)
,JOBCODEMAP.COMPGRADEID*/
,/*IIF(hr_emppay.pay_end>'4/1/2022',
    IIF(hr_emppay.misc_01 IS NULL,
	    JOBCODEMAP.COMPGRADEID,
	    hr_emppay.misc_01),*/
	 JOBCODEMAP.COMPGRADEID  as 'CompensationGrade' 
----,PCN - skip first 2, use next 5, skip last 3  ask Denise
,'' as 'CompensationGradeProfile'
,'' as 'CompensationStep'
,'' as 'ProgressionStartDate'
--C&P ,IIF(hr_emppay.re_calc='A','Salary_Plan','Hourly_Plan') as 'CompensationPlan-Base'
,hr_emppay.re_calc
,CASE 
	WHEN hr_empmstr.ID in ('E005412','E005651') THEN 'Salary_Plan'
	WHEN hr_empmstr.ID in ('E020983','E021708','E021868','E022032') THEN 'Hourly_Plan'
	WHEN hr_emppay.re_calc='A' THEN 'Salary_Plan'
	WHEN hr_emppay.re_calc='H' THEN 'Hourly_Plan'
	WHEN hr_emppay.re_calc='P' THEN 'Monthly_Plan'
	WHEN hr_empmstr.entity_id = 'PENS' THEN 'Monthly_Plan'
	ELSE ''
END as 'CompensationPlan-Base'	--koaHills:CNP413
--C&P ,iif(hr_emppay.re_calc='A',29000,9) as 'CompensationElementAmount-Base'
,CASE 
	WHEN hr_empmstr.ID in ('E005412','E005651') THEN hr_emppay.actl_ann
	WHEN hr_emppay.re_calc='A' THEN hr_emppay.actl_ann
	WHEN hr_emppay.re_calc='H' THEN hr_emppay.actl_hrly
	WHEN hr_emppay.re_calc='P' THEN hr_emppay.actl_per
	WHEN hr_empmstr.entity_id = 'PENS' THEN hr_emppay.actl_per
	ELSE 0
END as 'CompensationElementAmount-Base'
,'USD' as 'CurrencyCode-Base'
--C&P ,iif(hr_emppay.re_calc='A','Annual','Hourly') as 'Frequency-Base'
,CASE 
	WHEN hr_empmstr.ID in ('E005412','E005651') THEN 'Annual'
	WHEN hr_emppay.re_calc='A' THEN 'Annual'
	WHEN hr_emppay.re_calc='H' THEN 'Hourly'
	WHEN hr_emppay.re_calc='P' THEN 'Monthly'
	WHEN hr_empmstr.entity_id = 'PENS' THEN 'Monthly'
	ELSE hr_emppay.re_calc
End as 'Frequency-Base'
--C&P ,'' as 'CompensationPlan-Addl'
--C&P ,'' as 'CompensationElementAmount-Addl'
--C&P ,'' as 'CurrencyCode-Addl'
--C&P ,'' as 'Frequency-Addl'
--C&P ,'' as 'UnitSalaryPlan'
--C&P ,'' as 'PerUnitAmount-UnitSalary'
--C&P ,'' as 'CurrencyCode-UnitSalary'
--C&P ,'' as 'NumberofUnits-UnitSalary'
--C&P ,'' as 'Frequency-UnitSalary'
--C&P ,'' as 'CommissionPlan#1'
--C&P ,'' as 'TargetAmount-CommissionPlan#1'
--C&P ,'' as 'CurrencyCode-CommissionPlan#1'
--C&P ,'' as 'Frequency-CommissionPlan#1'
--C&P ,'' as 'DrawAmount-CommissionPlan#1'
--C&P ,'' as 'FrequencyforDrawAmount-CommissionPlan#1'
--C&P ,'' as 'DrawDuration-CommissionPlan#1'
--C&P ,'' as 'Recoverable-CommissionPlan#1'
--C&P ,'' as 'CommissionPlan#2'
--C&P ,'' as 'TargetAmount-CommissionPlan#2'
--C&P ,'' as 'CurrencyCode-CommissionPlan#2'
--C&P ,'' as 'Frequency-CommissionPlan#2'
--C&P ,'' as 'DrawAmount-CommissionPlan#2'
--C&P ,'' as 'FrequencyforDrawAmount-CommissionPlan#2'
--C&P ,'' as 'DrawDuration-CommissionPlan#2'
--C&P ,'' as 'Recoverable-CommissionPlan#2'
--,'-----'
--,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')  as 'HireDate'

from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
	  right JOIN [IT.Macomb_DBA].dbo.JOBCODEMAP
	  ON substring(hr_emppay.indx_key,4,3) = JOBCODEMAP.JobCode
where 
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
  )
 /*and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079', /*- Thida*/
'E021726',
'E033235' ) */

order by 1, hr_emppay.pay_beg;

