
CREATE OR REPLACE FUNCTION random_film_id()
RETURNS BIGINT AS $$
DECLARE
    min_id BIGINT;
    max_id BIGINT;
BEGIN
    SELECT MIN(film_id), MAX(film_id) INTO min_id, max_id FROM films;
    RETURN min_id + floor(random() * (max_id - min_id + 1))::BIGINT;
END;
$$ LANGUAGE plpgsql STABLE;


CREATE OR REPLACE FUNCTION generate_actors(count_actors INTEGER)
RETURNS VOID AS $$
BEGIN
    INSERT INTO actors(name, birthday)
    SELECT
        'Actor ' || gs,
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
        ('Crime')
    ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_films(film_count INTEGER)
RETURNS VOID AS $$
DECLARE
    i INTEGER;
    generated_film_id BIGINT;
BEGIN
    FOR i IN 1..film_count LOOP
        INSERT INTO films(title, description, score_rating)
        VALUES (
            'Film ' || i,
            'Description for film ' || i,
            ROUND((random() * 10)::numeric, 2)
        )
        RETURNING film_id INTO generated_film_id;

        INSERT INTO film_details(
            film_id, budget, release_year,
            duration_minutes, country, age_rating
        )
        VALUES (
            generated_film_id,
            (1000000 + random() * 500000000)::BIGINT,
            (1980 + random() * 45)::INTEGER,
            (100  + random() * 60)::INTEGER,
            (ARRAY[
                'Russia','USA','UK','France',
                'Germany','Japan','Canada','India'
            ])[floor(random() * 8 + 1)],
            (ARRAY[0, 6, 12, 14, 16, 18, 21])[floor(random() * 7 + 1)]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_film_actor(actors_per_film INTEGER DEFAULT 5)
RETURNS VOID AS $$
DECLARE
    min_actor BIGINT;
    max_actor BIGINT;
    rec       RECORD;
    j         INTEGER;
    aid       BIGINT;
BEGIN
    SELECT MIN(actor_id), MAX(actor_id) INTO min_actor, max_actor FROM actors;

    FOR rec IN SELECT film_id FROM films LOOP
        j := 0;
        WHILE j < actors_per_film LOOP
            aid := min_actor + floor(random() * (max_actor - min_actor + 1))::BIGINT;
            INSERT INTO film_actor(film_id, actor_id)
            VALUES (rec.film_id, aid)
            ON CONFLICT DO NOTHING;
            -- считаем только успешные вставки
            IF FOUND THEN
                j := j + 1;
            END IF;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_film_genre(genres_per_film INTEGER DEFAULT 2)
RETURNS VOID AS $$
DECLARE
    rec      RECORD;
    j        INTEGER;
    gid      BIGINT;
BEGIN
    FOR rec IN SELECT film_id FROM films LOOP
        j := 0;
        WHILE j < genres_per_film LOOP
            gid := 1 + floor(random() * 10)::BIGINT;  -- genre_id от 1 до 10
            INSERT INTO film_genre(film_id, genre_id)
            VALUES (rec.film_id, gid)
            ON CONFLICT DO NOTHING;
            IF FOUND THEN
                j := j + 1;
            END IF;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;