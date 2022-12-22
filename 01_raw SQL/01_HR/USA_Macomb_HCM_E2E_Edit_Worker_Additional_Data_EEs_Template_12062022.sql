-- USA_Macomb_HCM_E2E_Edit_Worker_Additional_Data_EEs_Template_12062022

SELECT 
  convert(varchar,ROW_NUMBER() OVER (ORDER BY Worker ))
  ,isnull(ee.EffectiveDate,'')
  ,ee.Worker
  ,ee.types
FROM ( 
SELECT 
 replace(convert(varchar, hr_empmstr.enddt, 106),' ','-') as 'EffectiveDate'
 ,hr_empmstr.id as 'Worker'
 ,'refundedContribution' as 'types'
 FROM 
	  [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('PENS') 
  AND hr_empmstr.hr_status = 'I'
  AND HR_empmstr.termcode IN ('Paid','DFRF')
 /* WHY 1421 and not 1426????*/
 UNION ALL
 SELECT 
 replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')
 ,hr_empmstr.id
 ,'retired'
 FROM 
	  [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROOT','ROAD') 
  AND hr_empmstr.hr_status = 'A'
  AND HR_EMPMSTR.HR1 in ('Retire', 'Retired', 'Ret EO')
  /* why 43 instead of 46 and I used HR1 instead of hr_empmster.numb1*/
UNION ALL
 SELECT 
 replace(convert(varchar, hr_empmstr.enddt, 106),' ','-')
 ,hr_empmstr.id
 ,'deferred'
 FROM 
	  [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROOT') 
  AND hr_empmstr.hr_status = 'I'
  AND HR_EMPMSTR.termcode in ('DFRT', 'DFRC')
  /* why 275 over 276?*/
UNION ALL
 SELECT 
 replace(convert(varchar, hr_empmstr.enddt, 106),' ','-')
 ,hr_empmstr.id
 ,'deferred'
 FROM 
	  [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROAD') 
  AND hr_empmstr.hr_status = 'I'
  AND HR_EMPMSTR.termcode in ('DFRT', 'DFRC')
  /* Matched*/
  ) AS EE

