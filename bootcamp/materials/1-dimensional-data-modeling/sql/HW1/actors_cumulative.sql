INSERT INTO actors

WITH previous_year AS (
    SELECT
        * FROM actors
    WHERE current_year = 1982
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
having year = 1983
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
