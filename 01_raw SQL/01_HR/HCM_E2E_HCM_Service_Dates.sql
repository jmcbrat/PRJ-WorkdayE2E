/*service dates */

SELECT 
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,replace(convert(varchar, hr_empmstr.beg, 106),' ','-') as 'OriginalHireDate'
,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-') as 'ContinuousServiceDate'
,'' as 'ExpectedRetirementDate'
,'' as 'RetirementEligibilityDate'
,'' as 'SeniorityDate'
,'' as 'SeveranceDate'
,'' as 'BenefitsServiceDate'
,'' as 'CompanyServiceDate'
,CASE /*need to validate this is correct */ 
  WHEN hr_empmstr.entity_id IN ('ROOT','ROAD') THEN replace(convert(varchar,hr_empmstr.hrdate2,106),' ','-')
  WHEN hr_empmstr.entity_id = 'PENS' THEN ''
  ELSE ''
END AS 'TimeOffServiceDate'
,'' as 'VestingDate'


/*,'+++++hr_emppay+++++'
,hr_emppay.*
*/
from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
where /*hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in('ROOT','PENS','ROAD')*/
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
) */
order by 1