/*
Question: What skills are required for the top-paying Data Analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for those roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries

*/


WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
    LIMIT 10
    )

select 
    top_paying_jobs.*,
    skills_dim.skills
from 
    top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg desc