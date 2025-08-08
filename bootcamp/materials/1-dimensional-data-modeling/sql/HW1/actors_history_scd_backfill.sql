WITH streak_start as (
    SELECT
        actor,
        actorid,
        quality_class,
        LAG(quality_class, 1) OVER (PARTITION BY actor ORDER BY current_year) as previous_quality,
        is_active,
        LAG(is_active, 1) OVER (PARTITION BY actor ORDER BY current_year) as previous_active,
        LAG(quality_class, 1) OVER (PARTITION BY actor ORDER BY current_year) <> quality_class
            OR LAG(quality_class, 1) OVER (PARTITION BY actor ORDER BY current_year) IS NULL OR
        LAG(is_active, 1) OVER (PARTITION BY actor ORDER BY current_year) <> is_active
            OR LAG(is_active, 1) OVER (PARTITION BY actor ORDER BY current_year) IS NULL AS did_change,
        current_year
    FROM actors
),
streak_identify as (
    SELECT
        actor,
        actorid,
        quality_class,
        is_active,
        current_year,
        SUM(CASE WHEN did_change THEN 1 ELSE 0 END)
            OVER (PARTITION BY actor ORDER BY current_year) as streak_identifier
    FROM streak_start
),
aggregated as (
    SELECT
        actor,
        actorid,
        quality_class,
        is_active,
        streak_identifier,
        MIN(current_year) AS start_year,
        MAX(current_year) AS end_year
    FROM streak_identify
    GROUP BY actor, actorid, quality_class, is_active, streak_identifier
)
INSERT INTO actors_history_scd
select 
    actor,
    actorid,
    quality_class,
    is_active,
    start_year,
    end_year
from aggregated 
order by actor, streak_identifier;