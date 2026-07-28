-- ===================================================
-- MOVIES
-- ======================================================
CREATE OR REPLACE EXTERNAL TABLE `<PROJECT_ID>.netflix_raw.raw_movies`
(
  movieID STRING,
  title STRING,
  genres STRING
)
OPTIONS(
  format = 'CSV',
  uris = ['gs://<BUCKET_NAME>/bronze/movies.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- USER RATING HISTORY
-- ======================================================
CREATE OR REPLACE EXTERNAL TABLE `<PROJECT_ID>.netflix_raw.raw_user_rating_history`
(
  userID STRING,
  movieID STRING,
  rating STRING,
  tstamp STRING,
)
OPTIONS(
  format = 'CSV',
  uris = ['gs://<BUCKET_NAME>/bronze/user_rating_history.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- USER ADDITIONAL RATING
-- ======================================================
CREATE OR REPLACE EXTERNAL TABLE `<PROJECT_ID>.netflix_raw.raw_user_additional_rating`
(
  userID STRING,
  movieID STRING,
  rating STRING,
  tstamp STRING,
)
OPTIONS(
  format = 'CSV',
  uris = ['gs://<BUCKET_NAME>/bronze/ratings_for_additional_users.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- BELIEF DATA
-- ======================================================
CREATE OR REPLACE EXTERNAL TABLE `<PROJECT_ID>.netflix_raw.raw_belief_data`
(
  userID STRING,
  movieID STRING,
  isSeen STRING,
  watchDate STRING,
  userElicitRating STRING,
  userPredictRating STRING,
  userCertainty STRING,
  tstamp STRING,
  month_idx STRING,
  source STRING,
  systemPredictRating STRING,
)
OPTIONS(
  format = 'CSV',
  uris = ['gs://<BUCKET_NAME>/bronze/belief_data.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- MOVIE ELICITATION SET
-- ======================================================
CREATE OR REPLACE EXTERNAL TABLE `<PROJECT_ID>.netflix_raw.raw_movie_elicitation_set`
(
  movieID STRING,
  tstamp STRING,
  month_idx STRING,
  source STRING,
)
OPTIONS(
  format = 'CSV',
  uris = ['gs://<BUCKET_NAME>/bronze/movie_elicitation_set.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- USER RECOMMENDATION HISTORY
-- ======================================================
CREATE OR REPLACE EXTERNAL TABLE `<PROJECT_ID>.netflix_raw.raw_user_recommendation_history`
(
  userID STRING,
  movieID STRING,
  tstamp STRING,
  predictedRating STRING,
)
OPTIONS(
  format = 'CSV',
  uris = ['gs://<BUCKET_NAME>/bronze/user_recommendation_history.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);