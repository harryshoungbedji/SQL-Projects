-- Let's see the data 
SELECT * 
FROM ibm_hr_attrition_analysis
LIMIT 5;

-- The data has been partialy clean in excel already so not much needs to be done at this point. 
DESCRIBE ibm_hr_attrition_analysis;

-- What is the gender distribution within the company
-- From the data 60% (882 out of 1470) of the employee identify as male and 40% (588 out of 1470) as female.
WITH gender_count as (
SELECT gender, 
count(*) AS head_Count
FROM ibm_hr_attrition_analysis
GROUP BY gender 
),
tot_numb_employee AS (
	SELECT count(*) AS tot_count
    FROM ibm_hr_attrition_analysis
)
SELECT 
Gender, 
head_count,
(head_count / tot_count) * 100 as percentage
from  gender_count,
tot_numb_employee;

-- How many people have a college degree/seperate by education level
-- At this point I realized that I replaced some education with doctorate degree as masters, 
-- For the purpose of simplicity i will this this error as is but keep in mind tha t the data will be inacurate for this columns
SELECT 
Education,
Gender,
count(Gender) AS Count
FROM ibm_hr_attrition_analysis
GROUP BY
Gender,
Education
ORDER by 1;


-- Counting the education level for each department
SELECT 
MaritalStatus,
Department,
Education,
count(*) as Count
FROM ibm_hr_attrition_analysis
GROUP BY 
Education,
Department,
MaritalStatus
ORDER BY 
Department;

-- How does performance vary by gender age group
-- Let's see the min and max age from the columns 
SELECT 
min(age),
max(age)
FROM ibm_hr_attrition_analysis;

-- The MIN age is 18 and Max is 60
SELECT 
CASE 
	WHEN AGE BETWEEN 18 AND 29 THEN '18-29'
	WHEN AGE BETWEEN 30 AND 39 THEN '30-39'
	WHEN AGE BETWEEN 40 AND 49 THEN '40-49'
	WHEN AGE BETWEEN 50 AND 59 THEN '50-59'
	ELSE '60+'
END AS age_group,Attrition, PerformanceRating, Gender, count(*) as count
FROM ibm_hr_attrition_analysis
GROUP BY age_group, PerformanceRating,Gender, Attrition
order by 3;

-- Let's see the attrition rate by department
SELECT 
	Department, 
    count(*) as Tot_employees,
    sum(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as Count_tttrition,
    (SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) / COUNT(*)) * 100 as Attrition_rate
    FROM ibm_hr_attrition_analysis
    GROUP BY Department
    ORDER BY Department;
 
-- Let's see the attrition rate by Education
SELECT 
	Education, 
    count(*) as Tot_employees,
    sum(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as Count_tttrition,
    (SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) / COUNT(*)) * 100 as Attrition_rate
    FROM ibm_hr_attrition_analysis
    GROUP BY Education
    ORDER BY Education