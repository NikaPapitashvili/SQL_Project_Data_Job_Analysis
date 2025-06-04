/*
Question: What are the most optimal skills to learn (high-demand and high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analytics
*/


with skills_demand as (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        count(job_postings_fact.job_id) as demand_count
    from 
        job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        and salary_year_avg is not NULL
        and job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
),
average_salary as (
    SELECT 
        skills_job_dim.skill_id,   
        round(avg(salary_year_avg), 0) as avg_salary
    from 
        job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        and salary_year_avg is not NULL
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
from
    skills_demand
INNER JOIN average_salary on skills_demand.skill_id = average_salary.skill_id
ORDER BY
    avg_salary DESC,
    demand_count DESC;
    

-- Solving same problem with other way (without CTEs)

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg), 0) as avg_salary
from
    job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    and salary_year_avg is not NULL
    and job_work_from_home = True
group BY
    skills_dim.skill_id
ORDER BY
    avg_salary desc,
    demand_count desc;
