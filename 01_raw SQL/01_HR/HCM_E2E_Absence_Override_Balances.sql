/*HR_Override Balances*/
select
hr_empmstr.id as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'PositionID'
,CASE
  WHEN pyx_xtd_dtl.pyx_NO = '7007' and HR_empmstr.hr2 = 'Drop' THEN 'DROP_PTO_Time_Off_Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7007' and HR_empmstr.hr2 is null THEN 'PTO_Time_Off_Plan' 
  WHEN pyx_xtd_dtl.pyx_NO in ('7008','7037')  THEN 'Sick_Time_Off_Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7010' THEN 'Personal_Business-Time_Off_Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7014' THEN 'Compensatory-Time_Off_Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7038' THEN 'COVID-19-Time_Off_Plan'
  ELSE HR_empmstr.hr2 --convert(varchar,pyx_xtd_dtl.pyx_NO)
  END as 'TimeOffPlanID' --koaHills: CNP461
,'02-APR-2022' as 'OverrideBalanceDate'
,IIF(pyx_xtd_dtl.pyx_NO in ('7008','7037')
	,convert(numeric(12,2),convert(numeric(12,2),z.pyx_CTD)/100000)
	,convert(numeric(12,2),convert(numeric(12,2),pyx_xtd_dtl.pyx_CTD)/100000)) as 'OverrideBalanceUnits'
,'' as 'Comments'
/*,CASE
  WHEN HR_empmstr. hr2= 'Drop' THEN '1/1/2022' 
  WHEN pyx_xtd_dtl.pyx_NO in ('7008','7037') 
       AND HR_empmstr. hr2= 'Drop' THEN '1/1/2022'
  WHEN pyx_xtd_dtl.pyx_NO = '7010' 
       AND hr_empmstr.bargunit in ('01','07','20','26') THEN '1/1/2022' 
  ELSE ''
 END */
 ,'' as 'CarryoverDate'
/*,CASE
  WHEN HR_empmstr. hr2= 'Drop' THEN '12/31/2022' 
  WHEN pyx_xtd_dtl.pyx_NO in ('7008','7037') 
       AND HR_empmstr. hr2= 'Drop' THEN '12/31/2022'
  WHEN pyx_xtd_dtl.pyx_NO = '7010' 
       AND hr_empmstr.bargunit in ('01','07','20','26') THEN '12/31/2022' 
  ELSE ''
 END*/ 
 ,''as 'CarryoverExpirationDate'
/*,CASE 
 WHEN hr_empmstr.hr2 = 'Drop' THEN (hr_emppay.actl_hrs * 260) * hr_empmstr.numb2
 WHEN hr_empmstr.hr2 = 'Drop' THEN  hr_emppay.actl_hrs * 6
 WHEN hr_empmstr.bargunit in ('01','07','20','26') THEN 16
ELSE 0
END */
,'' as 'CarryoverOverrideBalanceUnits'
/*,'---hr_empmstr---'
,hr_empmstr.* 
,'---hr_emppay---'
,hr_emppay.*
,'---pyx_xtd_dtl---'
,pyx_xtd_dtl.**/
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_emppay]  ON hr_empmstr.id = hr_emppay.id
    AND hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
  RIGHT JOIN [production_finance].[dbo].pyx_xtd_dtl 
  ON hr_empmstr.id = pyx_xtd_dtl.hr_pe_id
  AND pyx_xtd_dtl.PYX_YY = '2022'
  /*AND pyx_xtd_dtl.pyx_no in ('7007','7008','7010','7014','7037','7038')*/
  AND pyx_xtd_dtl.pyx_no in ('7007','7010','7014','7038','7008','7037')
  AND pyx_xtd_dtl.PYX_CTD>0
  right JOIN (SELECT p.hr_pe_id, sum(p.pyx_CTD) as pyx_CTD
  FROM [production_finance].[dbo].pyx_xtd_dtl p
  WHERE p.pyx_no in ('7008','7037') AND p.PYX_YY = '2022'
  GROUP BY p.hr_pe_id) z 
  ON hr_empmstr.id = z.hr_pe_id
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 --and hr_empmstr.id = 'E003542'
UNION ALL
SELECT 
PT_Hours_Worked_for_Absence.WORKER_ID as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'PositionID'
,PT_Hours_Worked_for_Absence.TIME_OFF_PLAN_ID as 'TimeOffPlanID' 
,'11-DEC-2021' as 'OverrideBalanceDate'
,PT_Hours_Worked_for_Absence.OVERRIDE_BLANCE_UNITS as 'OverrideBalanceUnits'
,'' as 'Comments'
,'' as 'CarryoverDate'
,''as 'CarryoverExpirationDate'
,'' as 'CarryoverOverrideBalanceUnits'
FROM [IT.Macomb_DBA].[dbo].[PT_Hours_Worked_for_Absence]
order by 1