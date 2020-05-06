SELECT * FROM customer c
OUTER APPLY(SELECT top 1 * FROM purchase pi 
WHERE pi.customer_id = c.Id order by pi.Id desc) AS [LastPurchasePrice]


select t.applicantId, a.last_name,a.first_name, t.created, t.description, t.usr_id --, t.actionId, t.progressId
from hr_app_tracking t
inner join (
    select applicantId, max(created) as MaxDate
    from hr_app_tracking
    group by applicantId
) tm on t.applicantId = tm.applicantId 
join hr_app_applicant as a on t.applicantId = a.id
and t.created = tm.MaxDate
order by t.created desc
