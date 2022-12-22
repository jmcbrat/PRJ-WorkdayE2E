/*
Macomb_Accounting_Template_Business Asset_V1Sean.xlsx]
TabName: Beginning_Balances_as_AJs
*/
SELECT
 glt_trns_dtl.GLT_BATCH_ID as 'AccountingJournalID'
,'"Dave Stiteler, Alex Ryder"' as 'SourceSystem'
,'' as 'JournalNumber'
,'C0001' as 'CompanyOrganization-AccountingJournal'
,'USD' as 'CurrencyCode-AccountingJournal'
,'Actuals' as 'LedgerType'
,'' as 'BookCode'
,case when glk_key_mstr.GLK_SEL_CODE07 = 'DEC' then '31-DEC-' + cast(year(getdate())-2 as varchar) when glk_key_mstr.GLK_SEL_CODE07 = 'JUN' then '30-JUN-' + cast(year(getdate())-1 as varchar) when glk_key_mstr.GLK_SEL_CODE07 = 'SEP' then '30-SEP-' + cast(year(getdate())-1 as varchar) end as 'AccountingDate'
,0 as 'CreateReversal'
,0 as 'ReversalDate'
,'Beginning_Balance' as 'JournalSource'
,'2022 Beginning Balance' as 'JournalEntryMemo'
,glt_trns_dtl.GLT_GL_KEY as 'ExternalReferenceID'
,'' as 'AdjustmentJournal'
,'' as 'BalancingWorktag'
,ROW_NUMBER() OVER (PARTITION BY glt_trns_dtl.GLT_BATCH_ID ORDER BY glt_trns_dtl.GLT_BATCH_ID) as 'LineOrder'
,'' as 'CompanyOrganization-JournalLine'
,glt_trns_dtl.GLT_GL_KEY as 'LedgerAccountReference'
,'' as 'LedgerAccountSet'
,'' as 'AlternateLedgerAccountReference'
,'' as 'AlternateLedgerAccountSet'
,glt_trns_dtl.GLT_DR as 'DebitAmount'
,glt_trns_dtl.GLT_CR as 'CreditAmount'
,'USD' as 'LineCurrencyCode'
,glt_trns_dtl.GLT_DR as 'LedgerDebitAmount'
,glt_trns_dtl.GLT_CR as 'LedgerCreditAmount'
,'' as 'Quantity'
,'' as 'UnitofMeasure'
,'' as 'Quantity#2'
,'' as 'UnitofMeasure#2'
,'Beginning Balance' as 'Memo'
,'' as 'JournalLineExternalReferenceID'
,isnull(CW1.WDCostCenter,'') as 'Worktag-1'
,isnull(CW2.WDSpendCategory,'') as 'Worktag-2'
,isnull(CW3.WDFundID,'') as 'Worktag-3'
,'' as 'Worktag-4'
,'' as 'Worktag-5'
,'' as 'Worktag-6'
,'' as 'Worktag-7'
,'' as 'Worktag-8'
,'' as 'Worktag-9'
,'' as 'Worktag-10'
,'' as 'Worktag-11'
,'' as 'Worktag-12'
,'' as 'Worktag-13'
,'' as 'Worktag-14'
,'' as 'Worktag-15'
,'' as 'Worktag-16'
,'' as 'Worktag-17'
,'' as 'Worktag-18'
,'' as 'Worktag-19'
,'' as 'Worktag-20'
,'' as 'Worktag-21'
,'' as 'Worktag-22'
,'' as 'Worktag-23'
,'' as 'Worktag-24'
,'' as 'Worktag-25'
into #tempaccountBal
from [production_finance].[dbo].[glt_trns_dtl]
RIGHT JOIN [production_finance].[dbo].[glk_key_mstr]
	ON glt_trns_dtl.glt_gl_key = glk_key_mstr.glk_key
LEFT JOIN [it.macomb_dba].[dbo].[CrosswalksOS Orgkey to WD CC] CW1
	ON glk_key_mstr.glk_key = CW1.OSORGKEY
	AND glk_key_mstr.GLK_GRP_PART07 = CW1.OSPart7
LEFT JOIN [it.macomb_dba].[dbo].[CrosswalksObjecttoLedgerCd_SpendCat] CW2
	ON glt_trns_dtl.GLT_GL_OBJ = CW2.ONESolutionObject
LEFT JOIN [it.macomb_dba].[dbo].[CrosswalksCrosswalks] CW3
	ON glk_key_mstr.glk_key = CW3.OSORGKEY
WHERE glt_trns_dtl.glt_date BETWEEN CASE
	WHEN glk_key_mstr.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
	WHEN glk_key_mstr.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
	WHEN glk_key_mstr.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
END AND getdate()
order by glt_trns_dtl.GLT_BATCH_ID, glt_trns_dtl.unique_id

-- Joe added the following
SELECT * FROM #tempaccountBal
WHERE AccountingJournalID not in (
select AccountingJournalID /*, sum(DebitAmount),Sum(CreditAmount) */
from  #tempaccountBal
group by AccountingJournalID
having sum(DebitAmount) <> Sum(CreditAmount)
)

DROP TABLE dbo.[#tempaccountBal]
