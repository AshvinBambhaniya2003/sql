-- Make sure to attach design image/pdf in the same folder.
-- Write your DDL queries here.

-- 1 

SELECT
    player_name,
    SUM(minutes_played) AS total_minutes_played
FROM
    appereances
GROUP BY
    player_id
ORDER BY
    total_minutes_played DESC
LIMIT 1;


-- 2

SELECT
    player_current_club_id,
    SUM(minutes_played) AS total_minutes_played
FROM
    appereances
GROUP BY
    player_current_club_id
ORDER BY
    total_minutes_played DESC
LIMIT 1;

-- 3

SELECT
    player_id,
    player_name,
    SUM(minutes_played) AS total_minutes_played,
    RANK() OVER (ORDER BY SUM(minutes_played) DESC) AS player_rank
FROM
    appereances
GROUP BY
    player_id, player_name
ORDER BY
    total_minutes_played DESC
LIMIT 10;

-- 4

SELECT
    clubs.club_code,
    SUM(club_games.is_win) AS total_won_games,
    RANK() OVER (ORDER BY SUM(club_games.is_win) DESC) AS club_rank
FROM
    clubs
JOIN
    club_games cs ON clubs.club_id = club_games.club_id
GROUP BY
    clubs.club_code
ORDER BY
    total_won_games DESC
LIMIT 10;


-- 5

SELECT
    club_id,
    COUNT(game_id) AS total_games_played,
    SUM(CASE WHEN is_win = 1 THEN 1 ELSE 0 END) AS total_won_games,
    SUM(CASE WHEN is_win = 1 THEN 1 ELSE 0 END) / COUNT(game_id) AS win_to_play_ratio
FROM
    club_games t1
GROUP BY
    club_id
ORDER BY
    win_to_play_ratio DESC
LIMIT 10;


-- 6

SELECT DISTINCT
    m1.own_manager_name,
    m1.club_id,
    m1.opponent_id,
    m1.game_id AS original_game_id,
    m2.game_id AS new_game_id
FROM
    club_games m1
JOIN
    club_games m2 ON m1.opponent_manager_name = m2.own_manager_name
WHERE
    m1.opponent_id <> m2.club_id;


-- 8

SELECT
    clubs.club_name,
    COUNT(*) AS total_substitutions
FROM
    game_events 
JOIN
    clubs ON game_events.club_id = clubs.club_id
WHERE
    game_events.type = 'Substitutions'
GROUP BY
    clubs.club_id
ORDER BY
    total_substitutions DESC
LIMIT 1;


-- 9

SELECT
    players.name,
    COUNT(*) AS total_substitutions
FROM
    game_events 
JOIN
    players ON game_events.player_id = players.player_id
WHERE
    game_events.type = 'Substitutions'
GROUP BY
    players.player_id
ORDER BY
    total_substitutions DESC
LIMIT 1;

-- 10

SELECT DISTINCT
    g1.game_id,
    g1.referee,
    g1.home_club_id,
    g1.home_club_manager_name,
    g1.away_club_id,
    g1.away_club_manager_name
FROM games g1
JOIN games g2 ON g1.referee = g2.home_club_manager_name OR g1.referee = g2.away_club_manager_name
WHERE g1.referee IS NOT NULL;
