--PayCommon_Paycheck Delivery Options

SELECT
	trim(hr_empmstr.id) as 'EmployeeID'
	,'Steve Smigiel' as 'SourceSystem'
	,CASE
		WHEN hr_empmstr.entity_id = 'PENS' THEN 'MAIL' 
		ELSE ''
	 END as 'PayCheckDeliveryMethod'
	,CASE
		WHEN hr_empmstr.entity_id = 'ROOT' THEN 'Electronic_Copy'
		WHEN hr_empmstr.entity_id = 'PENS' THEN 'Paper_Copy' 
		ELSE ''
	END as 'PayslipPrintingOverride'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
