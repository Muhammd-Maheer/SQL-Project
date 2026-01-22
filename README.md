# Introduction
This project dives into real-world data job market 📊 to explore top-paying and high-demand skills 🔍, uncovering where high demand meets top pay 💰📈. It analyzes trends across job postings to highlight in-demand roles, salary patterns, and opportunities for job seekers and professionals in the tech industry 🚀🔥.

🔍 SQL Queries? Check them out here: [project_sql folder](/project_sql/)

# Background
On a quest to navigate the data analyst job market 🔍, I set out to uncover the top-paying and most in-demand skills. This project also aims to streamline the hunt for others, helping job seekers discover optimal roles and opportunities without getting lost in endless data 🌟

### The Questions I wanted to answer through my SQL queries were:
1. What are the top-paying Data Analyst jobs?
2. What skills are required for these top-paying jobs/
3. What skills are most in demand for Data Analytics?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the job market, I harnessed the power of these key tools:

- **SQL** – the ultimate weapon for digging through data and uncovering insights 🔍.
- **PostgreSQL** – my reliable database engine for storing and managing massive job market datasets 🗄️.
- **Visual Studio Code** – where I crafted, tested, and perfected every SQL query 💻.Git & GitHub** – to track my journey, manage versions, and share my project with the world 🌐.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To Identify the highest-paying roles, I filtered Data Analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in this field.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```
Here's a breakdown of the top Data Analyst Jobs;
- **Wide Salary Range:** Top 10 data roles show a massive pay spread, ranging roughly from $180k to over $600k, showing significant salary potential in the field.
- **Diverse Employers:** High-paying roles span multiple industries, from Google in tech, JP Morgan in finance, to Deloitte in consulting, showing strong demand for data talent everywhere.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within Data Analytics

![Top Paying Roles](assets\Code_Generated_Image.png)
*Bar Graph visualizing the salary of the top 10 salaries for data analysts; Gemini Generated this graph for my SQL query*

### 2. Skills for Top Paying Jobs
To understand what skills are required for top paying jobs, job postings with the skills data, providing insights into what employers value for high compensation roles

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
        LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
Heres a breakdown of the most demanded skills for the top Data Analyst Jobs

- **SQL:** is leading with a bold count of 8.
- **Python:** follows closely with a count of 7.
- **Tableau:** is also highly sought after with a skill count of 6. Other skills like R, Snowflake, Pandas and Excel show varying degrees of demand

![Skills for Top Paying Jobs](assets\top_jobs_skills.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for Data Analysts; Gemini Generated this graph*

### 3. In-Demand Skills for Data Analysts
I wrote this query to Identify the most frequently requested skills in job postings, showing skills that have a high demand.
```sql 
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for Data Analytics 

- The most in-demand data processing skills are **SQL** (7,291 mentions), **Excel** (4,611), and **Python** (4,330), reflecting the strong need for professionals who can collect, clean, and manipulate data efficiently.

- Top visualization tools include **Tableau** (3,745) and **Power BI** (2,609), highlighting the importance of turning raw data into clear, actionable insights for decision-making.

![Most Demanded Skills for Data Analytics](assets\top_jobs_skills.png)

### 4. Skill Based on Salary
I wrote this query to explore the average salaries associated with different skills to show insights on which skills are the highest paying

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top paying skills

- **Data engineering & big-data skills** pay the most
Skills like PySpark, Databricks, Airflow, Kubernetes, and Elasticsearch dominate the top salaries, showing that analysts who can work with large-scale, production data systems earn more.

- **ML & AI-adjacent tools** significantly boost pay
Tools such as DataRobot, Watson, scikit-learn, Pandas, NumPy, and Jupyter indicate that higher-paying roles expect analysts to move beyond reporting into modeling, automation, and advanced analytics.

- **DevOps, cloud, and collaboration tools** signal senior roles
High salaries tied to GitLab, Bitbucket, Jenkins, Linux, GCP, Atlassian suggest top-paying jobs favor analysts who can collaborate with engineers and deploy analytics in real systems, not just dashboards.

![Top Paying Skills for Data Analyst](assets\top_paying_skills.png)

### 5. Most Optimal Skills to Learn
Combining Insights from demand and salary data, I wrote this query to showcase skills that are both high in demand and have high salaries, offering strategic focus for skill development

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING 
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

Here's a breakdown of the Optimal Skills to Learn for Data Analysis Based on both Salary and Demand.
| Skill ID | Skill        | Demand Count | Avg Salary |
|----------|-------------|--------------|------------|
| 8        | go          | 27           | 115,320    |
| 234      | confluence  | 11           | 114,210    |
| 97       | hadoop      | 22           | 113,193    |
| 80       | snowflake   | 37           | 112,948    |
| 74       | azure       | 34           | 111,225    |
| 77       | bigquery    | 13           | 109,654    |
| 76       | aws         | 32           | 108,317    |
| 4        | java        | 17           | 106,906    |
| 194      | ssis        | 12           | 106,683    |
| 233      | jira        | 20           | 104,918    |
| 79       | oracle      | 37           | 104,534    |
| 185      | looker      | 49           | 103,795    |
| 2        | nosql       | 13           | 101,414    |
| 1        | python      | 236          | 101,397    |
| 5        | r           | 148          | 100,499    |
| 78       | redshift    | 16           | 99,936     |
| 187      | qlik        | 13           | 99,631     |
| 182      | tableau     | 230          | 99,288     |
| 197      | ssrs        | 14           | 99,171     |
| 92       | spark       | 13           | 99,077     |
| 13       | c++         | 11           | 98,958     |
| 186      | sas         | 63           | 98,902     |
| 7        | sas         | 63           | 98,902     |
| 61       | sql server  | 35           | 97,786     |
| 9        | javascript  | 20           | 97,587     |


# What I Learned
Throughout this adventure, I turbocharged my SQL skills, diving deep into the world of data and emerging with a sharper, more powerful toolkit than ever before. From wrangling tricky queries to uncovering hidden insights, here’s a snapshot of what I mastered:

- **🧩 Complex Query Crafting** I learned to bend SQL to my will—writing queries that slice, dice, and join data across multiple tables with precision. From subqueries that sneakily fetch hidden info to UNIONs that merge worlds of data, I can now tackle challenges that would make my past self break into a cold sweat.

- **📊 Data Aggregation:** Summing, averaging, and grouping like a pro—this adventure turned me into a master of aggregation. I discovered how to extract meaningful trends from mountains of numbers, transforming raw data into crisp insights that tell a story, not just a bunch of figures.

- **💡 Analytical Wizardry:** Beyond syntax, I learned to think like a true data analyst. Spotting patterns, comparing metrics, and turning data into actionable knowledge became second nature. I can now conjure insights from chaos and predict trends before they even hit the dashboard.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs:** The highest paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest of which is at $650,000

2. **Skills for Top-Paying Jobs:** High-Paying Data Analysts jobs require advanced proficiency in SQL, suggesting its a critical skill for earing a top salary.

3. **Most In-Demand Skills:** SQL is also the most demanded skill in the Data Analyst Job Market thus making it essential for job seekers.

4. **Skills With Higher Salaries:** Specialized skills such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise

5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for Data Analysts to learn to maximize their market value.

### Closing Thoughts
This Project greatly enhanced my SQL skills and provided valuable insights into the Data Analyst Job Market that prove to be helpful in job seeking. The findings from this project serve as a guide for skill development and job search efforts. Aspiring Data Analyst can position themselves better in the competitive job market by focusing on skills that are in high-demand and high-salary . This exploration highlights the importance of continuous learning and adaptation to emerging job trends in the field of Data Analytics.