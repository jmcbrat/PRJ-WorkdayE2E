select *
from [production_finance].[dbo].hr_empmstr
  RIGHT JOIN [production_finance].[dbo].hr_Family
   ON hr_empmstr.ID = hr_family.id 
	   and left(hr_family.family_tp,3) ='BEN'

select * from [production_finance].[dbo].hr_empmstr
  RIGHT JOIN [production_finance].[dbo].hr_Family
   ON hr_empmstr.ID = hr_family.id 
	   /* NOT TRUE --- and hr_family.enddt = '12/31/2050'*/
		and (not hr_family.enddt < '12/31/2022' or hr_family.enddt is null)
	   and hr_family.FAMILY_TP = 'DEPN'
		and hr_family.RELATION NOT in ('ID','IS')