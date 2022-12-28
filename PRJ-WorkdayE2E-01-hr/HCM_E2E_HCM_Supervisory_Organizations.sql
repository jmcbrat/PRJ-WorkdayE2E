/*HR Supervisory Organizations*/

SELECT 
--2 as T_order,
Supervisory_Org.emp_id as 'ManagerEmployeeID'
,'AZ_Org' as 'SourceSystem'
,Supervisory_Org.supervisory_org_id as 'SupervisoryOrganizationID'
,Supervisory_Org.supervisory_org_name as 'SupervisoryOrganizationName'
,Supervisory_Org.supervisory_org_id as 'SupervisoryOrganizationCode'
,case 
  when Supervisory_Org.supervisory_org_id in ('SUP_RETIREE GENERAL','SUP_RETIREE MTB','SUP_RETIREE ROADS','SUP_RETIREE SHERIFF' ) THEN 'Y' 
  ELSE 'N' 
  END as 'JobManagement'
,case 
  when Supervisory_Org.supervisory_org_id in ('SUP_RETIREE GENERAL','SUP_RETIREE MTB','SUP_RETIREE ROADS','SUP_RETIREE SHERIFF' ) THEN 'N' 
  ELSE 'Y' 
  END as 'PositionManagement'
,'Department' as 'SupervisoryOrgSubType'
,CASE
  WHEN  hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN  hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN  hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN  hr_empmstr.department IN ('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN  hr_empmstr.department = 'SHF' THEN 'LOC014'
  WHEN  hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN  hr_empmstr.department IN ('CIR','DCP','PCM','PCW','RMB','CLK') THEN 'LOC019'
  WHEN  hr_empmstr.department = 'JJC' THEN 'LOC020'
  WHEN  hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB'
        ,'MTB','PLN','PRS','RSK','TRS','RETG','RETS','RETR','RETM') THEN 'LOC023'
  WHEN  hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN  hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN  hr_empmstr.department = 'PRK' THEN 'LOC027'
  WHEN  hr_empmstr.department = 'HTH' THEN 'LOC028'
  WHEN  hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN  hr_empmstr.department IN ('MIS','ROAD','COR','ESC') THEN 'LOC035'
  WHEN  hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN  hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN  hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  ELSE hr_empmstr.department
  END as 'WorkLocation'
,Supervisory_Org.superior_org_id as 'SuperiorOrganizationID'
FROM [production_finance].[dbo].[hr_empmstr]
	  RIGHT join [IT.Macomb_dba].[dbo].[Supervisory_Org]
	  on hr_empmstr.id = Supervisory_Org.emp_id 
where /*hr_empmstr.hr_status = 'A'
      and hr_empmstr.ENTITY_ID in ('ROOT','PENS')*/
	((hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in ('ROOT', /*'ROAD',*/ 'PENS'))
 OR
  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT')
  and hr_empmstr.termcode in ('DFRT','DFRC')
  )
 OR 
  (hr_empmstr.hr_status = 'I'
  and hr_empmstr.ENTITY_ID in ('ROOT')
  and hr_empmstr.enddt = '12/31/2014'
  and hr_empmstr.department = 'MTB'
  )
       OR (hr_empmstr.ENTITY_ID in ('ROOT', /*'ROAD',*/'PENS')
	 and hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'
 )
  )
union 
SELECT 
--1,
Supervisory_Org.emp_id as 'ManagerEmployeeID'
,'AZ_Top' as 'SourceSystem'
,Supervisory_Org.supervisory_org_id as 'SupervisoryOrganizationID'
,Supervisory_Org.supervisory_org_Name as 'SupervisoryOrganizationName'
,Supervisory_Org.supervisory_org_id as 'SupervisoryOrganizationCode'
,case 
  when Supervisory_Org.supervisory_org_id in ('SUP_RETIREE GENERAL','SUP_RETIREE MTB','SUP_RETIREE ROADS','SUP_RETIREE SHERIFF' ) THEN 'Y' 
  ELSE 'N' 
  END as 'JobManagement'
,case 
  when Supervisory_Org.supervisory_org_id in ('SUP_RETIREE GENERAL','SUP_RETIREE MTB','SUP_RETIREE ROADS','SUP_RETIREE SHERIFF' ) THEN 'N' 
  ELSE 'Y' 
  END as 'PositionManagement'
,'Department' as 'SupervisoryOrgSubType'
,'LOC_Default' as 'Location'
,Supervisory_Org.superior_org_id as 'SuperiorOrganizationID'
FROM [IT.Macomb_dba].[dbo].[Supervisory_Org]
WHERE Supervisory_Org.emp_id = 'TOP'

UNION ALL 
SELECT 
--1,
Supervisory_Org.emp_id as 'ManagerEmployeeID'
,'AZ_VACANT' as 'SourceSystem'
,Supervisory_Org.supervisory_org_id as 'SupervisoryOrganizationID'
,Supervisory_Org.supervisory_org_Name as 'SupervisoryOrganizationName'
,Supervisory_Org.supervisory_org_id as 'SupervisoryOrganizationCode'
,case 
  when Supervisory_Org.supervisory_org_id in ('SUP_RETIREE GENERAL','SUP_RETIREE MTB','SUP_RETIREE ROADS','SUP_RETIREE SHERIFF' ) THEN 'Y' 
  ELSE 'N' 
  END as 'JobManagement'
,case 
  when Supervisory_Org.supervisory_org_id in ('SUP_RETIREE GENERAL','SUP_RETIREE MTB','SUP_RETIREE ROADS','SUP_RETIREE SHERIFF' ) THEN 'N' 
  ELSE 'Y' 
  END as 'PositionManagement'
,'Department' as 'SupervisoryOrgSubType'
,'LOC_Default' as 'Location'
,Supervisory_Org.superior_org_id as 'SuperiorOrganizationID'
FROM [IT.Macomb_dba].[dbo].[Supervisory_Org]
WHERE Supervisory_Org.emp_id is null
--and Supervisory_Org.emp_id = 'E008620'

order by 1


/*-- had to add this one....
insert into [IT.Macomb_dba].[dbo].[Supervisory_Org]
(Dept,Emp_ID,Position_Number,Emp_Type,Position_Title,SUPERVISORY_ORG_ID,SUPERIOR_ORG_ID,SUPERVISORY_ORG_TITLE)
SELECT Dept,Emp_ID,Position_Number,Emp_Type,Postion_Title,SUPERVISORY_ORG_ID,SUPERIOR_ORG_ID,SUPERVISORY_ORG_TITLE
from [IT.Macomb_dba].[dbo].Supervisory_Org_2205
where emp_id = 'Top'
*/