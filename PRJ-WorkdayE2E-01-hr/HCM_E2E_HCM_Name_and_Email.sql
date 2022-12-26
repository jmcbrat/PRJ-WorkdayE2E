use [production_finance]
GO 
/*name and email address*/

select 
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
--c&p,'' as 'ApplicantSource'
,trim(hr_empmstr.country) as 'CountryISOCode'
,trim(upper(hr_empmstr.fname)) as 'LegalFirstName'
,trim(upper(replace(isnull(hr_empmstr.mname,''),'.',''))) as 'LegalMiddleName'
,iif(hr_empmstr.lname = 'GOVAERE-BUSQUAERT', 'GOVAERE-BUSQUAERT',trim(upper(replace(hr_empmstr.lname, ' ','')))) as 'LegalLastName'
,'' as 'LegalSecondaryLastName'
,'' /*hr_empmstr.salute*/ as 'NamePrefix'
,'COUNTRY_PREDEFINED_PERSON_NAME_COMPONENT_'+trim(hr_empmstr.suffix) as 'NameSuffix'
,'' as 'FamilyNamePrefix'
,CASE 
  WHEN hr_empmstr.prefname is not null THEN hr_empmstr.prefname 
  ELSE ''
  END as 'PreferredFirstName'
,CASE 
  WHEN hr_empmstr.prefname is not null THEN hr_empmstr.mname 
  ELSE ''
  END as 'PreferredMiddleName'
,CASE 
  WHEN hr_empmstr.prefname is not null THEN hr_empmstr.lname 
  ELSE ''
  END as 'PreferredLastName'
,'' as 'PreferredSecondaryLastName'
,'' as 'PreferredNamePrefix'
,'' as 'PreferredNameSuffix'
,IIF(hr_empmstr.former is not null, 'USA','') as 'AdditionalCountryISOCode'
,IIF(hr_empmstr.former is not null, trim(upper(hr_empmstr.fname)),'') as 'AdditionalFirstName'
,IIF(hr_empmstr.former is not null,trim(upper(replace(isnull(hr_empmstr.mname,''),'.',''))),'') as 'AdditionalMiddleName'
--,'' as 'AdditionalLastName'
,hr_empmstr.former as 'AdditionalLastName'
,'' as 'AdditionalSecondaryLastName'
,'' as 'AdditionalNameType'
,trim(dbo.fn_parse_e_mail(E_Mail,'P',1)) as 'EmailAddress-PrimaryHome'
,iif(dbo.fn_parse_e_mail(E_Mail,'P',1)= '','','N') as 'Public-PrimaryHome'
,trim(dbo.fn_parse_e_mail(E_Mail,'W',1)) as 'EmailAddress-PrimaryWork'
,iif(dbo.fn_parse_e_mail(E_Mail,'W',1)='','','Y') as 'Public-PrimaryWork'
,trim(dbo.fn_parse_e_mail(E_Mail,'P',2)) as 'EmailAddress-AdditionalHome'
,iif(dbo.fn_parse_e_mail(E_Mail,'P',2)='','','N') as 'Public-AdditionalHome'
,trim(dbo.fn_parse_e_mail(E_Mail,'W',2)) as 'EmailAddress-AdditionalWork'
,iif(dbo.fn_parse_e_mail(E_Mail,'W',2)='','','N') as 'Public-AdditionalWork'
/*,'------ hr_empmstr -------'
,hr_empmstr.*
--*/

FROM /*[IT.Macomb_dba].[dbo].[xref_hr_empmster__x__contact] x
     left join [production_finance].[dbo].[hr_empmstr]
	  on x.id = hr_empmstr.id*/
	  [production_finance].[dbo].[hr_empmstr]
     left join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
WHERE
 ((hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD','PENS'))
 OR
  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
  and hr_empmstr.termcode in ('DFRT','DFRC')
  )
 OR 
  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT')
  and hr_empmstr.enddt = '12/31/2014'
  and hr_empmstr.department = 'MTB'
  )
  -- job mgt file add ins
 OR
 (hr_empmstr.hr_status = 'I'
         and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
         and hr_empmstr.enddt > convert(datetime,'12/31/2021')
   and hr_empmstr.termcode <> 'NVST')
 /*OR 
 (hr_empmstr.hr_status = 'I'
         and hr_empmstr.ENTITY_ID = 'PENS'
         and hr_empmstr.enddt > convert(datetime,'12/31/2021')
 )*/)
 and E_Mail is not null
ORDER BY 1