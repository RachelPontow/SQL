USE sakila;
-- 1a
SELECT first_name, last_name
FROM actor;
-- 1b
SELECT first_name, last_name,
CONCAT(first_name," ",last_name) AS 'Actor Name'
FROM actor;
-- 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE';
-- 2b
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';
-- 2c
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;
-- 2d
SELECT country_id, country
FROM country 
WHERE country IN('Afghanistan','Bangladesh','China');
-- 3a
ALTER TABLE actor ADD middle_name VARCHAR(255) AFTER first_name;
SELECT*FROM actor;
-- 3b
ALTER TABLE actor MODIFY middle_name BLOB;
-- 3c
ALTER TABLE actor DROP middle_name;
-- 4a
SELECT last_name,
COUNT(first_name) AS 'Number of Actors'
FROM actor
GROUP BY last_name;
-- 4b
SELECT last_name,
COUNT(first_name) AS 'Number of Actors'
FROM actor
GROUP BY last_name
HAVING COUNT(first_name) > 2;
-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- 4d
 UPDATE actor
 SET first_name = 
 CASE 
 WHEN first_name = 'HARPO' 
 THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
 END
 WHERE actor_id = 172;
-- 5a
SHOW CREATE TABLE address;
-- 6a
SELECT s.first_name, s.last_name, a.address
FROM staff s 
LEFT JOIN address a 
ON s.address_id = a.address_id;
-- 6b
SELECT s.first_name, s.last_name, SUM(p.amount) AS "Total for August 2005"
FROM staff s
JOIN payment p
USING (staff_id)
WHERE p.payment_date LIKE '2005-08%';
-- 6c
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;
-- 6d
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";
-- 6e
SELECT last_name, first_name, SUM(amount)
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id;
-- 7a
SELECT title FROM film
WHERE language_id in
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");
-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	 SELECT actor_id
     FROM film_actor
     WHERE film_id IN
		(
		 SELECT film_id
         FROM film
         WHERE title = 'Alone Trip'
         )
	);
-- 7c
SELECT cu.first_name, cu.last_name, cu.email 
FROM customer cu 
LEFT JOIN address a 
ON cu.address_id = a.address_id 
LEFT JOIN city cy 
ON a.city_id = cy.city_id 
LEFT JOIN country co 
ON cy.country_id = co.country_id 
WHERE co.country = 'Canada';
-- 7d
SELECT title, category
FROM film_list
WHERE category = 'Family';
-- 7e
SELECT title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Count_of_Rented_Movies DESC;
-- 7f
SELECT s.store_id, SUM(p.amount) 
FROM payment p
JOIN staff s ON (p.staff_id=s.staff_id)
GROUP BY store_id;
-- 7g
SELECT store_id, city, country 
FROM store s
JOIN address a ON (s.address_id=a.address_id)
JOIN city c ON (a.city_id=c.city_id)
JOIN country cu ON (c.country_id=cu.country_id);
-- 7h
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
-- 8a
CREATE OR REPLACE VIEW top_five_genres AS
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
-- 8b
SELECT * FROM top_five_genres;
-- 8c
DROP VIEW top_five_genres;