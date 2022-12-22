--Pay_PayRoll_Local Home City Tax Elections

SELECT
trim(hr_empmstr.id)  as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/) as 'Company'
,'01-Jan-2022' /*IIF(pyd_cdh_dtl.pyd_beg<hr_empmstr.hdt
    ,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')
    ,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-'))*/ as 'EffectiveAsOf'
,CASE
   WHEN pyd_cdh_dtl.py_CDH_NO = 2104 THEN '2665820'
	WHEN pyd_cdh_dtl.py_CDH_NO = 2106 THEN '2622000'
	WHEN pyd_cdh_dtl.py_CDH_NO = 2108 THEN '2665440'
	WHEN pyd_cdh_dtl.py_CDH_NO = 2111 THEN '2636280'
	ELSE ''
 END as 'PayrollLocalCityTaxAuthorityCode'
,'' as 'NumberofAllowances'
,'' as 'AdditionalAmount'
,'' as 'ExemptIndicatorPennsylvania'
,'' as 'ConstantText'
,'' as 'Inactive'
FROM [production_finance].[dbo].[hr_empmstr]
	right JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2104,2106,2108,2111)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2104,2106,2108,2111) AND PCH.HR_PE_ID = hr_empmstr.ID)
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id
