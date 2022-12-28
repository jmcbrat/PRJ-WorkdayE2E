--HR_Benefits_Employee_Related_Person
USE [IT.Macomb_DBA]
GO

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'Empl_Related_Person'))
	BEGIN
		create table dbo.Empl_Related_Person 
		(
		EmployeeID varchar(7)
		,Sourcesystem varchar(100)
		,DependentID varchar(100)
		,BeneficiaryID varchar(100)
		,EmergencyContactID varchar(100)
		,RelatedPersonRelationship varchar(100)
		,CountryISOCode_LegalName varchar(3)
		,FirstName varchar(100)
		,MiddleName varchar(100)
		,LastName varchar(100)
		,Prefix varchar(25)
		,Suffix varchar(25)
		,TrustName varchar(25)
		,Language varchar(25)
		,EmergencyContactPriority varchar(25)
		,SamePhoneasEmployee varchar(25)
		,CountryISOCode_PrimaryHome varchar(3)
		,InternationalPhoneCode_PrimaryHome varchar(2)
		,PhoneNumber_PrimaryHome varchar(25)
		,PhoneExtension_PrimaryHome varchar(25)
		,PhoneDeviceType_PrimaryHome varchar(20)
		,CountryISOCode_AdditionalHome_1 varchar(3)
		,InternationalPhoneCode_AdditionalHome_1 varchar(3)
		,PhoneNumber_AdditionalHome_1 varchar(20)
		,PhoneExtension_AdditionalHome_1 varchar(10)
		,PhoneDeviceType_AdditionalHome_1 varchar(20)
		,CountryISOCode_AdditionalHome_2 varchar(3)
		,InternationalPhoneCode_AdditionalHome_2 varchar(2)
		,PhoneNumber_AdditionalHome_2 varchar(20)
		,PhoneExtension_AdditionalHome_2 varchar(2)
		,PhoneDeviceType_AdditionalHome_2 varchar(20)
		,CountryISOCode_PrimaryWork varchar(3)
		,InternationalPhoneCode_PrimaryWork varchar(2)
		,PhoneNumber_PrimaryWork varchar(20)
		,PhoneExtension_PrimaryWork varchar(2)
		,PhoneDeviceType_PrimaryWork  varchar(20)
		,CountryISOCode_AdditionalWork_1 varchar(3)
		,InternationalPhoneCode_AdditionalWork_1 varchar(2)
		,PhoneNumber_AdditionalWork_1 varchar(200)
		,PhoneExtension_AdditionalWork_1 varchar(2)
		,PhoneDeviceType_AdditionalWork_1 varchar(20)
		,CountryISOCode_AdditionalWork_2 varchar(3)
		,InternationalPhoneCode_AdditionalWork_2 varchar(2)
		,PhoneNumber_AdditionalWork_2 varchar(200)
		,PhoneExtension_AdditionalWork_2 varchar(2)
		,PhoneDeviceType_AdditionalWork_2 varchar(20)
		,EmailAddress_PrimaryHome varchar(100)
		,EmailAddress_PrimaryWork varchar(100)
		,EmailAddress_AdditionalHome varchar(100)
		,EmailAddress_AdditionalWork  varchar(100)
		,SameAddressasEmployee  varchar(2)
		,CountryISOCode_Home varchar(3)
		,AddressLine_1_Home varchar(100)
		,AddressLine_2_Home varchar(2)
		,City_Home varchar(50)
		,CitySubdivision_Home varchar(2)
		,CitySubdivision2_Home varchar(2)
		,Region_Home varchar(6)
		,RegionSubdivision_Home varchar(2)
		,RegionSubdivision2_Home varchar(2)
		,PostalCode_Home varchar(9)
		,CountryISOCode_AltHome_1 varchar(3)
		,AddressLine_1_AltHome_1 varchar(2)
		,AddressLine_2_AltHome_1 varchar(2)
		,City_AltHome_1 varchar(2)
		,CitySubdivision_AltHome_1 varchar(2)
		,CitySubdivision2_AltHome_1 varchar(2)
		,Region_AltHome_1 varchar(2)
		,RegionSubdivision_AltHome_1 varchar(2)
		,RegionSubdivision2_AltHome_1 varchar(2)
		,PostalCode_AltHome_1 varchar(2)
		,DateofBirth datetime
		,Gender  varchar(20)
		,NationalID  varchar(20)
		,NationalIDType  varchar(7)
		,EffectiveDate  datetime
		,Reason varchar(20)
		,UsesTobacco varchar(2)
		,Full_timeStudent varchar(2)
		,DependentforPayrollPurposes varchar(2)
		,StudentStatusStartDate varchar(2)
		,StudentStatusEndDate varchar(2)
		,Disabled varchar(2)
		,CouldBeCoveredForHealthCareCoverageElsewhere varchar(2)
		,CouldBeCoveredForHealthCareCoverageElsewhereDate varchar(2)
		,BenefitCoverageType_Medical varchar(20)
		,StartDate_Medical varchar(20)
		,EndDate_Medical varchar(2)
		,BenefitCoverageType_Dental varchar(20)
		,StartDate_Dental varchar(20)
		,EndDate_Dental varchar(2)
		,BenefitCoverageType_Vision varchar(20)
		,StartDate_Vision varchar(2)
		,EndDate_Vision varchar(2)
		,SSN_EXT varchar(2)
		,HR_STATUS varchar(2)
		,ENTITY_ID varchar(4)
		);
		PRINT N'created table.'; 
	END
else
	begin
		delete from [IT.Macomb_DBA].dbo.Empl_Related_Person; 
		PRINT N'deleted table data.'; 
	END 
GO
USE production_finance
GO
--select * from @Empl_Related_Person



IF OBJECT_ID(N'tempdb..#person_Links') IS NOT NULL
BEGIN
DROP TABLE #person_Links
END
GO

create table #person_Links
(
 ID varchar(7)
 ,DU_id INT
 ,BU_ID INT
)

insert into #person_Links
/*people with depn and matching BENs*/
select DEPN.ID
,DEPN.unique_id as DU_ID
--,BEN.unique_id as BU_ID
,null as BU_ID
FROM (select * from [production_finance].[dbo].hr_Family
		where (not hr_family.enddt < '12/31/2022' or hr_family.enddt is null)
	   and hr_family.FAMILY_TP = 'DEPN'
		and hr_family.RELATION NOT in ('ID','IS')
		) AS DEPN 
inner join (
SELECT * from [production_finance].[dbo].hr_Family
where left(hr_family.family_tp,3) ='BEN') AS BEN
     ON BEN.ID = DEPN.ID 
		  AND BEN.FAMDOB = DEPN.FAMDOB

union all
/*people with depn but no BEN */
select DEPN.ID
,DEPN.unique_id as DU_ID
,BEN.unique_id as BU_ID
FROM (select * from [production_finance].[dbo].hr_Family
		where (not hr_family.enddt < '12/31/2022' or hr_family.enddt is null)
	   and hr_family.FAMILY_TP = 'DEPN'
		and hr_family.RELATION NOT in ('ID','IS')
		) AS DEPN 
left outer  join (
SELECT * from [production_finance].[dbo].hr_Family
where left(hr_family.family_tp,3) ='BEN') AS BEN
     ON BEN.ID = DEPN.ID AND BEN.unique_id is null
		  AND BEN.FAMDOB = DEPN.FAMDOB
WHERE DEPN.ENTITY_ID = 'ROOT'
and DEPN.unique_id not in (select DEPN.unique_id
FROM (select * from [production_finance].[dbo].hr_Family
		where (not hr_family.enddt < '12/31/2022' or hr_family.enddt is null)
	   and hr_family.FAMILY_TP = 'DEPN'
		and hr_family.RELATION NOT in ('ID','IS')
		) AS DEPN 
 /*and ID = 'E002209'*/
inner join (
select *
from [production_finance].[dbo].hr_Family
where left(hr_family.family_tp,3) ='BEN') AS BEN
     ON BEN.ID = DEPN.ID 
		  AND BEN.FAMDOB = DEPN.FAMDOB)

--UNION ALL
/*People with BEN but no depn*/
/*select BEN.ID
,0 as DU_ID
,BEN.unique_id as BU_ID
FROM (SELECT * from [production_finance].[dbo].hr_Family
where left(hr_family.family_tp,3) ='BEN') AS BEN
  WHERE BEN.ENTITY_ID = 'ROOT' 
    AND NOT exists (SELECT * 
                      FROM [production_finance].[dbo].hr_Family AS DEPN 
							 WHERE DEPN.family_tp = 'DEPN' AND BEN.ID = DEPN.ID AND ENTITY_ID = 'ROOT' ) 
*/	
order by 1

--select * from #person_Links where id = 'E001029'

insert [IT.Macomb_DBA].[DBO].[Empl_Related_Person]

SELECT 
x.EmployeeID as EmployeeID
,x.SourceSystem
,IIF(x.pre_depn <>'',trim(x.EmployeeID) +'-'+ 'DEPN'
   +convert(varchar,ROW_NUMBER() OVER (PARTITION BY x.EmployeeID ORDER BY x.EmployeeID,x.sort_order,x.sort_order )) 
	,'') /*=DEPN*/ AS 'DependentID'
,IIF(x.pre_ben <>'',trim(x.EmployeeID) +'-'+ 'BEN'
   +convert(varchar,ROW_NUMBER() OVER (PARTITION BY x.EmployeeID ORDER BY x.EmployeeID,x.sort_order )) 
	,'') /*=DEPN*/ AS 'BeneficiaryID'
,'' as 'EmergencyContactID'
,x.RelatedPersonRelationship
,x.CountryISOCode_LegalName
,x.FirstName
,x.MiddleName
,x.LastName
,x.Prefix
,x.Suffix
,x.TrustName
,x.Language
,x.EmergencyContactPriority
,x.SamePhoneasEmployee
,x.CountryISOCode_PrimaryHome
,x.InternationalPhoneCode_PrimaryHome
,x.PhoneNumber_PrimaryHome
,x.PhoneExtension_PrimaryHome
,x.PhoneDeviceType_PrimaryHome
,x.CountryISOCode_AdditionalHome_1
,x.InternationalPhoneCode_AdditionalHome_1
,x.PhoneNumber_AdditionalHome_1
,x.PhoneExtension_AdditionalHome_1
,x.PhoneDeviceType_AdditionalHome_1
,x.CountryISOCode_AdditionalHome_2
,x.InternationalPhoneCode_AdditionalHome_2
,x.PhoneNumber_AdditionalHome_2
,x.PhoneExtension_AdditionalHome_2
,x.PhoneDeviceType_AdditionalHome_2
,x.CountryISOCode_PrimaryWork
,x.InternationalPhoneCode_PrimaryWork
,x.PhoneNumber_PrimaryWork
,x.PhoneExtension_PrimaryWork
,x.PhoneDeviceType_PrimaryWork
,x.CountryISOCode_AdditionalWork_1
,x.InternationalPhoneCode_AdditionalWork_1
,x.PhoneNumber_AdditionalWork_1
,x.PhoneExtension_AdditionalWork_1
,x.PhoneDeviceType_AdditionalWork_1
,x.CountryISOCode_AdditionalWork_2
,x.InternationalPhoneCode_AdditionalWork_2
,x.PhoneNumber_AdditionalWork_2
,x.PhoneExtension_AdditionalWork_2
,x.PhoneDeviceType_AdditionalWork_2
,x.EmailAddress_PrimaryHome
,x.EmailAddress_PrimaryWork
,x.EmailAddress_AdditionalHome
,x.EmailAddress_AdditionalWork
,x.SameAddressasEmployee
,x.CountryISOCode_Home
,x.AddressLine_1_Home
,x.AddressLine_2_Home
,x.City_Home
,x.CitySubdivision_Home
,x.CitySubdivision2_Home
,x.Region_Home
,x.RegionSubdivision_Home
,x.RegionSubdivision2_Home
,x.PostalCode_Home
,x.CountryISOCode_AltHome_1
,x.AddressLine_1_AltHome_1
,x.AddressLine_2_AltHome_1
,x.City_AltHome_1
,x.CitySubdivision_AltHome_1
,x.CitySubdivision2_AltHome_1
,x.Region_AltHome_1
,x.RegionSubdivision_AltHome_1
,x.RegionSubdivision2_AltHome_1
,x.PostalCode_AltHome_1
,x.DateofBirth
,x.Gender
,x.NationalID
,x.NationalIDType
,x.EffectiveDate
,x.Reason
,x.UsesTobacco
,x.Full_timeStudent
,x.DependentforPayrollPurposes
,x.StudentStatusStartDate
,x.StudentStatusEndDate
,x.Disabled
,x.CouldBeCoveredForHealthCareCoverageElsewhere
,x.CouldBeCoveredForHealthCareCoverageElsewhereDate
,x.BenefitCoverageType_Medical
,x.StartDate_Medical
,x.EndDate_Medical
,x.BenefitCoverageType_Dental
,x.StartDate_Dental
,x.EndDate_Dental
,x.BenefitCoverageType_Vision
,x.StartDate_Vision
,x.EndDate_Vision
,x.SSN_EXT
,x.HR_STATUS
,x.entity_id
FROM  (
SELECT
1 as sort_order
,iif(pl.Du_id is not null,pl.id,'') as pre_depn
,iif(pl.bu_id is not null,HFB.id,'') as pre_ben
,trim(hr_empmstr.id) as 'EmployeeID'
,'D-Jen Smiley' as 'SourceSystem'
,trim(hr_family.family_tp) as Fam_TP
,CASE 
	WHEN hr_family.relation = 'OT' THEN 'Other'
	WHEN hr_family.relation = 'SI' THEN 'Sibling'
	WHEN hr_family.relation = 'SP' THEN 'Spouse'
	WHEN hr_family.relation = 'IS' THEN 'Ex-Spouse'
	WHEN hr_family.relation = 'PA' THEN 'Parent'
	WHEN hr_family.relation = 'CH' THEN 'Child'
	WHEN hr_family.relation = 'SC' THEN 'Step Child'
	WHEN hr_family.relation = 'DD' THEN 'Disabled Dependent'
	WHEN hr_family.relation = 'ID' THEN 'Ineligible Dependent'
	WHEN hr_family.relation = 'MU' THEN 'Multiple'
	--WHEN hr_family.relation = 'ZZ' THEN 'Same Sex Spouse'
	--WHEN hr_family.relation = 'XX' THEN 'Legal Dependent'
	--WHEN hr_family.relation = 'YY' THEN 'Domestic_Partner_Child'
	--WHEN hr_family.relation = 'WW' THEN 'Domestic Partner'
	--WHEN hr_family.relation = 'VV' THEN 'Ex-Domestic Partner'
	ELSE hr_family.relation
END as 'RelatedPersonRelationship'
,'USA' as 'CountryISOCode_LegalName'
,parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),2) AS FirstName
,replace(parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),1),'~','') AS MiddleName

,parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2) as LastName
,'' as 'Prefix'

,'' as 'Suffix'
,'' as 'TrustName'
,'' as 'Language'
,'' as 'EmergencyContactPriority'
,'' as 'SamePhoneasEmployee'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_PrimaryHome'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode_PrimaryHome'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber_PrimaryHome'
,ISNULL(hr_family.phone_ext,'') as 'PhoneExtension_PrimaryHome'
,IIF(hr_family.phone_no is not null,'mobile','') as 'PhoneDeviceType_PrimaryHome'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode_AdditionalHome_1'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber_AdditionalHome_1'
,'' as 'PhoneExtension_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'Mobile','') as 'PhoneDeviceType_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_AdditionalHome_2'
,'' as 'InternationalPhoneCode_AdditionalHome_2'
,'' as 'PhoneNumber_AdditionalHome_2'
,'' as 'PhoneExtension_AdditionalHome_2'
,'' as 'PhoneDeviceType_AdditionalHome_2'
,'' as 'CountryISOCode_PrimaryWork'
,'' as 'InternationalPhoneCode_PrimaryWork'
,'' as 'PhoneNumber_PrimaryWork'
,'' as 'PhoneExtension_PrimaryWork'
,'' as 'PhoneDeviceType_PrimaryWork'
,'' as 'CountryISOCode_AdditionalWork_1'
,'' as 'InternationalPhoneCode_AdditionalWork_1'
,'' as 'PhoneNumber_AdditionalWork_1'
,'' as 'PhoneExtension_AdditionalWork_1'
,'' as 'PhoneDeviceType_AdditionalWork_1'
,'' as 'CountryISOCode_AdditionalWork_2'
,'' as 'InternationalPhoneCode_AdditionalWork_2'
,'' as 'PhoneNumber_AdditionalWork_2'
,'' as 'PhoneExtension_AdditionalWork_2'
,'' as 'PhoneDeviceType_AdditionalWork_2'
,'' as 'EmailAddress_PrimaryHome'
,'' as 'EmailAddress_PrimaryWork'
,'' as 'EmailAddress_AdditionalHome'
,'' as 'EmailAddress_AdditionalWork'
,'Y' as 'SameAddressasEmployee'
,'USA' as 'CountryISOCode_Home'
,ISNULL(hr_family.ST_1, 'Not Available') as 'AddressLine_1_Home'	--koaHills:CNP555
,'' as 'AddressLine_2_Home'
,CASE WHEN hr_family.CITY IS NULL OR trim(hr_family.CITY) = '' THEN 'Not Available' ELSE trim(hr_family.CITY) END  as 'City_Home' --koaHills: CNP561
,'' as 'CitySubdivision_Home'
,'' as 'CitySubdivision2_Home'
,IIF(hr_family.STATE IS NULL,'','USA-'+hr_family.STATE) as 'Region_Home'
,'' as 'RegionSubdivision_Home'
,'' as 'RegionSubdivision2_Home'
,ISNULL(left(trim(hr_family.ZIP_CODE),5), '99999') as 'PostalCode_Home' --koaHills: CNP559
,'USA' as 'CountryISOCode_AltHome_1'
,'' as 'AddressLine_1_AltHome_1'
,'' as 'AddressLine_2_AltHome_1'
,'' as 'City_AltHome_1'
,'' as 'CitySubdivision_AltHome_1'
,'' as 'CitySubdivision2_AltHome_1'
,'' as 'Region_AltHome_1'
,'' as 'RegionSubdivision_AltHome_1'
,'' as 'RegionSubdivision2_AltHome_1'
,'' as 'PostalCode_AltHome_1'
,replace(convert(varchar, HR_family.famdob, 106),' ','-') as 'DateofBirth'
,CASE 
  WHEN HR_family.gender = 'F' THEN 'Female'
  WHEN HR_family.gender = 'M' THEN 'Male'
  ELSE ''
  END  as 'Gender'
,CASE WHEN Hr_family.family_SSN = '999999999' OR Hr_family.family_SSN IS NULL THEN '' ELSE Hr_family.family_SSN END as 'NationalID' -- koaHills: CNP607
,CASE WHEN Hr_family.family_SSN = '999999999' OR Hr_family.family_SSN IS NULL THEN '' ELSE 'USA-SSN' END as 'NationalIDType' -- koaHills: CNP607
,replace(convert(varchar, GETDATE(), 106),' ','-') as 'EffectiveDate'
,'' as 'Reason' --koaHills: CNP574
,'' as 'UsesTobacco'
,'' as 'Full_timeStudent'
,'' as 'DependentforPayrollPurposes'
,'' as 'StudentStatusStartDate'
,'' as 'StudentStatusEndDate'
,IIF(HR_family.relation='dd','Y','') as 'Disabled'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhere'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhereDate'
,'' as 'BenefitCoverageType_Medical'	--koaHills: E2E875
,'' as 'StartDate_Medical'				--koaHills: E2E875
,'' as 'EndDate_Medical'
,'' as 'BenefitCoverageType_Dental'		--koaHills: E2E874
,'' as 'StartDate_Dental'				--koaHills: E2E874
,'' as 'EndDate_Dental'
,'' as 'BenefitCoverageType_Vision'		--koaHills: E2E876
,'' as 'StartDate_Vision'
,'' as 'EndDate_Vision'
,hr_family.SSN_EXT as SSN_EXT
,hr_empmstr.HR_STATUS
,hr_empmstr.ENTITY_ID
FROM [production_finance].[dbo].hr_empmstr
left join #person_Links AS PL
  ON hr_empmstr.id = pl.ID and (pl.DU_id is not null )
RIGHT JOIN [production_finance].[dbo].hr_Family
   ON hr_empmstr.ID = hr_family.id and hr_family.unique_id = pl.DU_id
RIGHT JOIN [production_finance].[dbo].hr_Family as HFB
   ON hr_empmstr.ID = HFB.id and HFB.unique_id = pl.DU_id
where hr_empmstr.entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'

/*UNION ALL 

SELECT
2
,iif(pl.Du_id =0 ,'',pl.id) as pre_depn
,iif(pl.bu_id is not null,HFB.id,'') as pre_ben
,trim(hr_empmstr.id) as 'EmployeeID'
,'D-Jen Smiley 2' as 'SourceSystem'
,trim(hr_family.family_tp)
,CASE 
	WHEN hr_family.relation = 'OT' THEN 'Other'
	WHEN hr_family.relation = 'SI' THEN 'Sibling'
	WHEN hr_family.relation = 'SP' THEN 'Spouse'
	WHEN hr_family.relation = 'IS' THEN 'Ex-Spouse'
	WHEN hr_family.relation = 'PA' THEN 'Parent'
	WHEN hr_family.relation = 'CH' THEN 'Child'
	WHEN hr_family.relation = 'SC' THEN 'Step Child'
	WHEN hr_family.relation = 'DD' THEN 'Disabled Dependent'
	WHEN hr_family.relation = 'ID' THEN 'Ineligible Dependent'
	WHEN hr_family.relation = 'MU' THEN 'Multiple'
	--WHEN hr_family.relation = 'ZZ' THEN 'Same Sex Spouse'
	--WHEN hr_family.relation = 'XX' THEN 'Legal Dependent'
	--WHEN hr_family.relation = 'YY' THEN 'Domestic_Partner_Child'
	--WHEN hr_family.relation = 'WW' THEN 'Domestic Partner'
	--WHEN hr_family.relation = 'VV' THEN 'Ex-Domestic Partner'
	ELSE hr_family.relation
END as 'RelatedPersonRelationship'
,'USA' as 'CountryISOCode_LegalName'
,parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),2) AS FirstName
,replace(parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),1),'~','') AS MiddleName
,parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2) as LastName
,'' as 'Prefix'
,'' as 'Suffix'
,'' as 'TrustName'
,'' as 'Language'
,''  as 'EmergencyContactPriority'
,'' as 'SamePhoneasEmployee'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_PrimaryHome'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode_PrimaryHome'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber_PrimaryHome'
,ISNULL(hr_family.phone_ext,'') as 'PhoneExtension_PrimaryHome'
,IIF(hr_family.phone_no is not null,'mobile','') as 'PhoneDeviceType_PrimaryHome'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode_AdditionalHome_1'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber_AdditionalHome_1'
,'' as 'PhoneExtension_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'Mobile','') as 'PhoneDeviceType_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_AdditionalHome_2'
,'' as 'InternationalPhoneCode_AdditionalHome_2'
,'' as 'PhoneNumber_AdditionalHome_2'
,'' as 'PhoneExtension_AdditionalHome_2'
,'' as 'PhoneDeviceType_AdditionalHome_2'
,'' as 'CountryISOCode_PrimaryWork'
,'' as 'InternationalPhoneCode_PrimaryWork'
,'' as 'PhoneNumber_PrimaryWork'
,'' as 'PhoneExtension_PrimaryWork'
,'' as 'PhoneDeviceType_PrimaryWork'
,'' as 'CountryISOCode_AdditionalWork_1'
,'' as 'InternationalPhoneCode_AdditionalWork_1'
,'' as 'PhoneNumber_AdditionalWork_1'
,'' as 'PhoneExtension_AdditionalWork_1'
,'' as 'PhoneDeviceType_AdditionalWork_1'
,'' as 'CountryISOCode_AdditionalWork_2'
,'' as 'InternationalPhoneCode_AdditionalWork_2'
,'' as 'PhoneNumber_AdditionalWork_2'
,'' as 'PhoneExtension_AdditionalWork_2'
,'' as 'PhoneDeviceType_AdditionalWork_2'
,'' as 'EmailAddress_PrimaryHome'
,'' as 'EmailAddress_PrimaryWork'
,'' as 'EmailAddress_AdditionalHome'
,'' as 'EmailAddress_AdditionalWork'
,'Y' as 'SameAddressasEmployee'
,'USA' as 'CountryISOCode_Home'
,ISNULL(hr_family.ST_1, 'Not Available') as 'AddressLine_1_Home'	--koaHills:CNP555
,'' as 'AddressLine_2_Home'
,CASE WHEN hr_family.CITY IS NULL OR trim(hr_family.CITY) = '' THEN 'Not Available' ELSE trim(hr_family.CITY) END  as 'City_Home' --koaHills: CNP561
,'' as 'CitySubdivision_Home'
,'' as 'CitySubdivision2_Home'
,IIF(hr_family.STATE IS NULL,'','USA-'+hr_family.STATE) as 'Region_Home'
,'' as 'RegionSubdivision_Home'
,'' as 'RegionSubdivision2_Home'
,ISNULL(left(trim(hr_family.ZIP_CODE),5), '99999') as 'PostalCode_Home' --koaHills: CNP559
,'USA' as 'CountryISOCode_AltHome_1'
,'' as 'AddressLine_1_AltHome_1'
,'' as 'AddressLine_2_AltHome_1'
,'' as 'City_AltHome_1'
,'' as 'CitySubdivision_AltHome_1'
,'' as 'CitySubdivision2_AltHome_1'
,'' as 'Region_AltHome_1'
,'' as 'RegionSubdivision_AltHome_1'
,'' as 'RegionSubdivision2_AltHome_1'
,'' as 'PostalCode_AltHome_1'
,replace(convert(varchar, HR_family.famdob, 106),' ','-') as 'DateofBirth'
,CASE 
  WHEN HR_family.gender = 'F' THEN 'Female'
  WHEN HR_family.gender = 'M' THEN 'Male'
  ELSE ''
  END  as 'Gender'
,CASE WHEN Hr_family.family_SSN = '999999999' OR Hr_family.family_SSN IS NULL THEN '' ELSE Hr_family.family_SSN END as 'NationalID' -- koaHills: CNP607
,CASE WHEN Hr_family.family_SSN = '999999999' OR Hr_family.family_SSN IS NULL THEN '' ELSE 'USA-SSN' END as 'NationalID' -- koaHills: CNP607
,replace(convert(varchar, GETDATE(), 106),' ','-') as 'EffectiveDate'
,'' as 'Reason' --koaHills: CNP574
,'' as 'UsesTobacco'
,'' as 'Full_timeStudent'
,'' as 'DependentforPayrollPurposes'
,'' as 'StudentStatusStartDate'
,'' as 'StudentStatusEndDate'
,IIF(HR_family.relation='dd','Y','') as 'Disabled'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhere'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhereDate'
,'Medical' as 'BenefitCoverageType_Medical' --koaHills: CNP568
,'1-JAN-2022' as 'StartDate_Medical'
,'' as 'EndDate_Medical'
,'Dental' as 'BenefitCoverageType_Dental' --koaHills: CNP567
,'1-JAN-2022' as 'StartDate_Dental'
,'' as 'EndDate_Dental'
,'Vision' as 'BenefitCoverageType_Vision' --koaHills: CNP573
,'' as 'StartDate_Vision'
,'' as 'EndDate_Vision'
,hr_family.SSN_EXT as SSN_EXT
,hr_empmstr.HR_STATUS
,hr_empmstr.ENTITY_ID
FROM [production_finance].[dbo].hr_empmstr
left join #person_Links AS PL
   ON hr_empmstr.id = pl.ID and (pl.DU_id =0 ) and (pl.BU_id is NOT null )
RIGHT JOIN [production_finance].[dbo].hr_Family
   ON hr_empmstr.ID = hr_family.id and hr_family.unique_id = pl.BU_id
RIGHT JOIN [production_finance].[dbo].hr_Family as HFB
   ON hr_empmstr.ID = HFB.id and HFB.unique_id = pl.BU_id 
where hr_empmstr.entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'*/ ) as X
  
order by x.EmployeeID;
GO


--select * from #[IT.Macomb_DBA].[DBO].[Empl_Related_Person];
--GO

select
 [EmployeeID]
,[Sourcesystem]
,[DependentID]
,[BeneficiaryID]
,[EmergencyContactID]
,[RelatedPersonRelationship]
,[CountryISOCode_LegalName]
,[FirstName]
,[MiddleName]
,[LastName]
,[Prefix]
,[Suffix]
,[TrustName]
,[Language]
,[EmergencyContactPriority]
,[SamePhoneasEmployee]
,[CountryISOCode_PrimaryHome]
,[InternationalPhoneCode_PrimaryHome]
,[PhoneNumber_PrimaryHome]
,[PhoneExtension_PrimaryHome]
,[PhoneDeviceType_PrimaryHome]
,[CountryISOCode_AdditionalHome_1]
,[InternationalPhoneCode_AdditionalHome_1]
,[PhoneNumber_AdditionalHome_1]
,[PhoneExtension_AdditionalHome_1]
,[PhoneDeviceType_AdditionalHome_1]
,[CountryISOCode_AdditionalHome_2]
,[InternationalPhoneCode_AdditionalHome_2]
,[PhoneNumber_AdditionalHome_2]
,[PhoneExtension_AdditionalHome_2]
,[PhoneDeviceType_AdditionalHome_2]
,[CountryISOCode_PrimaryWork]
,[InternationalPhoneCode_PrimaryWork]
,[PhoneNumber_PrimaryWork]
,[PhoneExtension_PrimaryWork]
,[PhoneDeviceType_PrimaryWork]
,[CountryISOCode_AdditionalWork_1]
,[InternationalPhoneCode_AdditionalWork_1]
,[PhoneNumber_AdditionalWork_1]
,[PhoneExtension_AdditionalWork_1]
,[PhoneDeviceType_AdditionalWork_1]
,[CountryISOCode_AdditionalWork_2]
,[InternationalPhoneCode_AdditionalWork_2]
,[PhoneNumber_AdditionalWork_2]
,[PhoneExtension_AdditionalWork_2]
,[PhoneDeviceType_AdditionalWork_2]
,[EmailAddress_PrimaryHome]
,[EmailAddress_PrimaryWork]
,[EmailAddress_AdditionalHome]
,[EmailAddress_AdditionalWork]
,[SameAddressasEmployee]
,[CountryISOCode_Home]
,[AddressLine_1_Home]
,[AddressLine_2_Home]
,[City_Home]
,[CitySubdivision_Home]
,[CitySubdivision2_Home]
,[Region_Home]
,[RegionSubdivision_Home]
,[RegionSubdivision2_Home]
,[PostalCode_Home]
,[CountryISOCode_AltHome_1]
,[AddressLine_1_AltHome_1]
,[AddressLine_2_AltHome_1]
,[City_AltHome_1]
,[CitySubdivision_AltHome_1]
,[CitySubdivision2_AltHome_1]
,[Region_AltHome_1]
,[RegionSubdivision_AltHome_1]
,[RegionSubdivision2_AltHome_1]
,[PostalCode_AltHome_1]
,[DateofBirth]
,[Gender]
,trim(replace([NationalID],'-',''))  as NationalID -- E2E863
,[NationalIDType]
,[EffectiveDate]
,[Reason]
,[UsesTobacco]
,[Full_timeStudent]
,[DependentforPayrollPurposes]
,[StudentStatusStartDate]
,[StudentStatusEndDate]
,[Disabled]
,[CouldBeCoveredForHealthCareCoverageElsewhere]
,[CouldBeCoveredForHealthCareCoverageElsewhereDate]
,[BenefitCoverageType_Medical]
,[StartDate_Medical]
,[EndDate_Medical]
,[BenefitCoverageType_Dental]
,[StartDate_Dental]
,[EndDate_Dental]
,[BenefitCoverageType_Vision]
,[StartDate_Vision]
,[EndDate_Vision]
from [IT.Macomb_DBA].[DBO].[Empl_Related_Person]
where NOT (NationalID in ('BENF1','BENF2', 'BENF')
          OR NationalID = '')
and AddressLine_1_Home <> 'Not Available'
and city_home  <> 'Not Available'
and postalcode_home <> '99999'
and len(nationalid ) = 9
--and firstname is null and lastname is null
--and gender = '' 
--and phonenumber_primaryhome = ''
--and dateofbirth = ''
order by 1
