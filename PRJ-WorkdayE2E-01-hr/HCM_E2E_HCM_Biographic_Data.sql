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
order by 1