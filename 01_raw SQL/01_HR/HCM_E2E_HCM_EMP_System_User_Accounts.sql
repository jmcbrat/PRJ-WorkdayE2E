/*EMP-system-accounts*/

SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,IIF(trim(x.[Assumed Name]) = trim(x.[ID]), 'M-IT','C-IT') as 'SourceSystem'
,x.ad as 'UserName'
,'' as 'Password'
,'' as 'ExemptfromDelegatedAuthentication'
,'' as 'OpenIDConnectInternalIdentifier'
, '' as 'UserLanguage'
FROM [production_finance].[dbo].[hr_empmstr]
	  LEFT JOIN [IT.Macomb_DBA].[dbo].[OneSolution_AD_account] as x
	  on trim(hr_empmstr.id) = x.id
	  and x.Delete_Flag is null
where hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 AND x.ad IS NOT NULL
/* and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) */
/* Rows 2526 */


order by 1

/*select * from [IT.Macomb_DBA].[dbo].[OneSolution_AD_account]
WHERE id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) 
*/