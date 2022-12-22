/*HR_EMP_VET_ID*/

SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,IIF(hr_empmstr.veteran='V','IDENTIFY_AS_A_VETERAN_JUST_NOT_A_PROTECTED_VETERAN','NOT_A_VETERAN') as 'USVeteranTenanted'
,'' as 'USProtectedVeteranStatusType'
,'' as 'DischargeDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.entity_id in ('ROOT','PENS','ROAD')
and hr_empmstr.veteran='V'
