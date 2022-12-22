--PayRoll_Creditor (USA)

SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,'Creditor' as 'WithholdingOrderTypeID'
,trim(ISNULL(pyd_cdh_dtl.pyd_misc_l,'')) as 'CaseNumber'
,convert(varchar,pyd_cdh_dtl.py_cdh_no)  as 'WithholdingOrderAdditionalOrderNumber'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'OrderDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'ReceivedDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'BeginDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_end, 106),' ','-') as 'EndDate'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/) as 'Company'
,'' as 'Inactive'
,'PERCENTDE' as 'WithholdingOrderAmountType'
,'' as 'WithholdingOrderAmount'
,0.25 as 'WithholdingOrderAmountasPercent'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Biweekly','Monthly') as 'FrequencyID'
,99999999999 as 'TotalDebtAmountRemaining'
,'' as 'MonthlyLimit'
,'' as 'Code(IssuedinReference)'
,'DR-001' as 'DeductionRecipientID'
,'' as 'OriginatingAuthority'
,'' as 'Memo'
,'' as 'Currency'
,'General Creditor' as 'CreditorGarnishmentType'
,'' as 'HeadofHousehold'
,'' as 'NumberofDependents'
,'' as 'WorkerisLaborerorMechanic'
,'' as 'WorkerIncomeisPovertyLevel'
,'' as 'GoodCauseLimitPercent'
,'' as 'WeeklyGrossWages'
,'' as 'ExpectedAnnualEarnings'
,0 as 'FeeAmount#1'
,0 as 'FeePercent#1'
--,'EMPLFEE' as 'FeeTypeID#1'
,'' as 'FeeTypeID#1'
--,'AMOUNT' as 'FeeAmountTypeID#1'
,'' as 'FeeAmountTypeID#1'
,'' as 'DeductionRecipientID#1'
,'' as 'OverrideFeeSchedule#1'
,'' as 'BeginDate#1'
,'' as 'EndDate#1'
,0 as 'FeeMonthlyLimit#1'
,0 as 'FeeAmount#2'
,0 as 'FeePercent#2'
,'' as 'FeeTypeID#2'
,'' as 'FeeAmountTypeID#2'
,'' as 'DeductionRecipientID#2'
,'' as 'OverrideFeeSchedule#2'
,'' as 'BeginDate#2'
,'' as 'EndDate#2'
,0 as 'FeeMonthlyLimit#2'
FROM [production_finance].[dbo].[hr_empmstr]
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2350,2351,2365,2366,2367,2368,2369,2370,
												 2371,2372,2373,2374,2375,2376,2377,2378,2379,
												 2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,
												 2390,2391,2392,2393)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
											  from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
											  where PCH.py_CDH_NO 
												 in(2350,2351,2365,2366,2367,2368,2369,2370,
												 2371,2372,2373,2374,2375,2376,2377,2378,2379,
												 2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,
												 2390,2391,2392,2393) AND PCH.HR_PE_ID = hr_empmstr.ID)
		  AND pyd_cdh_dtl.pyd_end >'04/01/2022'
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id