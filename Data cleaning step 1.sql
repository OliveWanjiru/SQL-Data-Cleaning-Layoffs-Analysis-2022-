-- Data Cleaning Continuation
-- 1. Removing Duplicates

select *
from layoffs;

select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`) as rn
from layoffs_staging;

with duplicate_cte as
(
	select *,
row_number() over(
partition by company,
location,
 industry,
 total_laid_off, 
 percentage_laid_off,
 `date`,
 stage,
 country, funds_raised_millions) as rn
from layoffs_staging
)
select * 
from duplicate_cte
where rn > 1;


select *
from layoffs_staging
where company = 'Casper';



with duplicate_cte as
(
	select *,
row_number() over(
partition by company,
location,
 industry,
 total_laid_off, 
 percentage_laid_off,
 `date`,
 stage,
 country, funds_raised_millions) as rn
from layoffs_staging
)
Delete  
from duplicate_cte
where rn > 1;





CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `rn` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2
where rn > 1 ;

insert into layoffs_staging2
select *,
row_number() over(
partition by company,
location,
 industry,
 total_laid_off, 
 percentage_laid_off,
 `date`,
 stage,
 country, funds_raised_millions) as rn
from layoffs_staging;

delete 
from layoffs_staging2
where rn > 1 ;

select *
from layoffs_staging2;

select distinct industry
from layoffs_staging2;


-- Standardizing data
select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company); 