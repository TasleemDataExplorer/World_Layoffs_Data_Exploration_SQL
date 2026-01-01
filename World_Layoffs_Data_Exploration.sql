select *
from layoffs_staging_remodup;

#1 overall Maximum Layoff & Layoff Percentage

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging_remodup;

#2 Maximum layoff event per comapny

select company, max(total_laid_off)
from layoffs_staging_remodup
group by company
order by 2 desc;

#3 Companies with 100% workforce laid off

select *
from layoffs_staging_remodup
where percentage_laid_off = 1;

#4 Companies with Partial layoffs

select *
from layoffs_staging_remodup
where percentage_laid_off < 1
or percentage_laid_off > 1
;

#5 Total Layoffs per company

select company, sum(total_laid_off)
from layoffs_staging_remodup
group by company
order by sum(total_laid_off) desc;

#6 Largest layoff events with dates

select company, total_laid_off, `date`
from layoffs_staging_remodup
order by 2 desc;

#7 Layoff timeline range

select min(`date`), max(`date`) 
from layoffs_staging_remodup;

#8 Layoffs by industry

select industry, sum(total_laid_off)
from layoffs_staging_remodup
group by industry
order by sum(total_laid_off) desc;

#9 Layoffs by country

select country, sum(total_laid_off)
from layoffs_staging_remodup
group by country
order by sum(total_laid_off) desc;

#10 Country wise layoff overtime

select country, `date`,sum(total_laid_off)
from layoffs_staging_remodup
group by `date`, country
order by 2 desc;

#11 Layoffs yearly

select  year(`date`) , sum(total_laid_off)
from layoffs_staging_remodup
group by year(`date`)
order by 2 desc;

#12 Monthly layoffs trends

select substring(`date`,1,7) as month,sum(total_laid_off)
from layoffs_staging_remodup
group by month
order by 1 desc;

#13 Rolling_total of Layoffs over time

with rolling_total as
(
select substring(`date`,1,7) as month,sum(total_laid_off) as total_off
from layoffs_staging_remodup
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by 1 asc
)
select month,total_off,
sum(total_off) over(order by month) as rolling_total
from rolling_total
;

#14 To Rank companies in which year they laid off most employees

select company, year(`date`), sum(total_laid_off)
from layoffs_staging_remodup
group by company, year(`date`)
order by 3 desc;

with rank_company as
(
select company, `date` as year, sum(total_laid_off) as total_off
from layoffs_staging_remodup
group by company,`date`
)
select company, year, total_off,
dense_rank() over( partition by year
order by total_off desc)
from rank_company
where year is not null
order by 3 desc
;

#15 Top 5 Companies that laid off most employees

with rank_company as
(
select company, year(`date`) as year, sum(total_laid_off) as total_off
from layoffs_staging_remodup
group by company, year(`date`)
),
yearly_top5_companies as
(select company, year, total_off,
dense_rank() over(partition by year order by total_off desc) as ranking
from rank_company
where year is not null)
select *
from yearly_top5_companies
where ranking <= 5
order by total_off desc;

#16 Layoffs by company stage

select stage
from layoffs_staging_remodup
;

select stage, sum(total_laid_off)
from layoffs_staging_remodup
group by stage
order by 2 desc
;

with rank_stage as
(
select stage, sum(total_laid_off) as total_laid_off
from layoffs_staging_remodup
group by stage
order by 2 desc
)
select stage, total_laid_off,
dense_rank() over(partition by total_laid_off)
from rank_stage
order by 2 desc
;

#17 Average layoffs per company

select company, round(avg(total_laid_off), 2) as average_layoffs
from layoffs_staging_remodup
group by company
order by 2 desc;

select company, avg(total_laid_off)
from layoffs_staging_remodup
where company like 'amazon'
group by company ;

#18 Countries with highest average layoffs

select country, round(avg(total_laid_off),2)
from layoffs_staging_remodup
group by country
order by 2 desc;

#19 Industry layoffs trend over time

select industry, year(`date`) as year, sum(total_laid_off)
from layoffs_staging_remodup
group by industry, year
order by 3 desc;

#20 Funding VS Layoffs

select
	case
		when funds_raised_millions < 50 then 'Low Funding'
        when funds_raised_millions between 50 and 200 then 'Mid Funding'
        Else 'High Funding'
	end as Funding_scale,
    sum(total_laid_off) as total_laid_off
from layoffs_staging_remodup
group by Funding_scale
order by total_laid_off desc
;

#21 Companies with repeated layoffs event

select company, count(company), year(`date`) as year, sum(total_laid_off)
from layoffs_staging_remodup
group by company, year
having count(company) > 1
order by 1 
;
    
#22 Top Industries layoff per country

with top_industry as
(select country, industry, sum(total_laid_off) as total_laid_off
from layoffs_staging_remodup
group by country, industry)
select country, industry, total_laid_off,
dense_rank() over (partition by industry
order by total_laid_off desc) as top_industry
from top_industry
where industry is not null
order by total_laid_off desc
;

#23 Percentage based severity analysis

select company, industry, percentage_laid_off
from layoffs_staging_remodup
where percentage_laid_off > 0.5
order by percentage_laid_off desc;

#24 Most Impactful layoffs days

select `date`, sum(total_laid_off) 
from layoffs_staging_remodup
group by `date`
having sum(total_laid_off) > 5000
order by sum(total_laid_off) desc 
;

