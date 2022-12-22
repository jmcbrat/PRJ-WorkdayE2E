--PayRoll_Student Loan (USA)
-- deferement started on March 20, 2020

SELECT
--hr_empmstr.hr_status,
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,'STUDENT' as 'WithholdingOrderTypeID'
,trim(pyd_cdh_dtl.pyd_misc_l) as 'CaseNumber'
,convert(varchar,pyd_cdh_dtl.py_cdh_no)  as 'WithholdingOrderAdditionalOrderNumber'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'OrderDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'ReceivedDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'BeginDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_end, 106),' ','-') as 'EndDate'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'County of Macomb',
		 'Macomb County Employees Retirement System') as 'Company'
,'Y' as 'Inactive'
,'PERCENTDE' as 'WithholdingOrderAmountType'
,'' as 'WithholdingOrderAmount'
,pyd_cdh_dtl.pyd_spec_cd01 as 'WithholdingOrderAmountasPercent'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Biweekly','Monthly') as 'FrequencyID'
,99999999999 as 'TotalDebtAmountRemaining'
,'' as 'MonthlyLimit'
,'Federal' as 'Code(IssuedinReference)'
,'DR-001' as 'DeductionRecipientID'
,'' as 'OriginatingAuthority'
,'' as 'Memo'
,'' as 'Currency'
,'' as 'DepartmentofEducationStudentLoan'
,0 as 'FeeAmount#1'
,0 as 'FeePercent#1'
,'EMPLFEE_PER' as 'FeeTypeID#1'
,'AMOUNT' as 'FeeAmountTypeID#1'
,'N/A' as 'DeductionRecipientID#1'
,'' as 'OverrideFeeSchedule#1'
,'' as 'BeginDate#1'
,'' as 'EndDate#1'
,'' as 'FeeMonthlyLimit#1'
,0 as 'FeeAmount#2'
,0 as 'FeePercent#2'
,'N/A' as 'FeeTypeID#2'
,'AMOUNT' as 'FeeAmountTypeID#2'
,'N/A' as 'DeductionRecipientID#2'
,'' as 'OverrideFeeSchedule#2'
,'' as 'BeginDate#2'
,'' as 'EndDate#2'
,0 as 'FeeMonthlyLimit#2'
--,pyd_cdh_dtl.*
FROM [production_finance].[dbo].[hr_empmstr]
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2357,2358)
		  and pyd_cdh_dtl.pyd_end = '12/31/2050'
		  /*AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
											  from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
											  where PCH.py_CDH_NO 
												 in(2357,2358) 
												 AND PCH.HR_PE_ID = hr_empmstr.ID)*/
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'

  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id
