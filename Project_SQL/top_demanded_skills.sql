/*
Question: What are the most in-demand skills for Data Analysts?
- Join job postings to inner join table similar to query 2(top_paying_job_skills)
- Identify the top 5 in-demand skills for a data analyst
- Focus on all job postings
- Why? Retrive the top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers.
*/


SELECT 
    skills,
    count(job_postings_fact.job_id) as demand_count
from 
    job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count desc
LIMIT 5;