
-- Teams with the Highest Possession Percentage:
SELECT TOP 10
    [Team],
    AVG([possessionPct]) AS AvgPossessionPercentage
FROM
    [EPL].[dbo].[TeamStatsExport$]
GROUP BY
    [Team]
ORDER BY
    AvgPossessionPercentage DESC;


-- Teams with the Most Shots on Target:
SELECT TOP 10
    [Team],
    SUM([shotsOnTarget]) AS TotalShotsOnTarget
FROM
    [EPL].[dbo].[TeamStatsExport$]
GROUP BY
    [Team]
ORDER BY
    TotalShotsOnTarget DESC;

--Top Goal Scorers:
SELECT TOP 10
    [Name],
    [TotalGoals]
FROM
    [EPL].[dbo].[PlayerStatsExport$]
ORDER BY
    [TotalGoals] DESC;

-- Players with the Most Assists:
SELECT TOP 10
    [Name],
    [GoalAssists]
FROM
    [EPL].[dbo].[PlayerStatsExport$]
ORDER BY
    [GoalAssists] DESC;

-- Average Age of Players:
SELECT
    AVG([Age]) AS AverageAge
FROM
    [EPL].[dbo].[PlayerStatsExport$];

-- Find the Players with the Best Goal-to-Game Ratio:
WITH PlayerStats AS (
    SELECT
        [Name],
        [TotalGoals],
        [Total PlayTime (min)],
        ROW_NUMBER() OVER (ORDER BY [TotalGoals]/NULLIF([Total PlayTime (min)], 0) DESC) AS Rank
    FROM
        [EPL].[dbo].[PlayerStatsExport$]
)
SELECT
    [Name],
    [TotalGoals],
    [Total PlayTime (min)],
    [TotalGoals]/NULLIF([Total PlayTime (min)], 0) AS GoalToGameRatio
FROM
    PlayerStats
WHERE
    Rank <= 10
ORDER BY
    GoalToGameRatio DESC;
--Identify Teams with the Most Diverse Age Range:
WITH TeamAgeRange AS (
    SELECT
        [Team],
        MAX([Age]) - MIN([Age]) AS AgeRange
    FROM
        [EPL].[dbo].[PlayerStatsExport$]
    GROUP BY
        [Team]
)
SELECT TOP 10
    [Team],
    AgeRange
FROM
    TeamAgeRange
ORDER BY
    AgeRange DESC;

-- Find Players Who Have Scored and Assisted in the Same Match:
SELECT DISTINCT
    P.[Name],
    M.[Fixture],
    M.[Date (US Eastern)]
FROM
    [EPL].[dbo].[PlayerStatsExport$] P
JOIN
    [EPL].[dbo].[TeamStatsExport$] M ON P.[Team] = M.[Team]
WHERE
    P.[TotalGoals] > 0
    AND P.[GoalAssists] > 0;


-- Find players playing for Chelsea who have scored and assisted in the same match:
SELECT DISTINCT
    P.[Name],
    M.[Fixture],
    M.[Date (US Eastern)]
FROM
    [EPL].[dbo].[PlayerStatsExport$] P
JOIN
    [EPL].[dbo].[TeamStatsExport$] M ON P.[Team] = M.[Team]
WHERE
    P.[TotalGoals] > 0
    AND P.[GoalAssists] > 0
    AND P.[Team] = 'Chelsea';

