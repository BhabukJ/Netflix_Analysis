
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(MAX),
    type         VARCHAR(MAX),
    title        VARCHAR(MAX),
    director     VARCHAR(MAX),
    casts        VARCHAR(MAX),
    country      VARCHAR(MAX),
    date_added   VARCHAR(MAX),
    release_year INT,
    rating       VARCHAR(MAX),
    duration     VARCHAR(MAX),
    listed_in    VARCHAR(MAX),
    description  VARCHAR(MAX)
);

select  * from netflix

INSERT INTO netflix (show_id, type, title, director, casts, country, date_added, release_year, rating, duration, listed_in, description)
SELECT show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description
FROM [netflix].[dbo].[netflix_titles];