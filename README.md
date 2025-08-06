# SQL-Data-Cleaning-Layoffs-Analysis-2022-
A SQL project focused on cleaning and analyzing global layoffs data from 2020-2023. This repository demonstrates data cleaning techniques using SQL, including deduplication, standardization, null-value handling, and optimizing datasets for analysis
A comprehensive SQL project demonstrating data cleaning techniques on a dataset of global layoffs in 2022. The project covers duplicate removal, standardization, and null-value handling.

**Dataset Source**: [Kaggle Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

---

## 🧹 Data Cleaning Steps

### 1. **Removing Duplicates**
- Identified duplicates using `ROW_NUMBER()` partitioned by key columns (company, location, industry, etc.).
- Created a staging table (`layoffs_staging2`) to isolate duplicates.
- Deleted duplicate records where `rn > 1`.

**Code Snippet**:
```sql
WITH duplicate_cte AS (
  SELECT *,
    ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, date) AS rn
  FROM layoffs_staging
)
DELETE FROM duplicate_cte WHERE rn > 1;

#### 2. Standardizing Data
- Trimmed whitespace from company names.

- Standardized industries (e.g., grouped "CryptoCurrency" and "Crypto" into "Crypto").

- Fixed country names (e.g., removed trailing dots in "United States.").

- Converted date strings to DATE format.

-- Trim company names
UPDATE layoffs_staging2 SET company = TRIM(company);

-- Standardize Crypto industry
UPDATE layoffs_staging2 
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

-- Fix date format
ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;
##### 3. Handling Nulls & Blanks
Replaced empty strings ('') with NULL in the industry column.

Populated missing industry data by joining records from the same company/location.

Filtered records where both total_laid_off and percentage_laid_off were null.

 -- Update NULL industries using self-join
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

🛠️ Tools
SQL (MySQL/PostgreSQL compatible)

Kaggle (Dataset sourcing)

 
🔍 Key Insights
Data Quality Issues: Found inconsistencies in industry names, date formats, and duplicate entries.

Solution Impact: Cleaned data is now ready for analysis (e.g., layoffs trends by industry/country).
