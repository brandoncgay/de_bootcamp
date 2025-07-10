

-- select * from player_seasons
-- limit 10;

-- CREATE TYPE season_stats AS (
--     season integer,
--     gp integer,
--     pts real,
--     reb real,
--     ast real
-- );

-- CREATE TYPE scoring_class AS ENUM (
--     'star',
--     'good',
--     'average',
--     'bad');

-- CREATE TABLE players (
--     player_name TEXT NOT NULL,
--     height TEXT,
--     college TEXT,
--     country TEXT,
--     draft_year TEXT,
--     draft_round TEXT,
--     draft_number TEXT,
--     season_stats season_stats[],
--     scoring_class scoring_class,
--     years_since_last_season INTEGER,
--     current_season INTEGER,
--     is_active BOOLEAN
--     PRIMARY KEY (player_name, current_season)
-- );
-- INSERT INTO players
-- WITH yesterday AS (
--     SELECT * FROM players
--     WHERE current_season = 1998
-- ),
-- today AS (
--     SELECT * FROM player_seasons
--     WHERE season = 1999
-- )

-- SELECT 
--     COALESCE(t.player_name, y.player_name) AS player_name,
--     COALESCE(t.height, y.height) AS height,
--     COALESCE(t.college, y.college) AS college,
--     COALESCE(t.country, y.country) AS country,
--     COALESCE(t.draft_year, y.draft_year) AS draft_year,
--     COALESCE(t.draft_round, y.draft_round) AS draft_round,
--     COALESCE(t.draft_number, y.draft_number) AS draft_number,
--     CASE
--             WHEN y.season_stats IS NULL THEN ARRAY[ROW(t.season, t.gp, t.pts, t.reb, t.ast)::season_stats]
--             WHEN t.season IS NOT NULL THEN y.season_stats || ARRAY[ROW(t.season, t.gp, t.pts, t.reb, t.ast)::season_stats]
--             ELSE y.season_stats
--     END AS season_stats,
--     COALESCE(t.season, y.current_season + 1) AS current_season
-- FROM today t
-- FULL OUTER JOIN yesterday y
-- ON t.player_name = y.player_name

-- select 
-- player_name,
-- (unnest(season_stats)::season_stats).*
-- from players 
-- where current_season = 1999;

-- drop table players

CREATE TABLE players_scd (
    player_name TEXT NOT NULL,
    height TEXT,
    college TEXT,
    country TEXT,
    draft_year TEXT,
    draft_round TEXT,
    draft_number TEXT,
    season_stats season_stats[],
    scoring_class scoring_class,
    years_since_last_season INTEGER,
    current_season INTEGER,
    is_active BOOLEAN,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE
)