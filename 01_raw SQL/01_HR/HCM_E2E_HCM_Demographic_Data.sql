/*hr_EMP_Demographic Data*/

SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.mrt = 'M' THEN 'Married_United_States_of_America'
  --WHEN hr_empmstr.mrt = 'D' THEN 'Divorced'
  WHEN (hr_empmstr.mrt = 'S' OR hr_empmstr.mrt = 'W' OR hr_empmstr.mrt = 'D' OR hr_empmstr.mrt = 'U') THEN 'Single_United_States_of_America'
  --WHEN hr_empmstr.mrt = 'W' THEN 'Widowed'
  --WHEN hr_empmstr.mrt = 'U' THEN 'Unknown'
  ELSE 'Unknown'
  END as 'MaritalStatus'	-- koaHills:CNP405

,'' as 'MaritalStatusDate'
,IIf(hr_empmstr.ethnic = 'H','Y','N') as 'HispanicorLatino'
,CASE
   WHEN hr_empmstr.ethnic = 'W' THEN 'White_United_States_of_America'
	WHEN hr_empmstr.ethnic = 'I' THEN 'American_Indian_or_Alaska_Native_United_States_of_America'
	WHEN hr_empmstr.ethnic = 'A' THEN 'Asian_United_States_of_America'
	WHEN hr_empmstr.ethnic = 'B' THEN 'Black_or_African_American_United_States_of_America'
	WHEN hr_empmstr.ethnic = 'H' THEN 'Hispanic_or_Latino_United_States_of_America'
	WHEN hr_empmstr.ethnic = 'N' THEN 'Native_Hawaiian_or_Other_Pacific_Islander_United_States_of_America'
	WHEN hr_empmstr.ethnic = 'O' THEN 'Not_Specified'	--koaHills:CNP404
	WHEN hr_empmstr.ethnic = 'M' THEN 'Two_or_More_Races_United_States_of_America'
END as 'Ethnicity#1'
,'' as 'Ethnicity#2'
,'' as 'Ethnicity#3'
,'' as 'Ethnicity#4'
,'' as 'CitizenshipStatus#1'
,'' as 'CitizenshipStatus#2'
,'' as 'CitizenshipStatus#3'
,'' as 'CitizenshipStatus#4'
,'' as 'PrimaryNationality'
,'' as 'AdditionalNationality#1'
,'' as 'AdditionalNationality#2'
,'' as 'AdditionalNationality#3'
,'' as 'AdditionalNationality#4'
,'' as 'MilitaryStatus#1'
,'' as 'MilitaryServiceType#1'
,'' as 'MilitaryDischargeDate#1'
,'' as 'MilitaryStatus#2'
,'' as 'MilitaryServiceType#2'
,'' as 'MilitaryDischargeDate#2'
,'' as 'MilitaryStatus#3'
,'' as 'MilitaryServiceType#3'
,'' as 'MilitaryDischargeDate#3'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
ORDER BY 1
