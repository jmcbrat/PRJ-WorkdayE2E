/*hr_EMP_Worker Government IDs*/

SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'USA' as 'CountryISOCode'
,'National' as 'Type'
,'USA-SSN' as 'WorkdayIDType'
,replace(replace(hr_empmstr.ssn,'-',''),' ','') as 'ID'
,'' as 'IssuedDate'
,'' as 'ExpirationDate'
,'' as 'VerificationDate'
,'' as 'Series-NationalID'
,'' as 'IssuingAgency-NationalID'
from [production_finance].[dbo].[hr_empmstr]
where  /*hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	     and hr_empmstr.termcode <> 'NVST'))*/
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

 ORDER BY 1