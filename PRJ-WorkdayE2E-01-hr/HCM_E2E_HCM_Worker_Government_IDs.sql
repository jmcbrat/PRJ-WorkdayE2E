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
where  len(replace(replace(hr_empmstr.ssn,'-',''),' ',''))=9
and ((hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD','PENS'))
 OR
  (hr_empmstr.hr_status = 'I' and hr_empmstr.ENTITY_ID in ('ROOT','ROAD') and hr_empmstr.termcode in ('DFRT','DFRC')
  )
 OR 
  (hr_empmstr.hr_status = 'I' and hr_empmstr.ENTITY_ID in ('ROOT') and hr_empmstr.enddt = '12/31/2014' and hr_empmstr.department = 'MTB'
  )
  OR 
  (hr_empmstr.hr_status = 'I' and hr_empmstr.ENTITY_ID in ( 'ROOT', 'ROAD','PENS') and hr_empmstr.enddt > convert(datetime,'12/31/2021')
   and hr_empmstr.termcode <> 'NVST'
   ))
   and hr_empmstr.id NOT in ('R006862','R006869','R006875','R006877','R006879','R006880','R006881','R006886','R006887','R006891','R006897','R006898','R006899')
   and hr_empmstr.id NOT in ('E022340' ,'E022341' ,'E022342' ,'E022343' ,'E022344')
  

 ORDER BY 1