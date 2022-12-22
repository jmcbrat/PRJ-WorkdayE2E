--PayRoll_Federal Tax Levy (USA)

SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,'FEDLEVY' as 'WithholdingOrderTypeID'
,trim(pyd_cdh_dtl.pyd_misc_l) as 'CaseNumber'
,convert(varchar,pyd_cdh_dtl.py_cdh_no)  as 'WithholdingOrderAdditionalOrderNumber'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'OrderDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'ReceivedDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'BeginDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_end, 106),' ','-') as 'EndDate'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/) as 'Company'
,'' as 'Inactive'
,'AMT' as 'WithholdingOrderAmountType'
,convert(numeric(10,2),convert(numeric(10,2),pyd_cdh_dtl.pyd_amt)/100)  as 'WithholdingOrderAmount'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Biweekly','Monthly') as 'FrequencyID'
,99999999999 as 'TotalDebtAmountRemaining'
,'FEDERAL' as 'Code(IssuedinReference)'
,'DR-001' as 'DeductionRecipientID'
,'' as 'Memo'
,'' as 'Currency'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'TaxLevySignedPart3Date'
,'' as 'PayrollMaritalStatusReference'
,'' as 'PersonalExemptions'
,'' as 'AdditionalExemptions65orBlind'
,'' as 'ExemptionAmountOverride'
,'' as 'ExemptionFrequency'
,'' as 'TaxLevyTerminationDate'
,'' as 'DependentName'
,'' as 'DependentIdentificationNumber'
,'' as 'LockTaxElections'
,'' as 'LoadBaselineRestrictions'
,'' as 'FeeAmount#1'
,'' as 'FeePercent#1'
,'' as 'FeeTypeID#1'
,'' as 'FeeAmountTypeID#1'
,'' as 'DeductionRecipientID#1'
,'' as 'OverrideFeeSchedule#1'
,'' as 'BeginDate#1'
,'' as 'EndDate#1'
,'' as 'FeeMonthlyLimit#1'
,'' as 'FeeAmount#2'
,'' as 'FeePercent#2'
,'' as 'FeeTypeID#2'
,'' as 'FeeAmountTypeID#2'
,'' as 'DeductionRecipientID#2'
,'' as 'OverrideFeeSchedule#2'
,'' as 'BeginDate#2'
,'' as 'EndDate#2'
,'' as 'FeeMonthlyLimit#2'
FROM [production_finance].[dbo].[hr_empmstr]
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
	  AND pyd_cdh_dtl.py_CDH_NO in(2458,2461,2462)
	  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
										  from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
										  where PCH.py_CDH_NO 
											 in(2458,2461,2462) 
											 AND PCH.HR_PE_ID = hr_empmstr.ID)
	  AND pyd_cdh_dtl.pyd_end >'04/01/2022'
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id
