--Pay_PayRoll_Local Work City Tax Elections


SELECT 
trim(hr_empmstr.id)  as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/)  as 'Company'
,'01-Jan-2022' as 'EffectiveAsOf'
,CASE
   WHEN pyd_cdh_dtl.py_CDH_NO = 2105 THEN '2665820'
	WHEN pyd_cdh_dtl.py_CDH_NO = 2107 THEN '2622000'
	WHEN pyd_cdh_dtl.py_CDH_NO = 2109 THEN '2665440'
	ELSE '0'
 END as 'PayrollLocalCityTaxAuthorityCode'
,'' as 'NumberofAllowances(Michigan)'
,'' as 'ConstantPercent(Michigan)'
,'' as 'ExemptIndicator(Michigan,Pennsylvania)'
,'' as 'ConstantText'
,'' as 'PreviousEmployerDeductedAmount(Pennsylvania)'
,'' as 'PrimaryEITPennsylvania'
,'' as 'NotSubjecttoEITPennsylvania'
,'' as 'AdditionalAmount'
,'' as 'LowIncomeThreshold'
,'' as 'CurrencyCode'
,'' as 'Inactive'
FROM [production_finance].[dbo].[hr_empmstr]
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
	  AND pyd_cdh_dtl.py_CDH_NO in(2105,2107,2109)
	  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2105,2107,2109) AND PCH.HR_PE_ID = hr_empmstr.ID)
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E003542')
  ORDER BY hr_empmstr.id
