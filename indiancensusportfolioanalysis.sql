
# 2011 Indian cencus  portfolio analysis in sql

CREATE DATABASE  indiancencus;

SELECT *
FROM cencusdata1;

SELECT *
FROM cencusdata2;


# no of rows in the first database
SELECT  COUNT(*)
FROM cencusdata1;

# no of rows in the second database
SELECT COUNT(*)
FROM cencusdata2;


# data set for Jharkhand and Bihar
SELECT *
FROM cencusdata1
WHERE  State  IN('Jharkhand','Bihar');

# population of india
SELECT SUM(Population) AS Population
FROM cencusdata2;

# population of india
SELECT SUM(Population) AS Population
FROM cencusdata2;

# average growth percentage
SELECT AVG(Growth)  * 100
FROM cencusdata1;

#  average growth percentae by state
SELECT State,  ROUND(AVG(Growth),0) Growth_percentage_by_state
FROM cencusdata1
GROUP BY State;

#  average sex ration  by state
SELECT State,  ROUND(AVG(sex_ratio),0) sex_ratio_percentage_by_state
FROM cencusdata1
GROUP BY State
ORDER BY 2 DESC;


#  average literacy ration  by state
SELECT State,  ROUND(AVG(Literacy),0) literary_rate
FROM cencusdata1
GROUP BY State
ORDER BY 2 DESC;

#  average literacy ration  by state greater than 90
SELECT State,  ROUND(AVG(Literacy),0) literary_rate
FROM cencusdata1
GROUP BY State
HAVING AVG(Literacy) > 90
ORDER BY 2 DESC;


#  top 3 state showing highest growth grate
SELECT State,  ROUND(AVG(Growth),0) Growth_percentage_by_state
FROM cencusdata1
GROUP BY State
ORDER BY 2 DESC;

#  buttom 3 state showing lowest growth grate
SELECT State,  ROUND(AVG(Growth),0) buttum_3_growth
FROM cencusdata1
GROUP BY State
ORDER BY 2 ASC
LIMIT 3;


#  buttom 3 state showing lowest sex ratio
SELECT State,  ROUND(AVG(sex_ratio),0) buttum_3_sex_ratio
FROM cencusdata1
GROUP BY State
ORDER BY 2 ASC
LIMIT 3;

# top and buttom 3 state in literacy state using temp tablle
CREATE TEMPORARY TABLE topstate (
		State VARCHAR(255),
        Toopstate FLOAT
);
INSERT INTO topstate(
	SELECT State,  ROUND(AVG(Literacy),0) literary_rate
	FROM cencusdata1
	GROUP BY State
    ORDER BY literary_rate DESC
);
SELECT *
FROM topstate
LIMIT 3;


CREATE TEMPORARY TABLE buttumpstate (
		State VARCHAR(255),
        Toopstate FLOAT
);

INSERT INTO buttumpstate(
	SELECT State,  ROUND(AVG(Literacy),0) literary_rate
	FROM cencusdata1
	GROUP BY State
    ORDER BY literary_rate ASC
);

SELECT * 
FROM (
		SELECT *
		FROM topstate
		LIMIT 3
) a
UNION
SELECT * 
FROM (
		SELECT *
		FROM buttumpstate
		LIMIT 3
) b;

# state starting with a
SELECT DISTINCT(State) 
FROM cencusdata1
WHERE lower(State) LIKE "a%";
#Joining both table
# Total male and female
SELECT d.State, SUM(d.Males) Total_Males, SUM(d.Females) AS Total_Females
FROM 
(SELECT c.District, c.State,
c.Population / ROUND((c.Sex_Ratio + 1),0) As Males,
ROUND((c.Population *  c.Sex_Ratio) / (c.Sex_Ratio + 1),0) As Females
FROM (	
				SELECT c1.District,
							 c1.State, 
							 c1.Sex_Ratio / 1000 AS Sex_Ratio,
							 c2.Population
						FROM cencusdata1 AS c1
						INNER JOIN cencusdata2 c2
						ON c1.District = c2.District
				)  c) d
GROUP BY d.State;

# Total Literacy Rate
SELECT e.State, 
SUM(e.Literate_People) AS Total_Literate_people, 
SUM(e.Illiterate_people) AS Total_Iliterate_people
FROM 
		(SELECT d.District,
		d.State,
		d.Literacy_R/atio,
		round(d.Population,0) AS Literate_People, 
		round((1-d.Literacy_Ratio) * d.Population,0) AS Illiterate_people
		FROM 
					(SELECT c1.District,
					c1.State, 
					c1.Literacy / 100 AS Literacy_Ratio,
					c2.Population
					FROM cencusdata1 AS c1
					INNER JOIN cencusdata2 c2
					ON c1.District = c2.District
					)  d) e 
GROUP BY e.State;

# population in previous census
SELECT b.State,
SUM(b.Previous_Census_Population) Total_Previous_Census_Population,
SUM(b.Current_Census_Population) Total_Current_Census_Population
FROM 
		(SELECT a.District,
		a.State,
		round(a.Population / (1+a.Growth) ,0 )AS Previous_Census_Population, 
		a.Population AS Current_Census_Population
		FROM
					(SELECT c1.District,
					c1.State, 
					c1.Growth,
					c2.Population
					FROM cencusdata1 AS c1
					INNER JOIN cencusdata2 c2
					ON c1.District = c2.District) a)b
	GROUP BY b.State;
    
    

SELECT *
FROM cencusdata1;

SELECT *
FROM cencusdata2;



