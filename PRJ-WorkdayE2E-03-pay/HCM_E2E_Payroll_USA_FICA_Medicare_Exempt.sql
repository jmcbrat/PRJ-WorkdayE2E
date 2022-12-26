--Pay_Payroll_FICA Medicare Exempt

SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/) as 'Company'
,'' as 'PositionID'
,'' as 'AllPositionsExempt'
,CASE
  WHEN pyd_cdh_dtl.pyd_beg<hr_empmstr.hdt THEN replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')
  WHEN pyd_cdh_dtl.pyd_beg>=hr_empmstr.hdt THEN replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-')
  ELSE hr_empmstr.hdt
  END as 'EffectiveAsOf'
,'' as 'ApplyToWorker'
-- steve changed,IIF(pyd_cdh_dtl.pyd_end = '12/31/2050','N','Y') as 'R-ExemptfromMedicare'
, IIF(entity_id = 'ROOT'
and pyd_cdh_dtl.pyd_st = 'I'
  AND pyd_cdh_dtl.pyd_end = '12/31/2050'
  ,'Y'
  ,'Y')  as 'ExemptfromMedicare'
,'Other' as 'MedicareExemptionReason'
FROM [production_finance].[dbo].[hr_empmstr]
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
			and pyd_cdh_dtl.py_CDH_NO in(1103,2103)
			AND (pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
											from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
											where PCH.py_CDH_NO in(1103,2103) 
											  AND PCH.HR_PE_ID = pyd_cdh_dtl.HR_PE_ID)
				OR pyd_cdh_dtl.pyd_beg is null and pyd_cdh_dtl.HR_PE_ID in ('E006780','E022043','E002810','E021059'))
			and pyd_cdh_dtl.HR_PE_ID in ('E002629','E002767','E002810','E003209','E003302','E003653'
												 ,'E003961','E004988','E006402','E006780','E006998','E007158'
												 ,'E016804','E017697','E019535','E019820','E021059','E022043') 
WHERE hr_empmstr.entity_id in ('ROOT','ROAD')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST')
	 OR HR_EMPMSTR.ID in ( 'E002810','E006780','E021059'))  --forced
order by 1
