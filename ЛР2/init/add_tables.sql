CREATE TABLE actors (
    actor_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    birthday DATE
);

CREATE TABLE genres (
    genre_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE films (
    film_id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    score_rating NUMERIC(4,2) DEFAULT 0
);

CREATE TABLE film_details (
    film_id BIGINT PRIMARY KEY REFERENCES films(film_id) ON DELETE CASCADE,
    budget BIGINT CHECK (budget >= 0),
    release_year INTEGER CHECK (release_year >= 1900),
    duration_minutes INTEGER CHECK (duration_minutes > 0),
    country VARCHAR(100),
    age_rating INT
);

CREATE TABLE film_actor (
    film_id BIGINT REFERENCES films(film_id) ON DELETE CASCADE,
    actor_id BIGINT REFERENCES actors(actor_id) ON DELETE CASCADE,
    PRIMARY KEY (film_id, actor_id)
);

CREATE TABLE film_genre (
    film_id BIGINT REFERENCES films(film_id) ON DELETE CASCADE,
    genre_id BIGINT REFERENCES genres(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (film_id, genre_id)
);