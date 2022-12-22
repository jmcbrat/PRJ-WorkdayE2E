--HR_EMP-Calculated Plans

SELECT
hr_empmstr.id as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ) as 'Sequence#'
,'Request_Compensation_Change_Conversion_Conversion' as 'CompensationChangeReason'
,'' as 'PositionID'
,hr_empmstr.longevity as 'EffectiveDate'
,'Longevity_Plan' as 'CalculatedPlan#1'
,'' as 'AmountOverride#1'
,'' as 'CurrencyCode-CalculatedPlan#1'
,'' as 'Frequency-CalculatedPlan#1'
,'' as 'CalculatedPlan#2'
,'' as 'AmountOverride#2'
,'' as 'CurrencyCode-CalculatedPlan#2'
,'' as 'Frequency-CalculatedPlan#2'
from [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROOT')
  AND hr_empmstr.longevity is not null

ORDER by 1