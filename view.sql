
CREATE MATERIALIZED VIEW PlayerStatsView AS
SELECT
    p.PlayerID,
    p.Name AS PlayerName,
    t.TeamName AS CurrentTeam,
    COALESCE(SUM(ps.Goals), 0) AS TotalGoals,
    COALESCE(SUM(ps.Assists), 0) AS TotalAssists,
    COALESCE(AVG(ps.MinutesPlayed), 0) AS AverageMinutesPlayed,
    CASE WHEN COALESCE(SUM(ps.MinutesPlayed), 0) > 300 THEN 1 ELSE 0 END AS PlayedOver300Min,
    CASE WHEN DATE_PART('year', AGE(p.DateOfBirth)) BETWEEN 25 AND 30 THEN 1 ELSE 0 END AS AgeBetween25And30,
    CASE WHEN MAX(ps.Goals) >= 3 THEN 1 ELSE 0 END AS Scored3PlusGoalsInMatch,
    CONCAT(FLOOR(COALESCE(SUM(ps.MinutesPlayed), 0) / 90), ' match ', COALESCE(SUM(ps.MinutesPlayed), 0) % 90, ' min') AS EstimatedMatchesPlayed,
    CASE WHEN EXISTS (
        SELECT 1
        FROM TransferHistory th
        JOIN Teams tf ON th.FromTeamID = tf.TeamID OR th.ToTeamID = tf.TeamID
        WHERE th.PlayerID = p.PlayerID AND tf.Country = 'France'
    ) THEN 1 ELSE 0 END AS PlayedInFrance,
    (
        SELECT MIN(th.TransferDate)
        FROM TransferHistory th
        JOIN Teams tf ON th.FromTeamID = tf.TeamID OR th.ToTeamID = tf.TeamID
        WHERE th.PlayerID = p.PlayerID AND tf.Country = 'France'
    ) AS DateJoinedFrenchTeam,
    CASE WHEN EXISTS (
        SELECT 1
        FROM TransferHistory th
        JOIN Teams ti ON th.FromTeamID = ti.TeamID OR th.ToTeamID = ti.TeamID
        WHERE th.PlayerID = p.PlayerID AND ti.Country = 'Italy'
    ) THEN 1 ELSE 0 END AS PlayedInItaly,
    (
        SELECT MIN(th.TransferDate)
        FROM TransferHistory th
        JOIN Teams ti ON th.FromTeamID = ti.TeamID OR th.ToTeamID = ti.TeamID
        WHERE th.PlayerID = p.PlayerID AND ti.Country = 'Italy'
    ) AS DateJoinedItalianTeam
FROM
    Players p
    JOIN Teams t ON p.TeamID = t.TeamID
    LEFT JOIN PlayerStats ps ON p.PlayerID = ps.PlayerID
GROUP BY
    p.PlayerID, p.Name, t.TeamName, p.DateOfBirth;



SELECT *
FROM PlayerStatsView;