select DEPN.ID
,DEPN.unique_id as DU_ID
,BEN.unique_id as BU_ID
,'' as EMC_ID
,DEPN.FAMDOB
,DEPN.FAMILY_SSN
,DEPN.FAMILYNAME
,DEPN.RELATION
,'--ben--'
,BEN.FAMDOB
,BEN.FAMILY_SSN
,BEN.FAMILYNAME
,BEN.RELATION

FROM (select * from [production_finance].[dbo].hr_Family
		where (not hr_family.enddt < '12/31/2022' or hr_family.enddt is null)
	   and hr_family.FAMILY_TP = 'DEPN'
		and hr_family.RELATION NOT in ('ID','IS')
		) AS DEPN 
 /*and ID = 'E002209'*/
inner join (
SELECT * from [production_finance].[dbo].hr_Family
where left(hr_family.family_tp,3) ='BEN') AS BEN
     ON BEN.ID = DEPN.ID 
		  AND BEN.FAMDOB = DEPN.FAMDOB

union all
select DEPN.ID
,DEPN.unique_id as DU_ID
,BEN.unique_id as BU_ID
,'' as EMC_ID
,DEPN.FAMDOB
,DEPN.FAMILY_SSN
,DEPN.FAMILYNAME
,DEPN.RELATION
,'--ben--'
,BEN.FAMDOB
,BEN.FAMILY_SSN
,BEN.FAMILYNAME
,BEN.RELATION

FROM (select * from [production_finance].[dbo].hr_Family
		where (not hr_family.enddt < '12/31/2022' or hr_family.enddt is null)
	   and hr_family.FAMILY_TP = 'DEPN'
		and hr_family.RELATION NOT in ('ID','IS')
		) AS DEPN 
 /*and ID = 'E002209'*/
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
SELECT * from [production_finance].[dbo].hr_Family
where left(hr_family.family_tp,3) ='BEN') AS BEN
     ON BEN.ID = DEPN.ID 
		  AND BEN.FAMDOB = DEPN.FAMDOB)
	

	

order by 1