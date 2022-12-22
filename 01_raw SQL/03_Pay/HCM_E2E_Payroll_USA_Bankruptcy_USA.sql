--PayRoll_Bankruptcy (USA)


SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
--hr_empmstr.entity_id = ROOT only as 'SourceSystem'
,'BANKRUPTCY' as 'WithholdingOrderTypeID'
,ISNULL(pyd_cdh_dtl.pyd_misc_l,right(datepart(YEAR,pyd_cdh_dtl.pyd_beg),2)+'-'+right(trim(hr_empmstr.id),len(trim(hr_empmstr.id))-1)) as 'CaseNumber'
,convert(varchar,pyd_cdh_dtl.py_cdh_no)  as 'WithholdingOrderAdditionalOrderNumber'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'OrderDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'ReceivedDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'BeginDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_end, 106),' ','-') as 'EndDate'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/) as 'Company'
,'N' as 'Inactive'
,'AMT' as 'WithholdingOrderAmountType'
,convert(numeric(10,2),convert(numeric(10,2),pyd_cdh_dtl.pyd_amt)/100) as 'WithholdingOrderAmount'
,'' as 'WithholdingOrderAmountasPercent'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Biweekly','Monthly') as 'FrequencyID'
,99999999999 as 'TotalDebtAmountRemaining'
,'' as 'MonthlyLimit'
,'FEDERAL' as 'Code(IssuedinReference)'
,'DR-001' as 'DeductionRecipientID'
,'' as 'OriginatingAuthority'
,'' as 'Memo'
,'' as 'Currency'
,'Y' as 'Chapter13'
,'' as 'Chapter7'
,'' as 'FeeAmount#1'
,'' as 'FeePercent#1'
--,'EMPLFEE_PER' as 'FeeTypeID#1'
,'' as 'FeeTypeID#1'
--,'AMOUNT' as 'FeeAmountTypeID#1'
,'' as 'FeeAmountTypeID#1'
,'' as 'DeductionRecipientID#1'
,'' as 'OverrideFeeSchedule#1'
,'' as 'BeginDate#1'
,'' as 'EndDate#1'
,0 as 'FeeMonthlyLimit#1'
,'' as 'FeeAmount#2'
,'' as 'FeePercent#2'
,'' as 'FeeTypeID#2'
,'' as 'FeeAmountTypeID#2'
,'' as 'DeductionRecipientID#2'
,'' as 'OverrideFeeSchedule#2'
,'' as 'BeginDate#2'
,'' as 'EndDate#2'
,'' as 'FeeMonthlyLimit#2'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Biweekly','Monthly') as 'WithholdingOrderWithholdingFrequency'
FROM [production_finance].[dbo].[hr_empmstr]
	LEFT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2356,2361)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2356,2361) AND PCH.HR_PE_ID = hr_empmstr.ID)
		  AND pyd_cdh_dtl.pyd_end ='12/31/2050'
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT')
  AND hr_empmstr.hr_status = 'A'
  AND pyd_cdh_dtl.pyd_amt >0
  --AND ID in ('E003542')
  -- stop date 
  ORDER BY hr_empmstr.id