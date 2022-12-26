/*EMP-Biographic Data*/

SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,replace(convert(varchar, hr_empmstr.bdt, 106),' ','-') as 'DateofBirth'
,'' as 'CountryofBirth'
,'' as 'RegionofBirth'
,'' as 'CityofBirth'
,'' as 'DateofDeath'
,CASE 
  WHEN hr_empmstr.gender='F' THEN 'Female'
  WHEN hr_empmstr.gender='M' THEN 'Male' 
  ELSE hr_empmstr.gender 
  END as 'Gender'
,'' as 'Disability#1'
,'' as 'DisabilityStatusDate#1'
,'' as 'DisabilityDateKnown#1'
,'' as 'DisabilityEndDate#1'
,'' as 'DisabilityGrade#1'
,'' as 'DisabilityDegree#1'
,'' as 'DisabilityRemainingCapacity#1'
,'' as 'DisabilityCertificationAuthority#1'
,'' as 'DisabilityCertifiedAt#1'
,'' as 'DisabilityCertificationID#1'
,'' as 'DisabilityCertificationBasis#1'
,'' as 'DisabilitySeverityRecognitionDate#1'
,'' as 'DisabilityFTETowardQuota#1'
,'' as 'DisabilityWorkRestrictions#1'
,'' as 'DisabilityAccommodationsRequested#1'
,'' as 'DisabilityAccommodationsProvided#1'
,'' as 'DisabilityRehabilitationRequested#1'
,'' as 'DisabilityRehabilitationProvided#1'
,'' as 'Note#1'
,'' as 'TobaccoUserStatus'
,'' as 'BloodType'
,'' as 'SexualOrientation'
,'' as 'GenderIdentity'
,'' as 'Pronoun'
,'' as 'LGBTIdentification#1'
,'' as 'LGBTIdentification#2'
FROM 	  [production_finance].[dbo].[hr_empmstr]
where 
 /*hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')*/
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
order by 1