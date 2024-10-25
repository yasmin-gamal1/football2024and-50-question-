CREATE TABLE Teams (
    TeamID INT PRIMARY KEY,
    TeamName VARCHAR(255),
    FoundedYear INT,
    HomeCity VARCHAR(255),
    ManagerName VARCHAR(255),
    StadiumName VARCHAR(255),
    StadiumCapacity INT,
    Country VARCHAR(255)
);

CREATE TABLE Matches (
    MatchID INT PRIMARY KEY,
    Date DATE,
    HomeTeamID INT,
    AwayTeamID INT,
    HomeTeamScore INT,
    AwayTeamScore INT,
    Stadium VARCHAR(255),
    Referee VARCHAR(255),
    FOREIGN KEY (HomeTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (AwayTeamID) REFERENCES Teams(TeamID)
);

CREATE TABLE Players (
    PlayerID INT PRIMARY KEY,
    TeamID INT,
    Name VARCHAR(255),
    Position VARCHAR(255),
    DateOfBirth DATE,
    Nationality VARCHAR(255),
    ContractUntil DATE,
    MarketValue INT,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);



CREATE TABLE PlayerStats (
    StatID INT PRIMARY KEY,
    PlayerID INT,
    MatchID INT,
    Goals INT,
    Assists INT,
    YellowCards INT,
    RedCards INT,
    MinutesPlayed INT,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID)
);


CREATE TABLE TransferHistory (
    TransferID INT PRIMARY KEY,
    PlayerID INT,
    FromTeamID INT,
    ToTeamID INT,
    TransferDate DATE,
    TransferFee DECIMAL,
    ContractDuration INT,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (FromTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (ToTeamID) REFERENCES Teams(TeamID)
);


CREATE TABLE TransferHistory (
    TransferID INT PRIMARY KEY,
    PlayerID INT,
    ToTeamID INT,
    FromTeamID INT,
    TransferDate DATE,
    TransferFee DECIMAL,
    ContractDuration INT,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (FromTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (ToTeamID) REFERENCES Teams(TeamID)
);

c
-- SELECT * FROM TransferHistory;

-- SELECT
--     p.PlayerID,
--     p.Name AS PlayerName,
--     t.TeamName AS CurrentTeam,
--     COALESCE(SUM(ps.Goals), 0) AS TotalGoals,
--     COALESCE(SUM(ps.Assists), 0) AS TotalAssists,
--     COALESCE(AVG(ps.MinutesPlayed), 0) AS AverageMinutesPlayed,
--     CASE WHEN COALESCE(SUM(ps.MinutesPlayed), 0) > 300 THEN 1 ELSE 0 END AS PlayedOver300Min,
--     CASE WHEN DATE_PART('year', AGE(p.DateOfBirth)) BETWEEN 25 AND 30 THEN 1 ELSE 0 END AS AgeBetween25And30,
--     CASE WHEN MAX(ps.Goals) >= 3 THEN 1 ELSE 0 END AS Scored3PlusGoalsInMatch,
--     CONCAT(FLOOR(COALESCE(SUM(ps.MinutesPlayed), 0) / 90), ' match ', COALESCE(SUM(ps.MinutesPlayed), 0) % 90, ' min') AS EstimatedMatchesPlayed,
--     CASE WHEN EXISTS (
--         SELECT 1
--         FROM TransferHistory th
--         JOIN Teams tf ON th.FromTeamID = tf.TeamID OR th.ToTeamID = tf.TeamID
--         WHERE th.PlayerID = p.PlayerID AND tf.Country = 'France'
--     ) THEN 1 ELSE 0 END AS PlayedInFrance,
--     (
--         SELECT MIN(th.TransferDate)
--         FROM TransferHistory th
--         JOIN Teams tf ON th.FromTeamID = tf.TeamID OR th.ToTeamID = tf.TeamID
--         WHERE th.PlayerID = p.PlayerID AND tf.Country = 'France'
--     ) AS DateJoinedFrenchTeam,
--     CASE WHEN EXISTS (
--         SELECT 1
--         FROM TransferHistory th
--         JOIN Teams ti ON th.FromTeamID = ti.TeamID OR th.ToTeamID = ti.TeamID
--         WHERE th.PlayerID = p.PlayerID AND ti.Country = 'Italy'
--     ) THEN 1 ELSE 0 END AS PlayedInItaly,
--     (
--         SELECT MIN(th.TransferDate)
--         FROM TransferHistory th
--         JOIN Teams ti ON th.FromTeamID = ti.TeamID OR th.ToTeamID = ti.TeamID
--         WHERE th.PlayerID = p.PlayerID AND ti.Country = 'Italy'
--     ) AS DateJoinedItalianTeam
-- FROM
--     Players p
--     JOIN Teams t ON p.TeamID = t.TeamID
--     LEFT JOIN PlayerStats ps ON p.PlayerID = ps.PlayerID
-- GROUP BY
--     p.PlayerID, p.Name, t.TeamName, p.DateOfBirth;

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














