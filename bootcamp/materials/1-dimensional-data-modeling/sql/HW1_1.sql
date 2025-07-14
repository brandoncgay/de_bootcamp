-- 1. **DDL for `actors` table:** Create a DDL for an `actors` table with the following fields:
--     - `films`: An array of `struct` with the following fields:
-- 		- film: The name of the film.
-- 		- votes: The number of votes the film received.
-- 		- rating: The rating of the film.
-- 		- filmid: A unique identifier for each film.

--     - `quality_class`: This field represents an actor's performance quality, determined by the average rating of movies of their most recent year. It's categorized as follows:
-- 		- `star`: Average rating > 8.
-- 		- `good`: Average rating > 7 and ≤ 8.
-- 		- `average`: Average rating > 6 and ≤ 7.
-- 		- `bad`: Average rating ≤ 6.
--     - `is_active`: A BOOLEAN field that indicates whether an actor is currently active in the film industry (i.e., making films this year).

-- CREATE TYPE film_info AS (
--     film TEXT,
--     votes INT,
--     rating FLOAT,
--     filmid TEXT
-- );

-- CREATE TYPE quality_class AS ENUM (
--     'star',
--     'good',
--     'average',
--     'bad'
-- );

-- CREATE TYPE year_info AS (
--     year INT,
--     films film_info[]
-- );

-- CREATE TABLE actors (
--     actor TEXT,
--     actorid TEXT,
--     year_info year_info[], -- An array of the composite type
--     quality_class TEXT,
--     current_year INT,
--     is_active BOOLEAN
-- );

-- 2. **Cumulative table generation query:** Write a query that populates the `actors` table one year at a time.

INSERT INTO actors

WITH previous_year AS (
    SELECT
        * FROM actors
    WHERE current_year = 1971
),

current_year AS (
SELECT
    actor,
    actorid,
    ARRAY_AGG(ROW(film, votes, rating, filmid)::film_info) AS films,
    AVG(rating) AS avg_rating,
    CASE
        WHEN AVG(rating) > 8 THEN 'star'
        WHEN AVG(rating) > 7 THEN 'good'
        WHEN AVG(rating) > 6 THEN 'average'
        ELSE 'bad'
    END AS quality_class,
    year as current_year
FROM actor_films
group by actor, actorid, year
having year = 1972
)

SELECT
    COALESCE(cy.actor, py.actor) AS actor,
    COALESCE(cy.actorid, py.actorid) AS actorid,
    CASE
        WHEN py.year_info IS NULL THEN ARRAY[ROW(cy.current_year, cy.films)::year_info]
        WHEN cy.current_year IS NOT NULL THEN py.year_info || ARRAY[ROW(cy.current_year, cy.films)::year_info]
        ELSE py.year_info
    END AS year_info,
    COALESCE(cy.quality_class, py.quality_class) AS quality_class,
    COALESCE(cy.current_year, py.current_year + 1) AS current_year,
    cy.actor IS NOT NULL AS is_active
FROM current_year cy
FULL OUTER JOIN previous_year py
    ON cy.actor = py.actor

select * from actors where current_year = 1972