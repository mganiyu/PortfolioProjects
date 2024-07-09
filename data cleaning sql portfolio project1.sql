#data cleaning in mysql

# create duplicate of your original data
SELECT * 
FROM layoffs;

CREATE TABLE layoffscopy
LIKE layoffs;

INSERT INTO layoffscopy
SELECT *
FROM layoffs;

SELECT *
FROM  layoffscopy;

# 1 remove duplicate

# identifying duplicate values window functions
WITH duplicate_CTE AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
company,location,industry,total_laid_off,percentage_laid_off,`date`, 
stage,country,funds_raised_millions) AS Row_Num
FROM  layoffscopy
)
SELECT *
FROM duplicate_CTE
WHERE Row_Num > 1;

SELECT *
FROM duplicate_CTE
WHERE Row_Num > 1;

SELECT *
FROM layoffscopy
WHERE company = 'Casper';

# creating new table to allow you delete the dulicate since you can update a CTE direct
CREATE TABLE `layoffscopy1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffscopy1;

# insert into the table
INSERT into  layoffscopy1
SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
company,location,industry,total_laid_off,percentage_laid_off,`date`, 
stage,country,funds_raised_millions) AS Row_Num
FROM  layoffscopy;

# delete duplicate from the table
DELETE
FROM layoffscopy1
WHERE row_num > 1;

SELECT *
FROM layoffscopy1;

# 2 Standardizing  date
SELECT company, TRIM(company)
FROM layoffscopy1;

UPDATE  layoffscopy1
SET company = TRIM(company);


SELECT industry
FROM layoffscopy1 
WHERE industry LIKE 'Crypto%';

UPDATE layoffscopy1
SET  industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffscopy1 ;

SELECT  country
FROM layoffscopy1
WHERE country  = 'United States.';

UPDATE  layoffscopy1
SET  country = TRIM( TRAILING  '.'  FROM   country)
WHERE country  LIKE 'United States%';

SELECT  country
FROM layoffscopy1
WHERE country  = 'United States.';

SELECT  `date`, str_to_date( `date`, '%m/%d/%Y')
FROM layoffscopy1;

UPDATE  layoffscopy1
SET `date` =   str_to_date( `date`, '%m/%d/%Y');

SELECT  `date`
FROM layoffscopy1;

ALTER TABLE layoffscopy1
MODIFY COLUMN `date` DATE;


# 3 dealing with null and empty values
SELECT  *
FROM layoffscopy1
WHERE total_laid_off  IS NULL
AND percentage_laid_off IS NULL;

SELECT  *
FROM layoffscopy1
WHERE industry  IS NULL
OR  industry = "";


SELECT  *
FROM layoffscopy1
WHERE   company = "Airbnb";

UPDATE  layoffscopy1
SET  industry = NULL
WHERE industry  = '';


SELECT  t1.industry,t2.industry
FROM layoffscopy1 t1
JOIN    layoffscopy1 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = "")
AND t2.industry IS NOT NULL ;    

UPDATE  layoffscopy1 t1
JOIN    layoffscopy1 t2
	ON t1.company = t2.company
set  t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;    


SELECT *
FROM  layoffscopy1;

# 4 delete or remove unneccesary records and coumn from the tables
SELECT  *
FROM layoffscopy1
WHERE total_laid_off  IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffscopy1
WHERE total_laid_off  IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffscopy1
DROP COLUMN row_num;
