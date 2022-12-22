/*hr_emp_WorkerLicenses*/

SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'CountryISOCode'	--koaSteven:CNP592
,upper(replace(replace(hr_licncert.regid, ' ',''),'-','')) /*(Only include records where hr_licncert.licntype = D4)*/ as 'LicenseID'
,IIF(hr_licncert.licntype = 'D4','Drivers License','') as 'LicenseType'
,'' as 'LicenseClass'
,'' as 'IssuedDate'
,'' as 'ExpirationDate'
,'' as 'VerificationDate'
,'USA-MI' as 'CountryRegion'
,'' as 'Authority'
from [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].hr_licncert 
    ON hr_empmstr.ID = hr_licncert.ID and hr_licncert.licntype = 'D4'
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 ORDER BY 1