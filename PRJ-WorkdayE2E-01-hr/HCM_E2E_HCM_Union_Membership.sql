/*hr_emp_UnionMembership*/

SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'R-Denise Krzeminski' as 'SourceSystem'
,trim(hr_empmstr.bargunit) as 'UnionID'
,'Active Pays Dues' as 'MembershipType'								--koaHills:CNP448  (old note: -- "need logic here for acive_no_paid check")
,ISNULL(replace(convert(varchar,hr_empmstr.hrdate3,106),' ','-'), replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'UnionStartDate'		--koaHills:CNP447
,ISNULL(replace(convert(varchar,hr_empmstr.hrdate3,106),' ','-'), replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'UnionSeniorityDate'	--koaHills:CNP446
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'ROOT' and HR_EMPMSTR.BARGUNIT <> '00'

UNION ALL
/*PENS*/
SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'C-Denise Krzeminski' as 'SourceSystem'
,trim(hr_empmstr.bargunit) as 'UnionID'
,'Active Pays Dues' as 'MembershipType'						--koaHills:CNP448  (old note: -- "need logic here for acive_no_paid check")
,ISNULL(replace(convert(varchar,hr_empmstr.beg,106),' ','-'), replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'UnionStartDate'	--koaHills:CNP447
,ISNULL(replace(convert(varchar,hr_empmstr.hdt,106),' ','-'),'') as 'UnionSeniorityDate'
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and  hr_empmstr.ENTITY_ID = 'ROAD' and HR_EMPMSTR.BARGUNIT <> '31'

UNION ALL
SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'P-Denise Krzeminski' as 'SourceSystem'
,case
  WHEN hr_empmstr.bargunit= 'UK' THEN '26'
  ELSE hr_empmstr.bargunit
  END as 'UnionID'  --forced for R002645 to 26.... it was UK
,'Active No Dues' as 'MembershipType'								--koaHills:CNP448
,ISNULL(replace(convert(varchar,hr_empmstr.beg,106),' ','-'), replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'UnionStartDate'			--koaHills:CNP447
,ISNULL(replace(convert(varchar,hr_empmstr.hrdate3,106),' ','-'), replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'UnionSeniorityDate'	--koaHills:CNP446
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'PENS' 
and not HR_EMPMSTR.BARGUNIT in ('00','31')

order by 3,1