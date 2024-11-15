-- Q1. How many olympics games have been held?

SELECT 
    COUNT(DISTINCT (games)) AS Count_of_Games
FROM
    Olympics_history;

-- Q2. List down all Olympics games held so far.

SELECT DISTINCT
    (year) AS year, season, city
FROM
    Olympics_history;

-- Q3. Mention the total no of nations who participated in each olympics game?

SELECT 
    games, COUNT(DISTINCT (noc)) AS Total_Countries
FROM
    Olympics_history
GROUP BY games;

-- Q4. Which year saw the lowest no of countries participating in olympics.

SELECT 
    games, COUNT(DISTINCT (noc)) AS Total_Countries
FROM
    Olympics_history
GROUP BY games
ORDER BY Total_Countries
LIMIT 1;

-- Q5. Which year saw the highest no of countries participating in olympics.

SELECT 
    games, COUNT(DISTINCT (noc)) AS Total_Countries
FROM
    Olympics_history
GROUP BY games
ORDER BY Total_Countries DESC
LIMIT 1;

-- Q6. Which regions have participated in the most distinct Olympic games, and how many games has each participated in?

SELECT 
    nr.region,
    COUNT(DISTINCT (oh.games)) AS total_participated_games
FROM
    olympics_history_noc_regions nr
        JOIN
    olympics_history oh ON nr.noc = oh.noc
GROUP BY nr.region
ORDER BY total_participated_games DESC;

-- Q7. Fetch the total no of sports played in each olympic games.

SELECT 
    games, COUNT(DISTINCT (sport)) no_of_sport
FROM
    olympics_history
GROUP BY games
ORDER BY no_of_sport DESC;

-- Q8. Fetch oldest athletes to win a gold medal.

SELECT 
    *
FROM
    olympics_history
WHERE
    medal = 'Gold'
        AND age = (SELECT 
            MAX(age)
        FROM
            olympics_history
        WHERE
            medal = 'Gold' AND age != 'NA');


-- Q9. Fetch the top 5 athletes who have won the most gold medals.

SELECT 
    name, team, COUNT(medal) total_gold
FROM
    olympics_history
WHERE
    medal = 'Gold'
GROUP BY name , team
ORDER BY total_gold DESC
LIMIT 5;

-- Q10. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

SELECT nr.region,Count(oh.medal) total_medals,row_number() OVER(ORDER by COUNT(oh.medal) DESC) AS rnk
FROM olympics_history oh
JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
WHERE medal !='NA'
Group by nr.region
Order by total_medals DESC
Limit 5;

-- Q11. List down total gold, silver and bronze medals won by each country.

SELECT 
    nr.region,
    COUNT(CASE
        WHEN oh.medal = 'Gold' THEN 1
    END) AS Gold,
    COUNT(CASE
        WHEN oh.medal = 'Silver' THEN 1
    END) AS Silver,
    COUNT(CASE
        WHEN oh.medal = 'Bronze' THEN 1
    END) AS Bronze
FROM
    olympics_history oh
        JOIN
    olympics_history_noc_regions nr ON nr.noc = oh.noc
GROUP BY nr.region
ORDER BY Gold DESC , Silver DESC , Bronze DESC;

-- Q12. In which Sport/event, India has won highest medals.

SELECT 
    sport, COUNT(medal) total_medals
FROM
    olympics_history
WHERE
    noc = 'IND' AND medal != 'NA'
GROUP BY sport
ORDER BY total_medals DESC
LIMIT 1;

-- Q13. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games?

SELECT 
    team, sport, games, COUNT(medal) Total_medals
FROM
    olympics_history
WHERE
    noc = 'IND' AND sport = 'Hockey'
        AND medal != 'NA'
GROUP BY team , sport , games
ORDER BY Total_medals DESC;

-- Q14. Which countries have never won gold medal but have won silver/bronze medals?

SELECT nr.region,
    COUNT(CASE
        WHEN oh.medal = 'Gold' THEN 1
    END) AS Gold,
    COUNT(CASE
        WHEN oh.medal = 'Silver' THEN 1
    END) AS Silver,
    COUNT(CASE
        WHEN oh.medal = 'Bronze' THEN 1
    END) AS Bronze
FROM
    olympics_history oh
        JOIN
    olympics_history_noc_regions nr ON nr.noc = oh.noc

GROUP BY nr.region
having Gold =0 and (Silver >0 or Bronze>0)
ORDER BY Silver DESC , Bronze DESC;