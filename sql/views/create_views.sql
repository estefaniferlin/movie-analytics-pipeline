-- ===========================================
-- ATIVIDADE POR USUÁRIO
-- ===========================================

CREATE OR REPLACE VIEW `<PROJECT_ID>.netflix_analytical.vw_user_activity` AS
SELECT
  user_id,
  COUNT(*) AS total_ratings,
  COUNT(DISTINCT movie_id) AS distinct_moveis_rated,
  AVG(rating) AS avg_rating,
  STDDEV(rating) AS std_rating,
  MIN(rating_ts) AS first_activity_ts,
  MAX(rating_ts) AS last_activity_ts
FROM `<PROJECT_ID>.netflix_analytical.fact_ratings`
GROUP BY 1
ORDER BY total_ratings DESC, avg_rating DESC;

-- ===========================================
-- KPIs DE FILMES
-- ===========================================
CREATE OR REPLACE VIEW `<PROJECT_ID>.netflix_analytical.vw_movies_kpis` AS
SELECT
  r.movie_id,
  m.title,
  m.genres,
  m.release_year,
  COUNT(*) AS total_ratings,
  AVG(r.rating) AS avg_rating,
  STDDEV(r.rating) AS std_rating,
  MIN(r.rating_ts) AS first_rating_ts,
  MAX(r.rating_ts) AS last_rating_ts
FROM `<PROJECT_ID>.netflix_analytical.fact_ratings` r
LEFT JOIN `<PROJECT_ID>.netflix_analytical.dim_movies` m
  ON m.movie_id = r.movie_id
GROUP BY 1,2,3,4;


-- ===========================================
-- TOP 10 FILMES + BEM AVALIADOS
-- ===========================================
CREATE OR REPLACE VIEW `<PROJECT_ID>.netflix_analytical.vw_top_movies` AS
SELECT
  movie_id,
  title,
  genres,
  release_year,
  total_ratings,
  ROUND(avg_rating,2) AS avg_rating
FROM `<PROJECT_ID>.netflix_analytical.vw_movies_kpis`
WHERE total_ratings >= 20
AND avg_rating BETWEEN 0 AND 5
ORDER BY avg_rating DESC, total_ratings DESC
LIMIT 10;


-- ===========================================
-- PERGUNTAS DE PERFORMANCE POR GÊNERO
-- ===========================================
CREATE OR REPLACE VIEW `<PROJECT_ID>.netflix_analytical.vw_genre_performance` AS
WITH exploded AS (
  SELECT
    r.rating,
    genre
  FROM `<PROJECT_ID>.netflix_analytical.fact_ratings` r
  JOIN `<PROJECT_ID>.netflix_analytical.dim_movies` m
    ON m.movie_id = r.movie_id
  CROSS JOIN UNNEST(SPLIT(COALESCE(m.genres, ''), '|')) AS genre
)
SELECT
  genre,
  COUNT(*) AS total_ratings,
  AVG(rating) AS avg_rating,
  STDDEV(rating) AS std_rating
FROM exploded
WHERE genre IS NOT NULL
  AND genre != ''
  AND genre != '(no genres listed)'
GROUP BY 1;


-- ====================================================
-- QUANTAS AVALIAÇÕES DE FILMES OCORRERAM POR MES E ANO 
-- ====================================================
CREATE OR REPLACE VIEW `<PROJECT_ID>.netflix_analytical.vw_ratings_heatmap` AS
SELECT
  EXTRACT(YEAR FROM rating_ts) AS year,
  EXTRACT(MONTH FROM rating_ts) AS month_number,
  FORMAT_TIMESTAMP('%b', rating_ts) AS month_name,
  COUNT(*) AS total_ratings
FROM `<PROJECT_ID>.netflix_analytical.fact_ratings`
GROUP BY year, month_number, month_name
ORDER BY year, month_number;


-- ====================================================
-- MOSTRAR FILMES COM PELO MENOS 50 AVALIAÇÕES 
-- ====================================================
CREATE OR REPLACE VIEW `<PROJECT_ID>.netflix_analytical.vw_scatter_ppularity_vs_quality` AS
SELECT
  movie_id,
  title,
  genres,
  release_year,
  total_ratings,
  avg_rating
FROM `<PROJECT_ID>.netflix_analytical.vw_movies_kpis`
WHERE total_ratings >= 50

