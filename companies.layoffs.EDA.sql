Select *
From layoffs2 -- Cleaned up data for EDA
;

Select year(`Date`) As `Year`, Sum(total_laid_off) As Layoffs -- Summed up layoffs in each year
From layoffs2
Where year(`Date`) is not Null
group by year(`Date`)
order by 1
;

Select * -- These companies are either bankrupt or out of business
From layoffs2
Where percentage_laid_off = 1
;

Select company, Sum(total_laid_off) layoffs -- Top 10 companies to layoff their employee in respective year
From layoffs2
Where year(`date`) = 2023
Group by company
order by 2 desc
Limit 10
;

Select industry, Sum(total_laid_off) layoffs -- Total layoffs in each industry
From layoffs2
Group by industry
order by 2 desc
;

Select country, Sum(total_laid_off) layoffs -- Total layoffs in each country
From layoffs2
Group by country
order by 2 desc
;

Select substring(`date`,1,7) `Month`, sum(total_laid_off) Layoffs -- Layoffs in each month
From layoffs2
Where substring(`date`,1,7) is not Null
Group By `Month`
order by 1
;

With rolling As -- Rolling Total
(
Select substring(`date`,1,7) `Month`, sum(total_laid_off) Layoffs
From layoffs2
Where substring(`date`,1,7) is not Null
Group By `Month`
order by 1
)
Select `Month`, Layoffs, sum(Layoffs) over(order by `Month`) As Rolling_Total
From rolling 
;

With cte as -- Ranking of companies by layoffs in each year
(
Select company As Company, year(`Date`) As `Year`, Sum(total_laid_off) As Layoffs
From layoffs2
Where (year(`Date`) is not Null) 
group by company, year(`Date`)
order by 3 Desc
), cte_rank As
(
Select *, dense_rank() over(partition by `Year` Order by Layoffs Desc) As Ranking
From cte
Where Layoffs is not Null
Order by 2
)
Select *
From cte_rank
Where Ranking <= 5










































