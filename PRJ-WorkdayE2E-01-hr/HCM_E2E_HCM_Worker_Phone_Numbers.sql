/*worker phone numbers*/

select 
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'Home' as 'Type'
,IIF(ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id)=1,'Y','N')
/*,'Y'*/ as 'Primary'
,'N' as 'Public'
,IIF(hr_empmstr.id= 'R001197', 'USA',trim(hr_empmstr.country)) as 'CountryISOCode'
,1 as 'InternationalPhoneCode'
,CASE
  WHEN trim(hr_empmstr.id) = 'C150000' THEN '5868722828'
  WHEN hr_empmstr.phone_no is null THEN trim(replace(replace(replace(replace(hr_empmstr.phone_no2,'(',''),')',''),'-',''),' ',''))
  ELSE trim(replace(replace(replace(replace(hr_empmstr.phone_no,'(',''),')',''),'-',''),' ',''))
  END  as 'PhoneNumber' -- Solves E2E999
/*IIF(hr_empmstr.phone_no is null 
  ,replace(replace(replace(replace(hr_empmstr.phone_no2,'(',''),')',''),'-',''),' ','')
  ,replace(replace(replace(replace(hr_empmstr.phone_no,'(',''),')',''),'-',''),' ','')) as 'PhoneNumber'*/ 
,'' as 'PhoneExtension'
,'Mobile' as 'PhoneDeviceType'

from /*[IT.Macomb_dba].[dbo].[xref_hr_empmster__x__contact] x
     left join [production_finance].[dbo].[hr_empmstr]
	  on x.id = hr_empmstr.id*/
	  [production_finance].[dbo].[hr_empmstr]
where /*hr_empmstr.ENTITY_ID in ('ROOT','ROAD','PENS')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))*/
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
   and hr_empmstr.id not in ('R006862','R006869','R006875','R006877','R006879','R006880','R006881','R006886','R006887','R006891','R006897','R006898','R006899')
   and hr_empmstr.id not in ('R006885')  -- no phone number
   and hr_empmstr.id NOT in ('E022340' ,'E022341' ,'E022342' ,'E022343' ,'E022344')
/*hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) */

order by 1