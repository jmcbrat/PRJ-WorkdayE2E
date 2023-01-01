/*HR_EMP_AddRetireeStatus*/

SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'Add_Retiree_Status_Retiree_Retirement' as 'RetireeReason'
,CASE 
  WHEN hr_empmstr.department= 'RETS' THEN 'SUP_RETIREE SHERIFF' 
  WHEN hr_empmstr.department= 'RETR' THEN 'SUP_RETIREE ROADS'
  WHEN hr_empmstr.department ='RETM' THEN 'SUP_RETIREE MTB'
  WHEN hr_empmstr.department= 'RETG' THEN 'SUP_RETIREE GENERAL'
  ELSE ''
  END as 'RetireeOrg'
,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-') as 'RetireeStatusDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.entity_id = 'PENS'