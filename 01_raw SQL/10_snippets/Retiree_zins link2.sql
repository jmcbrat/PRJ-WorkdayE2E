select R_ID, Z_ID 
from (SELECT h.[ENTITY_ID],h.[ID] as R_ID,left(h.notes,7) as ZNotes_id
		FROM [production_finance].[dbo].[hr_empmstr] h
		where h.entity_id ='PENS' and left(h.id,1) = 'R'
			 and Left(h.notes,1) = 'Z' and h.hr_status = 'A') as R
	 inner join 
		(SELECT h2.[ENTITY_ID],h2.[ID] as Z_ID,left(h2.notes,7) as RNotes_id
		FROM [production_finance].[dbo].[hr_empmstr] h2
		where h2.entity_id ='ZINS' and left(h2.id,1) = 'Z'
			 and Left(h2.notes,1) = 'R' and h2.hr_status = 'A' ) as Z 
	ON r.ZNotes_id = z.Z_ID AND r.R_ID = Z.RNotes_id and r.R_ID is not null
	where z.z_id in (
	'Z000687     '
,'Z003196     '
,'Z001853     '
,'Z002602     '
,'Z005278     '
,'Z003001     '
,'Z003463     '
,'Z002378     '
,'Z003782     '
,'Z003550     '
,'Z002747     '
,'Z002535     '
,'Z003316     '
,'Z004484     '
,'Z003438     '
)
--	select top 1000 * from [production_finance].[dbo].[hr_empmstr]