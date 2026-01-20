SELECT 
    salary_year_avg,
    job_title_short,
    job_location,
    CASE
    WHEN salary_year_avg > 79000 THEN 'High'
    WHEN salary_year_avg > 59000 THEN 'Standard'
    ELSE 'Low'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg ASC
LIMIT   
    100;