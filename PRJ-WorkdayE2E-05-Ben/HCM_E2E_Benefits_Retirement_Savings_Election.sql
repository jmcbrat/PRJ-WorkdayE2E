/*HCM_BENEFITS_Retirement_Savings_Election*/
/*-------
dependent on table being created from Employee Related Person
Table: [IT.Macomb_DBA].dbo.Empl_Related_Person

For now this will not be used in the query below.
*/

---------*/
/*401a*/
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'k-Jen Smiley' as 'SourceSystem'
,IIF(hr_empmstr.hdt<convert(datetime,'1/1/2022')
  ,replace(convert(varchar,convert(date,'1/1/2022'),106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'EventDate'
,'Conversion_Retirement_Savings'  as 'BenefitEventType'
,CASE 
  WHEN hr_beneinfo.bene_plan = 'DCEEPTNA' THEN '401(a)'
  WHEN hr_beneinfo.bene_plan in( 'DC4EPTNA','DC1EATNA') THEN '401(a)'
  ELSE ''
  END  as 'RetirementSavingsPlan'
,CASE 
  WHEN hr_beneinfo.bene_plan = 'DCEEPTNA' THEN 3
  WHEN hr_beneinfo.bene_plan in( 'DC4EPTNA','DC1EATNA') THEN 1
  ELSE 0
  END as 'ElectionPercentage'
,0 as 'ElectionAmount'
,'' as 'BeneficiaryID-BeneficiaryAllocation'
,'' as 'PrimaryPercentage-BeneficiaryAllocation'
,'' as 'ContingentPercentage-BeneficiaryAllocation'
,replace(convert(varchar,hr_beneinfo.bene_beg,106),' ','-') as 'OriginalCoverageBeginDate'
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON trim(hr_empmstr.id) = trim(hr_beneinfo.id)
	  AND hr_beneinfo.BENE_PLAN in ('DCEEPTNA','DC4EPTNA','DC1EATNA') -- 'DC1EATNA'
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'


union all


/*475(b)*/
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'b-Jen Smiley' as 'SourceSystem'
,IIF(hr_empmstr.hdt<convert(datetime,'1/1/2022')  /*correct hire date??*/
     ,replace(convert(varchar,convert(datetime,'1/1/2022'),106),' ','-')
	  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'EventDate'
,'Conversion_Retirement_Savings'  as 'BenefitEventType'
,CASE 
  WHEN hr_tsainfo.no = '2349' THEN 'DeferredComp' 
  ELSE ''
  END  as 'RetirementSavingsPlan'
,0 as 'ElectionPercentage'
/*,Election Amount will be populated if the selection criteria finds CDH Code 2349 in hr_tsainfo.no field. If this is found, then Election Amount = hr_tsainfo.amt */
,IIF(hr_tsainfo.no = '2349',hr_tsainfo.amt,0) as 'ElectionAmount'
,'' as 'BeneficiaryID-BeneficiaryAllocation'
,'' as 'PrimaryPercentage-BeneficiaryAllocation'
,'' as 'ContingentPercentage-BeneficiaryAllocation'
,replace(convert(varchar,hr_tsainfo.beg,106),' ','-') as 'OriginalCoverageBeginDate'
/* -- break union to see these
,'--- testing ---'
,convert(varchar,hr_empmstr.beg) as conv_beg
,hr_empmstr.HR15 as h15
,hr_empmstr.beg as beg
,hr_empmstr.HDT
,hr_empmstr.HR4 as h4
,hr_empmstr.bargunit as barg
,hr_tsainfo.no AS tasno
*/
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [production_finance].[dbo].hr_tsainfo ON hr_empmstr.id = hr_tsainfo.id
  AND hr_tsainfo.no ='2349'
/*  LEFT JOIN [production_finance].[dbo].hr_emppay ON hr_empmstr.id = hr_emppay.id
      AND hr_emppay.pcn in ('SH92200001','SH52400001')
*/
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'

UNION ALL


/*PENEATNA*/
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'p-Jen Smiley' as 'SourceSystem'
,IIF(hr_empmstr.hdt<convert(datetime,'1/1/2022')  /*correct hire date??*/
     ,replace(convert(varchar,convert(datetime,'1/1/2022'),106),' ','-')
	  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'EventDate'
,'Conversion_Retirement_Savings'  as 'BenefitEventType'
,CASE 
  WHEN hr_beneinfo.bene_plan = 'PENEATNA' THEN 'Defined Benefit' /*need correct code*/
  ELSE 'b- '+hr_beneinfo.bene_plan
  END  as 'RetirementSavingsPlan'
,CASE 
  WHEN hr_beneinfo.bene_plan = 'PENEATNA'  
       AND (hr_empmstr.BARGUNIT in ('01','07','20','26')
		     OR hr_emppay.pcn in ('SH92200001','SH52400001')
			  ) THEN 4
  WHEN hr_beneinfo.bene_plan = 'PENEATNA'
       AND hr_empmstr.BARGUNIT in ('04','05') THEN 2.5
	/* below logic does not work the hr15 is not a date corrected to hdt... */
   /* Is this the correct hire date ???*/
  WHEN IIF(hr_empmstr.beg>hr_empmstr.hrdate6
          ,hr_empmstr.beg
			 ,hr_empmstr.hrdate6) <convert(datetime,'01/01/2002') THEN 3.5
  WHEN hr_empmstr.HR4='70PTS' THEN 3.5
  ELSE 2.5
  END as 'ElectionPercentage'
/*,Election Amount will be populated if the selection criteria finds CDH Code 2349 in hr_tsainfo.no field. If this is found, then Election Amount = hr_tsainfo.amt */
,0 as 'ElectionAmount'
,'' as 'BeneficiaryID-BeneficiaryAllocation'
,'' as 'PrimaryPercentage-BeneficiaryAllocation'
,'' as 'ContingentPercentage-BeneficiaryAllocation'
,replace(convert(varchar,hr_beneinfo.bene_beg,106),' ','-') as 'OriginalCoverageBeginDate'
/* -- break union to see these
,'--- testing ---'
,convert(varchar,hr_empmstr.beg) as conv_beg
,hr_empmstr.HR15 as h15
,hr_empmstr.beg as beg
,hr_empmstr.HDT
,hr_empmstr.HR4 as h4
,hr_empmstr.bargunit as barg
,hr_tsainfo.no AS tasno
*/
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON hr_empmstr.id = hr_beneinfo.id
	  AND hr_beneinfo.BENE_PLAN = 'PENEATNA'
   LEFT JOIN [production_finance].[dbo].hr_emppay ON hr_empmstr.id = hr_emppay.id
      AND hr_emppay.pcn in ('SH92200001','SH52400001')
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'

  order by 1
