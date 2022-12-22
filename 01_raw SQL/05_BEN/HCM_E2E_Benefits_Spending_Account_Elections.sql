/*HCM_BENEFITS_Spending_Account_Elections*/


SELECT
trim(hr_empmstr.id ) as 'EmployeeID'
,'Jen Smiley' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.hdt > '12/31/2021' THEN hr_empmstr.hdt
  WHEN hr_tsainfo.beg < convert(datetime,'01/01/2022') THEN replace(convert(date,convert(date,'1/1/2022'),106),' ','-')
  WHEN hr_tsainfo.beg >= '1/1/2022' THEN replace(convert(date,hr_tsainfo.beg,106),' ','-')
  ELSE ''
  END  as 'EventDate'
,'Conversion_Spending_Account' as 'BenefitEventType'
,CASE 
  WHEN hr_tsainfo.no in ('2329','2327') THEN 'Health FSA'
  WHEN hr_tsainfo.no in ('2328','2326') THEN 'Dependent Care Assistance'
  ELSE ''
  END as 'SpendingAccountPlan' --koaHills:CNP517
,0 as 'YTDContributionAmount' -- isnt this 9 * HR_tsainfo.amt for most employees
,HR_tsainfo.amt*26  as 'AnnualContribution'
,HR_tsainfo.amt as 'EmployeeCost'
,(26-9) as 'BenefitDeductionPeriodsRemaining'
,'Biweekly' as 'RemainingPeriodFrequency'
,'' as 'OriginalCoverageBeginDate'  /* intentially blank? */
FROM [production_finance].[dbo].hr_empmstr
   RIGHT JOIN [production_finance].[dbo].hr_tsainfo ON hr_empmstr.id = hr_tsainfo.id 
	AND hr_tsainfo.no in ('2328','2329','2326','2327')
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
 -- and hr_empmstr.id = 'E003542'

  order by 1
