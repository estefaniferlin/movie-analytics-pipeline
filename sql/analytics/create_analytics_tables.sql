-- ==========================================================
-- 1) DIM TABLE: dim_movies
-- ==========================================================

CREATE OR REPLACE TABLE `<PROJECT_ID>.netflix_analytics.dim_movies` AS
SELECT
  SAFE_CAST(movieId AS INT64) AS movie_id,
  TRIM(REGEXP_REPLACE(CAST(title AS STRING), r'\s*\(\d{4}\)\s*$', '')) AS title, 
  CAST(genres AS STRING) AS genres,
  SAFE_CAST(REGEXP_EXTRACT(CAST(title AS STRING), r'\((\d{4})\)\s*$') AS INT64) AS release_year
FROM `<PROJECT_ID>.netflix_raw.raw_movies`;

-- ==========================================================
-- 2) FACT TABLE: fact_ratings (une os 2 CSVs de ratings)
-- ==========================================================

CREATE OR REPLACE TABLE `<PROJECT_ID>.netflix_analytics.fact_ratings` AS
WITH all_ratings AS (

  SELECT
    SAFE_CAST(NULLIF(userId, '') AS INT64) AS user_id,
    SAFE_CAST(NULLIF(movieId, '') AS INT64) AS movie_id,

    -- remove NA / NULL
    SAFE_CAST(NULLIF(NULLIF(rating, 'NA'), '') AS FLOAT64) AS rating,

    -- aceita timestamp com ou sem timezone
    COALESCE(
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S%Ez', tstamp),
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', tstamp)
    ) AS rating_ts,

    'user_rating_history' AS src -- para saber a fonte do dado (de qual tabela entre as duas)

  FROM `<PROJECT_ID>.netflix_raw.raw_user_rating_history`

  UNION ALL

  SELECT
    SAFE_CAST(NULLIF(userId, '') AS INT64) AS user_id,
    SAFE_CAST(NULLIF(movieId, '') AS INT64) AS movie_id,

    -- remove NA / NULL
    SAFE_CAST(NULLIF(NULLIF(rating, 'NA'), '') AS FLOAT64) AS rating,

    -- aceita timestamp com ou sem timezone
    COALESCE(
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S%Ez', tstamp),
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', tstamp)
    ) AS rating_ts,

    'ratings_for_additional_users' AS src -- para saber a fonte do dado (de qual tabela entre as duas)

  FROM `<PROJECT_ID>.netflix_raw.raw_user_additional_rating`
)

SELECT
  user_id,
  movie_id,
  rating,
  rating_ts,
  src
FROM all_ratings
WHERE user_id IS NOT NULL
  AND movie_id IS NOT NULL
  AND rating IS NOT NULL
  AND rating_ts IS NOT NULL
