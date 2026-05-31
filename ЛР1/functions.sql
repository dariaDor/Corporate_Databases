CREATE OR REPLACE FUNCTION generate_actors(count_actors INTEGER)
RETURNS VOID AS $$
BEGIN
    INSERT INTO actors(name, birthday)
    SELECT
        gs,
        CURRENT_DATE - ((random() * 70000)::INTEGER)
    FROM generate_series(1, count_actors) gs;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_genres()
RETURNS VOID AS $$
BEGIN
    INSERT INTO genres(name)
    VALUES
    ('Action'),
    ('Drama'),
    ('Comedy'),
    ('Fantasy'),
    ('Sci-Fi'),
    ('Thriller'),
    ('Horror'),
    ('Anime'),
    ('Documentary'),
    ('Crime');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_films(film_count INTEGER)
RETURNS VOID AS $$

DECLARE
    generated_film_id BIGINT;
    i INTEGER;

BEGIN
    FOR i IN 1..film_count LOOP

        INSERT INTO films(
            title,
            description,
            score_rating
        )VALUES (
            'Film ' || i,
            'Description for film ' || i,
            ROUND((random() * 10)::numeric, 2)
        )
        RETURNING film_id INTO generated_film_id;

        INSERT INTO film_details(
            film_id,
            budget,
            release_year,
            duration_minutes,
            country,
            age_rating
        )
        VALUES (
            generated_film_id,
            (1000000 + random() * 500000000)::BIGINT,
            (1980 + random() * 45)::INTEGER,
            (100 + random() * 60)::INTEGER,
            (ARRAY[
                    'Russia',
                    'USA',
                    'UK',
                    'France',
                    'Germany',
                    'Japan',
                    'Canada',
                    'India'
                ]
            )[floor(random() * 8 + 1)],
            (ARRAY[0, 6, 12, 14, 16, 18, 21])[floor(random() * 7 + 1)]
        );

    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_film_actor(film_count INTEGER)
RETURNS VOID AS $$
DECLARE
    batch_size INTEGER := 10000;
    inserted   INTEGER := 0;
BEGIN
    WHILE inserted < film_count LOOP
        INSERT INTO film_actor(film_id, actor_id)
        SELECT DISTINCT
            films.film_id,
            actors.actor_id
        FROM generate_series(1, LEAST(batch_size, film_count - inserted)) AS gs
        CROSS JOIN LATERAL (SELECT film_id  FROM films  ORDER BY random() LIMIT 1) AS films
        CROSS JOIN LATERAL (SELECT actor_id FROM actors ORDER BY random() LIMIT 1) AS actors
        ON CONFLICT DO NOTHING;

        inserted := inserted + LEAST(batch_size, film_count - inserted);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_film_genre(film_count INTEGER)
RETURNS VOID AS $$
DECLARE
    batch_size INTEGER := 10000;
    inserted   INTEGER := 0;
BEGIN
    WHILE inserted < film_count LOOP
        INSERT INTO film_genre(film_id, genre_id)
        SELECT DISTINCT
            films.film_id,
            (1 + floor(random() * 10))::BIGINT AS genre_id
        FROM generate_series(1, LEAST(batch_size, film_count - inserted)) AS gs
        CROSS JOIN LATERAL (SELECT film_id FROM films ORDER BY random() LIMIT 1) AS films
        ON CONFLICT DO NOTHING;

        inserted := inserted + LEAST(batch_size, film_count - inserted);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
