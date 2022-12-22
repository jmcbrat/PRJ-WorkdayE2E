/*HCM_BENEFITS_Insurance_Elections*/
/*benefits assignment*/
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'A-Jen Smiley' as 'SourceSystem'

,CASE 
  WHEN hr_empmstr.hdt > '12/31/2021' THEN replace(convert(varchar,hr_empmstr.hdt,106),' ','-')
  WHEN hr_beneinfo.bene_end > GETDATE() THEN replace(convert(varchar,convert(date,'1/1/2022'),106),' ','-')
  ELSE ''
  END  as 'EventDate'  
,'Conversion_Insurance'  as 'BenefitEventType'
,CASE 
  WHEN hr_beneinfo.BENE_PLAN in ('LBASERNA','LBASER06') THEN 'Basic Life Insurance'
  WHEN hr_beneinfo.BENE_PLAN in ('SUPDATS1','SUPDATS2') THEN 'Supplemental Life Insurance - Spouse'
  WHEN hr_beneinfo.BENE_PLAN in ('SUPDATC1','SUPDATC2') THEN 'Supplemental Life Insurance - Child(ren)'
  WHEN hr_beneinfo.BENE_PLAN ='LTDCERLT' THEN 'Long Term Disability'
  WHEN hr_beneinfo.BENE_PLAN in (
	'LSUPAT01','LSUPAT02','LSUPAT03','LSUPAT04','LSUPAT05',                      
	'LSUPAT06','LSUPAT07','LSUPAT08','LSUPAT00','LSUPAT10',
	'LSUPAT11','LSUPAT12','LSUPAT13','LSUPAT14')  THEN 'Supplemental Life Insurance'
  ELSE ''
END as 'InsuranceCoveragePlan'	--koaHills:CNP509

/*

Insurance Coverage Plans were remapped as follows:
'Long Term Disability - Basic (Employee)' = 'Long Term Disability'
'Spousal Life - (Spouse/Partner)' = 'Supplemental Life Insurance - Spouse'
'USA - Basic Life - (Employee)' = 'Basic Life Insurance'
'USA - Child Life - (Child(ren))' = 'Supplemental Life Insurance - Child(ren)'

'USA - Supplemental Term Life - (Employee)' = 'Supplemental Life Insurance'.
*/

/*,Note: If  the benefit election is Spouse life or child life then need to include dependent id from the employee related person. 
This will be determined by looking at field hr_beneinfo.bene_plan
Here is the mapping to determine if the benefit plan is Spouse or Child Life:
ROOT & ROAD: 
1) SUPDATS1 - Spouse
2) SUPDATS2 - Spouse
3) SUPDATC1 - Child
4) SUPDATC2 - Child */
,'' as 'DependentID'
,'' as 'BeneficiaryID'
,'' as 'PrimaryPercentage'
,'' as 'ContingentPercentage'
,'' as 'OriginalCoverageBeginDate'
,'' as 'DeductionBeginDate'
,CASE
  WHEN hr_beneinfo.BENE_PLAN  = 'LTDCERLT' THEN convert(numeric(12,2),5) -- Long Term Disability - Basic (Employee)
  WHEN hr_beneinfo.BENE_PLAN in ('LBASERNA') THEN convert(numeric(12,2),50000) --'USA - Basic Life - (Employee)'
  WHEN hr_beneinfo.BENE_PLAN in ('LBASER06') THEN convert(numeric(12,2),150000) --'USA - Basic Life - (Employee)'
  WHEN right(hr_beneinfo.BENE_PLAN,2)='C2' THEN convert(numeric(12,2),10000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='S1' THEN convert(numeric(12,2),25000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='S2' THEN convert(numeric(12,2),50000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='01' THEN convert(numeric(12,2),25000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='02' THEN convert(numeric(12,2),50000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='03' THEN convert(numeric(12,2),75000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='04' THEN convert(numeric(12,2),100000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='05' THEN convert(numeric(12,2),125000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='06' THEN convert(numeric(12,2),150000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='07' THEN convert(numeric(12,2),175000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='08' THEN convert(numeric(12,2),200000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='09' THEN convert(numeric(12,2),225000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='10' THEN convert(numeric(12,2),250000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='11' THEN convert(numeric(12,2),275000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='12' THEN convert(numeric(12,2),300000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='13' THEN convert(numeric(12,2),325000)
  WHEN right(hr_beneinfo.BENE_PLAN,2)='14' THEN convert(numeric(12,2),hr_beneinfo.EMPLOYEE*1000)
  ELSE 0
  END as 'InsuranceCoverage'
,'' as 'EmployeeCostPostTax'

FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON hr_empmstr.id = hr_beneinfo.id
	  AND hr_beneinfo.BENE_PLAN in (
		'LBASERNA','LBASER06','SUPDATS1','SUPDATS2','SUPDATC1',
		'SUPDATC2','LTDCERLT','LSUPAT01','LSUPAT02','LSUPAT03',
		'LSUPAT04','LSUPAT05','LSUPAT06','LSUPAT07','LSUPAT08',
		'LSUPAT00','LSUPAT10','LSUPAT11','LSUPAT12','LSUPAT13','LSUPAT14')
	  AND hr_beneinfo.bene_end = '12/31/2050'
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
--AND hr_empmstr.ID in ('E008620','E008618')



union all




/*voluntary*/
  SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'V-Jen Smiley' as 'SourceSystem'

,CASE 
  WHEN hr_empmstr.hdt > '12/31/2021' THEN replace(convert(varchar,hr_empmstr.hdt,106),' ','-')
  WHEN hr_cdhassgn.enddt > GETDATE() THEN replace(convert(varchar,convert(date,'1/1/2022'),106),' ','-')
  ELSE ''
  END  as 'EventDate'  
,'Conversion_Insurance'  as 'BenefitEventType'
,CASE 
  WHEN hr_cdhassgn.no in ('2464','2425') THEN 'Universal Life'
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (7.98,8.22,8.48, 10.44,11.04,11.34, 10.44,10.68,10.92, 11.88,12.12,12.42) THEN 'Hospital Indemnity - Choice 1'
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (5.40,6.12,6.24, 11.40,12.78,12.90, 10.80,11.04,11.28, 13.80,14.10,14.70) THEN 'Hospital Indemnity - Choice 2'
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (8,58,10.98,14.34, 15.66,21.78,27.30, 11.88,13.50,17.70, 15.96,22.62,29.22) THEN 'Hospital Indemnity - Choice 3'
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (21.96,25.32,29.04, 37.50,45.60,51.54, 33.12,35.22,39.90 ,41.64,48.84,56.34) THEN 'Hospital Indemnity - Choice 4'
  WHEN hr_cdhassgn.no = '2467' THEN 'Accident Advantage'
  WHEN hr_cdhassgn.no = '2466' THEN 'Critical Care'
  WHEN hr_cdhassgn.no ='2463' THEN 'Short Term Disability'
	ELSE ''
	END as 'InsuranceCoveragePlan'
/*,Note: If  the benefit election is Spouse life or child life then need to include dependent id from the employee related person. 
This will be determined by looking at field hr_beneinfo.bene_plan
Here is the mapping to determine if the benefit plan is Spouse or Child Life:
ROOT & ROAD: 
1) SUPDATS1 - Spouse
2) SUPDATS2 - Spouse
3) SUPDATC1 - Child
4) SUPDATC2 - Child */
,'' as 'DependentID'
,'' as 'BeneficiaryID'
,'' as 'PrimaryPercentage'
,'' as 'ContingentPercentage'
,'' as 'OriginalCoverageBeginDate'
,'' as 'DeductionBeginDate'
,CASE 
  WHEN hr_cdhassgn.no in ('2464','2425') THEN convert(numeric(12,2),4) --'Universal Life'
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (7.98,8.22,8.48, 10.44,11.04,11.34, 10.44,10.68,10.92, 11.88,12.12,12.42) THEN convert(numeric(12,2),1600)
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (5.40,6.12,6.24, 11.40,12.78,12.90, 10.80,11.04,11.28, 13.80,14.10,14.70) THEN convert(numeric(12,2),2200)
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (8,58,10.98,14.34, 15.66,21.78,27.30, 11.88,13.50,17.70, 15.96,22.62,29.22) THEN convert(numeric(12,2),2010)
  WHEN hr_cdhassgn.no = '2495' and hr_cdhassgn.amt in (21.96,25.32,29.04, 37.50,45.60,51.54, 33.12,35.22,39.90 ,41.64,48.84,56.34) THEN convert(numeric(12,2),2610)
  WHEN hr_cdhassgn.no = '2467' THEN convert(numeric(12,2),1) --'Accident Advantage'
  WHEN hr_cdhassgn.no = '2466' THEN convert(numeric(12,2),2) --'Critical Care'
  WHEN hr_cdhassgn.no ='2463' THEN convert(numeric(12,2),3) --'Short Term Disability'
	ELSE convert(numeric(12,2),0)
	END  as 'InsuranceCoverage'
,'' as 'EmployeeCostPostTax'
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [production_finance].[dbo].hr_cdhassgn ON hr_empmstr.id = hr_cdhassgn.id
	  AND hr_cdhassgn.no in ('2464','2495','2425','2467','2466','2463')
	  and hr_cdhassgn.beg = (select max(c2.beg) from [production_finance].[dbo].hr_cdhassgn as c2 where hr_cdhassgn.id = c2.id)
	  and hr_cdhassgn.ENDDT='12/31/2050'
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
--AND hr_empmstr.ID in ('E008620','E008618')

order by 1
