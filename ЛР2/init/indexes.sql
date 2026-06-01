CREATE INDEX idx_films_title ON films(title);
CREATE INDEX idx_films_score ON films(score_rating);
CREATE INDEX idx_film_actor_film ON film_actor(film_id);
CREATE INDEX idx_film_actor_actor ON film_actor(actor_id);
CREATE INDEX idx_film_genre_film ON film_genre(film_id);
CREATE INDEX idx_film_genre_genre ON film_genre(genre_id);
CREATE INDEX idx_films_score_rating ON films(score_rating DESC);
CREATE INDEX idx_film_details_country_budget ON film_details(country, budget);