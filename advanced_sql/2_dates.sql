SELECT 
    c.name,
    EXTRACT(QUARTER FROM j.job_posted_date) AS quarter,
    EXTRACT(YEAR FROM j.job_posted_date)
FROM 
    job_postings_fact AS j
    JOIN company_dim AS c
    ON j.company_id = c.company_id
WHERE
    j.job_health_insurance = TRUE
    AND EXTRACT(QUARTER FROM j.job_posted_date) = 2
    AND EXTRACT(YEAR FROM j.job_posted_date) = 2023
LIMIT
    100;