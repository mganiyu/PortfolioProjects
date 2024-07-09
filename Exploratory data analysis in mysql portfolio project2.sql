
# Exploratory data analysis with mySQL
SELECT *
FROM layoffscopy1;

SELECT  MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffscopy1;

SELECT   *
FROM layoffscopy1
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT   company, SUM(total_laid_off)
FROM layoffscopy1
GROUP BY company
ORDER BY 2 DESC;

SELECT   MIN(`date`), MAX(`date`)
FROM layoffscopy1;

SELECT   industry, SUM(total_laid_off)
FROM layoffscopy1
GROUP BY industry
ORDER BY 2 DESC;

SELECT   country, SUM(total_laid_off)
FROM layoffscopy1
GROUP BY country
ORDER BY 2 DESC;

SELECT   `date`, SUM(total_laid_off)
FROM layoffscopy1
GROUP BY `date`
ORDER BY 2 DESC;

SELECT   YEAR(`date`), SUM(total_laid_off)
FROM layoffscopy1
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT   stage, SUM(total_laid_off)
FROM layoffscopy1
GROUP BY stage
ORDER BY 2 DESC;

SELECT   company, SUM(percentage_laid_off)
FROM layoffscopy1
GROUP BY company
ORDER BY 2 DESC;

SELECT   SUBSTRING(`date`, 6,2) AS `Month`, SUM(total_laid_off)
FROM layoffscopy1
WHERE  SUBSTRING(`date`, 6,2) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 DESC;

WITH  total_row_up AS (
	SELECT   SUBSTRING(`date`, 1,7) AS `Month`,  SUM(total_laid_off) AS Total_off
	FROM layoffscopy1
	WHERE  SUBSTRING(`date`, 1,7) IS NOT NULL
	GROUP BY `Month`
	ORDER BY 1 DESC
)
SELECT  `Month`, Total_off,
 sum(Total_off) OVER(ORDER BY `Month` ) AS Rowlling_Total
FROM total_row_up;

SELECT   company, YEAR( `date`),SUM(total_laid_off)
FROM layoffscopy1
GROUP BY company, YEAR( `date`)
ORDER BY 3 DESC;

WITH compay_year  (company,years,total_laid_off) AS
(
	SELECT   company, YEAR( `date`),SUM(total_laid_off)
	FROM layoffscopy1
    GROUP BY company, YEAR( `date`)
), Company_Year_Rank AS (
	SELECT  *,
	 DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
	 FROM compay_year
	 WHERE  years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE  Ranking <=5;