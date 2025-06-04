/*
Question: Whar are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on the job postings with specified salaries (remove nulls).
*/


SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM
    job_postings_fact
LEFT JOIN company_dim on company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst'
    and job_location = 'Anywhere'
    and salary_year_avg is not NULL
ORDER BY
    salary_year_avg desc
LIMIT 10;