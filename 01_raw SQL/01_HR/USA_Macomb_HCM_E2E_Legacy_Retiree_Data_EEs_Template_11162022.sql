SELECT 
  '' AS 'retirementPlannedDate'
  ,'' AS 'yearsOfServiceIncludingPurchasedTime'
  ,'' AS 'noMedicalReason'
  ,'' AS 'signatureVerificationLetter'
  ,IIF(HR_EMPMSTR.LONGEVITY <> HR_EMPMSTR.HDT, replace(convert(varchar, HR_EMPMSTR.LONGEVITY, 106),' ','-'), '') AS 'overrideLongevityDate'
--  'HR_EMPMSTR.LONGEVITY ONLY WHEN IT DOES NOT EQUAL HR_EMPMSTR.HDT (IF BLANK LEAVE BLANK)' AS 'overrideLongevityDate'
  ,HR_EMPMSTR.ID AS 'worker'
  ,HR_EMPMSTR.HRDATE6 AS 'medicalWaiverDate'
  ,HR_EMPMSTR.HRDATE2 AS 'nextReExamDate'
  ,HR_EMPMSTR.DISTSENR AS 'adjustedRetirementServiceDate'
FROM 
	  [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROOT') 
  and (hr_empmstr.hr_status = 'A')
 --AND NOT hr_empmstr.id in ('E022340','E022341','E022342','E022343','E022344')

UNION ALL

SELECT 
  '' AS 'retirementPlannedDate'
  ,'' AS 'yearsOfServiceIncludingPurchasedTime'
  ,'' AS 'noMedicalReason'
  ,'' AS 'signatureVerificationLetter'
  ,'' AS 'overrideLongevityDate'
  ,HR_EMPMSTR.ID AS 'worker'
  ,HR_EMPMSTR.HRDATE6 AS 'medicalWaiverDate'
  ,HR_EMPMSTR.HRDATE2 AS 'nextReExamDate'
  ,HR_EMPMSTR.DISTSENR AS 'adjustedRetirementServiceDate'
FROM 
	  [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROAD') 
  and (hr_empmstr.hr_status = 'A')
 --AND NOT hr_empmstr.id in ('E022340','E022341','E022342','E022343','E022344')

UNION ALL 
SELECT 
  replace(convert(varchar, HR_EMPMSTR.HRDATE5, 106),' ','-') AS 'retirementPlannedDate'
  ,replace(convert(varchar, HR_EMPMSTR.NUMB1, 106),' ','-') AS 'yearsOfServiceIncludingPurchasedTime'
  ,CASE 
    WHEN HR_EMPMSTR.HR8 = 'C' THEN 'DOES NOT QUALIFY'
    WHEN HR_EMPMSTR.HR8 = 'E' THEN 'EDRO'
	 WHEN HR_EMPMSTR.HR8 = 'D' THEN 'DROP'
	ELSE ''
	END AS 'noMedicalReason'
  ,HR_EMPMSTR.HR1 AS 'signatureVerificationLetter'
  ,'' AS 'overrideLongevityDate'
  ,HR_EMPMSTR.ID AS 'worker'
  ,HR_EMPMSTR.HRDATE6 AS 'medicalWaiverDate'
  ,HR_EMPMSTR.HRDATE2 AS 'nextReExamDate'
  ,'' AS 'adjustedRetirementServiceDate'
FROM 
	  [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('PENS') 
  and (hr_empmstr.hr_status = 'A')
 --AND NOT hr_empmstr.id in ('E022340','E022341','E022342','E022343','E022344')
