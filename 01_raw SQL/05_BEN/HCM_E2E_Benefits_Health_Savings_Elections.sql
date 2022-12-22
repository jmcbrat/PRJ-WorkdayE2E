/*HCM_BENEFITS_Health_Savings_Elections*/
/*HSA in list*/
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'h-Jen Smiley' as 'SourceSystem'
 ,CASE 
 WHEN hr_empmstr.hdt <convert(datetime,'1/1/2022') THEN replace(convert(varchar,convert(date,'1/01/2022'),106),' ','-')
 WHEN hr_empmstr.hdt >=convert(datetime,'1/1/2022') THEN replace(convert(varchar,hr_empmstr.hdt,106),' ','-')
 ELSE ''
 END as 'EventDate'
,'Conversion_Health_Savings'  as 'BenefitEventType'
,CASE 
  WHEN hr_beneinfo.bene_plan in ('mbhder1E','mbhder2E','mbhder3E')
    AND CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))>=55 THEN 'HSACatchup'
  WHEN hr_beneinfo.bene_plan in ('mbhder1E','mbhder2E','mbhder3E') 
    AND CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))<55 THEN 'HSA'
 ELSE ''
 END as 'HealthSavingsAccountPlan'
,0 as 'YTDContributionAmount'
, CASE 
  WHEN hr_tsainfo.no = '2319' THEN HR_tsainfo.amt*26
  WHEN hr_tsainfo.no = '2980' THEN hr_cdhassgn.amt*26  /*hr_cdhassign.amt*26*/
  -- maybe a third condition

  ELSE 0
  END  as 'AnnualContribution'
, CASE 
  WHEN hr_tsainfo.no = '2319' THEN HR_tsainfo.amt
  WHEN hr_tsainfo.no = '2980' THEN hr_cdhassgn.amt
  ELSE 0
  END  as 'EmployeeCost'
                                              /*,Ask Diane if this is required. */
,(26-9) as 'BenefitDeductionPeriodsRemaining' /*how to calculate where we are now, then calc*/
,'Biweekly' as 'RemainingPeriodFrequency'
,CASE
  WHEN hr_tsainfo.no = '2319' THEN replace(convert(varchar,hr_tsainfo.beg ,106),' ','-')
  WHEN hr_beneinfo.bene_plan in ('mbhder1E','mbhder2E','mbhder3E') THEN replace(convert(varchar,hr_beneinfo.BENE_BEG,106),' ','-')
  ELSE ''
  END as 'OriginalCoverageBeginDate'
/*,'---tsa---'
,hr_tsainfo.*
,'---bene info ---'
,hr_beneinfo.*
*/
FROM [production_finance].[dbo].hr_empmstr

	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON hr_empmstr.id = hr_beneinfo.id
	  AND hr_beneinfo.BENE_PLAN in ('mbhder1E','mbhder2E','mbhder3E')
	  AND hr_beneinfo.bene_end > GETDATE()
   LEFT JOIN [production_finance].[dbo].hr_tsainfo 
	  ON hr_empmstr.id = hr_tsainfo.id 
	    and hr_tsainfo.no in('2319','2980')
	LEFT JOIN [production_finance].[dbo].hr_cdhassgn 
	  ON hr_empmstr.id = hr_cdhassgn.id
	  and hr_cdhassgn.beg = (select max(c2.beg) from [production_finance].[dbo].hr_cdhassgn as c2 where hr_cdhassgn.id = c2.id)

WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'


ORDER BY 1