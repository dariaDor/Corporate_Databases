SELECT
    f.film_id,
    f.title,
    g.name AS genre
FROM films f
JOIN film_genre fg ON f.film_id = fg.film_id
JOIN genres g ON fg.genre_id = g.genre_id
WHERE g.name = 'Action';

SELECT
    f.title,
    a.name AS actor_name
FROM films f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actors a ON fa.actor_id = a.actor_id
WHERE f.title = 'Film 500';

SELECT
    film_id,
    title,
    score_rating
FROM films
ORDER BY score_rating DESC;

SELECT
    fd.country,
    AVG(fd.budget) AS avg_budget
FROM film_details fd
GROUP BY fd.country
ORDER BY avg_budget DESC;

SELECT
    a.actor_id,
    a.name,
    COUNT(fa.film_id) AS total_films
FROM actors a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.name
ORDER BY total_films DESC;