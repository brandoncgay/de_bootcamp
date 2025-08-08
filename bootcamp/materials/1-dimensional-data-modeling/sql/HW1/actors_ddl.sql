CREATE TYPE film_info AS (
    film TEXT,
    votes INT,
    rating FLOAT,
    filmid TEXT
);

CREATE TYPE quality_class AS ENUM (
    'star',
    'good',
    'average',
    'bad'
);

CREATE TYPE year_info AS (
    year INT,
    films film_info[]
);

CREATE TABLE actors (
    actor TEXT,
    actorid TEXT,
    year_info year_info[],
    quality_class TEXT,
    current_year INT,
    is_active BOOLEAN
);