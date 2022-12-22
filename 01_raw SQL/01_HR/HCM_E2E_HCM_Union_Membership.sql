/*hr_emp_UnionMembership*/

SELECT
hr_empmstr.id as 'WorkerID'
,'R-Denise Krzeminski' as 'SourceSystem'
,hr_empmstr.bargunit as 'UnionID'
,'Active Pays Dues' as 'MembershipType'								--koaHills:CNP448  (old note: -- "need logic here for acive_no_paid check")
,ISNULL(hr_empmstr.hrdate3, hr_empmstr.hdt) as 'UnionStartDate'		--koaHills:CNP447
,ISNULL(hr_empmstr.hrdate3, hr_empmstr.hdt) as 'UnionSeniorityDate'	--koaHills:CNP446
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'ROOT' and HR_EMPMSTR.BARGUNIT <> '00'

UNION ALL
/*PENS*/
SELECT
hr_empmstr.id as 'WorkerID'
,'C-Denise Krzeminski' as 'SourceSystem'
,hr_empmstr.bargunit as 'UnionID'
,'Active Pays Dues' as 'MembershipType'						--koaHills:CNP448  (old note: -- "need logic here for acive_no_paid check")
,ISNULL(hr_empmstr.beg, hr_empmstr.hdt) as 'UnionStartDate'	--koaHills:CNP447
,hr_empmstr.hdt as 'UnionSeniorityDate'
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and  hr_empmstr.ENTITY_ID = 'ROAD' and HR_EMPMSTR.BARGUNIT <> '31'

UNION ALL
SELECT
hr_empmstr.id as 'WorkerID'
,'P-Denise Krzeminski' as 'SourceSystem'
,IIF(hr_empmstr.bargunit= 'UK','26',hr_empmstr.bargunit) as 'UnionID'  --forced for R002645 to 26.... it was UK
,'Active No Dues' as 'MembershipType'								--koaHills:CNP448
,ISNULL(hr_empmstr.beg, hr_empmstr.hdt) as 'UnionStartDate'			--koaHills:CNP447
,ISNULL(hr_empmstr.hrdate3, hr_empmstr.hdt) as 'UnionSeniorityDate'	--koaHills:CNP446
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'PENS' 
and not HR_EMPMSTR.BARGUNIT in ('00','31')

order by 1