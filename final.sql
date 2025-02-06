--1.What museums have the highest proportion of cubist paintings? 

select 
	m.name, 
	w.style,count(w.*) as tot_painting ,
	m.museum_id,count(w.style) * 100.0/ (select count(*) from public.work where work.museum_id = m.museum_id) as proportion_Cubist
from public.work w
inner join public.museum m on w.museum_id = m.museum_id
where w.style like 'Cubis%'
group by 1,2,4
order by 5 desc

-- What other styles of art do these museums typically display?

select m.name,  m.museum_id, w.style,count(*) as total_painting
from public.work w
inner join public.museum m on w.museum_id = m.museum_id
where m.museum_id in (61, 30, 34)
group by m.name,2,3
order by 1,4 desc

-- 2. Which artists have their work displayed in museums in many different countries?

select a.full_name, count(distinct(m.country)) as num_country, w.artist_id
from public.museum m 
inner join public.work w on m.museum_id = w.museum_id
inner join public.artist a on w.artist_id = a.artist_id
group by 1, 3
having count(distinct(m.country)) > 1
order by 2 desc

-- 3. Create a table that shows the most frequently painted subject for each style of painting, 
-- a. how many paintings there were for the most frequently painted subject in that style, 
-- b. how many paintings there are in that style overall, and the percent of paintings in that style with the most frequent subject. 
-- c. Exclude cases where there is no information on the subject of the painting.


WITH style_subject_counts AS (
    SELECT 
        w.style, s.subject, COUNT(s.subject) AS subject_count 
    FROM public.subject s 
    INNER JOIN public.work w ON s.work_id = w.work_id
    WHERE s.subject IS NOT NULL 
    GROUP BY w.style, s.subject
),
style_totals AS (
    SELECT style, SUM(subject_count) AS total_paintings
    FROM style_subject_counts
    GROUP BY style
),
most_freq_style AS (
    SELECT s.style, s.subject, s.subject_count, t.total_paintings,
        (CAST(s.subject_count AS decimal) / t.total_paintings * 100) AS percentage
    FROM style_subject_counts s
    INNER JOIN style_totals t ON s.style = t.style
    WHERE (s.style, s.subject_count) IN (
        SELECT style, MAX(subject_count) 
        FROM style_subject_counts 
        GROUP BY style
    )
)
SELECT 
    style, subject, subject_count, total_paintings, percentage
FROM most_freq_style
ORDER BY 1
