
SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs,
    CASE
        WHEN company_job_count.total_jobs < 10 THEN 'Small'
        WHEN company_job_count.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
        END AS company_size
FROM
    company_dim
LEFT JOIN   (  SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id ) AS company_job_count ON company_job_count.company_id = company_dim.company_id
LIMIT 100;