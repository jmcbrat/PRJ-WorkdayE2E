/*HR_Absence_Leave_of_Absence*/

;with LeaveofAbs_CTE 
AS (select
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'PositionID'
,CASE
	WHEN hr_leavinfo.leav_code = 'EDL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'FSL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IFL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IPL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'ISL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'MIL' THEN  'Military Leave'
	WHEN hr_leavinfo.leav_code = 'PRL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'SKL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'WCL' THEN  'Worker Compensation'
	ELSE hr_leavinfo.leav_code
	END as 'LeaveType'
,'' as 'Reason'
,CASE
WHEN DATEPART(dw,hr_leavinfo.startdt) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_leavinfo.startdt), 106),' ','-')
ELSE ''
END as 'LastDayofWork'
,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') as 'FirstDayofLeave'
,IIF( hr_leavinfo.startdt>hr_leavinfo.estenddt
	,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') 
	,replace(convert(varchar, hr_leavinfo.estenddt, 106),' ','-')) as 'EstimatedLastDayofLeave'
	,'' as 'Comments'
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_leavinfo]
    ON hr_empmstr.id = hr_leavinfo.id
	 and hr_leavinfo.leav_code in ('EDL','FSL','IFL','IPL','ISL','MIL','PRL','SKL','WCL')
	 and hr_leavinfo.apprvdate is not null
	 and hr_leavinfo.startdt is not null
	 and hr_leavinfo.startdt in (SELECT max(l.startdt) from [production_finance].[dbo].[hr_leavinfo] l Where hr_leavinfo.id = l.id and hr_leavinfo.leav_code = l.leav_code)
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
 )
 SELECT * 
 FROM LeaveofAbs_CTE
 where LeaveofAbs_CTE.firstdayOfLeave in (select max(y.firstdayOfLeave) FROM (
select
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'PositionID'
,CASE
	WHEN hr_leavinfo.leav_code = 'EDL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'FSL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IFL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IPL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'ISL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'MIL' THEN  'Military Leave'
	WHEN hr_leavinfo.leav_code = 'PRL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'SKL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'WCL' THEN  'Worker Compensation'
	ELSE hr_leavinfo.leav_code
	END as 'LeaveType'
,'' as 'Reason'
,CASE
WHEN DATEPART(dw,hr_leavinfo.startdt) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_leavinfo.startdt), 106),' ','-')
ELSE ''
END as 'LastDayofWork'
,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') as 'FirstDayofLeave'
,IIF( hr_leavinfo.startdt>hr_leavinfo.estenddt
	,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') 
	,replace(convert(varchar, hr_leavinfo.estenddt, 106),' ','-')) as 'EstimatedLastDayofLeave'
	,'' as 'Comments'
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_leavinfo]
    ON hr_empmstr.id = hr_leavinfo.id
	 and hr_leavinfo.leav_code in ('EDL','FSL','IFL','IPL','ISL','MIL','PRL','SKL','WCL')
	 and hr_leavinfo.apprvdate is not null
	 and hr_leavinfo.startdt is not null
	 and hr_leavinfo.startdt in (SELECT max(l.startdt) from [production_finance].[dbo].[hr_leavinfo] l Where hr_leavinfo.id = l.id and hr_leavinfo.leav_code = l.leav_code)
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
) y 
where LeaveofAbs_CTE.Workerid = y.workerid and y.leavetype = LeaveofAbs_CTE.leavetype ) 
order by 1