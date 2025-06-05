# Introduction
Dive into job postings database focusing on Data Analyst roles. This project explores top-paying jobs, in-demand skills and where high demand meets high salary in Data Analytics.

See sql queries here: [Project_SQL folder](/Project_SQL/)

### Questions I wanted to answer through my SQL queries:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

### Tools I Used
To dive into the data analyst job market, I used several tools:

- **SQL:** The main tool I used, that allowed me to select data from enormous databases.
- **PostreSQL:** The database management system.
- **Visual Studio Code:** Tool for database management and executing SQL queries.
- **Git & GitHub:** Tool for version control and sharing my SQL scripts.

## The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market.

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying oportinities in the field.

```sql
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
```

### Result:
| Job ID  | Job Title                                       | Company Name                            | Location | Schedule  | Average Salary | Posted Date         |
| ------- | ----------------------------------------------- | --------------------------------------- | -------- | --------- | -------------------- | ------------------- |
| 226942  | Data Analyst                                    | Mantys                                  | Anywhere | Full-time | 650,000              | 2023-02-20 15:13:33 |
| 547382  | Director of Analytics                           | Meta                                    | Anywhere | Full-time | 336,500              | 2023-08-23 12:04:42 |
| 552322  | Associate Director- Data Insights               | AT\&T                                   | Anywhere | Full-time | 255,829.5            | 2023-06-18 16:03:12 |
| 99305   | Data Analyst, Marketing                         | Pinterest Job Advertisements            | Anywhere | Full-time | 232,423              | 2023-12-05 20:00:40 |
| 1021647 | Data Analyst (Hybrid/Remote)                    | Uclahealthcareers                       | Anywhere | Full-time | 217,000              | 2023-01-17 00:17:23 |
| 168310  | Principal Data Analyst (Remote)                 | SmartAsset                              | Anywhere | Full-time | 205,000              | 2023-08-09 11:00:01 |
| 731368  | Director, Data Analyst - HYBRID                 | Inclusively                             | Anywhere | Full-time | 189,309              | 2023-12-07 15:00:13 |
| 310660  | Principal Data Analyst, AV Performance Analysis | Motional                                | Anywhere | Full-time | 189,000              | 2023-01-05 00:00:25 |
| 1749593 | Principal Data Analyst                          | SmartAsset                              | Anywhere | Full-time | 186,000              | 2023-07-11 16:00:05 |
| 387860  | ERM Data Analyst                                | Get It Recruit - Information Technology | Anywhere | Full-time | 184,000              | 2023-06-09 08:01:04 |

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employesr value for high-compensation roles.

```sql
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
Limit 10;
```
### Result: 
| Job ID | Job Title                          | Company | Average Salary | Skill      |
| ------ | ---------------------------------- | ------- | -------------------- | ---------- |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | SQL        |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | Python     |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | R          |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | Azure      |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | Databricks |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | AWS        |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | Pandas     |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | PySpark    |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | Jupyter    |
| 552322 | Associate Director - Data Insights | AT\&T   | 255,829.5            | Excel      |

### 3. In-Demand Skills for Data Analysts
This query helped ideltify the skills most frequently requested in job postings, directing focus to areas with high demand. 

```sql
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
```
### Result
| Skill    | Demand Count |
| -------- | ------------ |
| SQL      | 92,628       |
| Excel    | 67,031       |
| Python   | 57,326       |
| Tableau  | 46,554       |
| Power BI | 39,468       |

### 4. Skills Based on Salary
Exploring average salaries associated with different skills and revealed whick skills are the highest paying.

```sql
SELECT 
    skills,
    round(avg(salary_year_avg), 0) as average_salary
from 
    job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    and salary_year_avg is not NULL
GROUP BY
    skills
ORDER BY    
    average_salary DESC
Limit 10;
```
### Result
| Skill     | Average Salary |
| --------- | -------------------- |
| SVN       | 400,000              |
| Solidity  | 179,000              |
| Couchbase | 160,515              |
| DataRobot | 155,486              |
| GoLang    | 155,000              |
| MXNet     | 149,000              |
| dplyr     | 147,633              |
| VMware    | 147,500              |
| Terraform | 146,734              |
| Twilio    | 138,500              |

### 5. The Most Optimal Skills to Learn
This query is aimed to pinpoint skills that are both in high demand and have high salaries, offering a stategic focus for skill development.

```sql
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
    demand_count desc
Limit 10;
```

### Result:

| Skill ID | Skill         | Demand Count | Average Salary (USD) |
| -------- | ------------- | ------------ | -------------------- |
| 95       | PySpark       | 2            | 208,172              |
| 218      | Bitbucket     | 2            | 189,155              |
| 65       | Couchbase     | 1            | 160,515              |
| 85       | Watson        | 1            | 160,515              |
| 206      | DataRobot     | 1            | 155,486              |
| 220      | GitLab        | 3            | 154,500              |
| 35       | Swift         | 2            | 153,750              |
| 102      | Jupyter       | 3            | 152,777              |
| 93       | Pandas        | 9            | 151,821              |
| 59       | Elasticsearch | 1            | 145,000              |


# Conclusion
This project deveoped my SQL skills and provided valuable insights into the Data Analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts.