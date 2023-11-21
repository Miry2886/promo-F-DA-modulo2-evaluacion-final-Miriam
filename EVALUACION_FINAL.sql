USE sakila;

-- 1 Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT distinct`title`
FROM `film`; 

-- 2 Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT `title`, `rating`
FROM `film`
WHERE `rating`= "PG-13";

-- 3 Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. 

SELECT `title`, `description`
FROM `film`
WHERE `description` LIKE '%amazing%' OR `description` LIKE '%Amazing%';

-- 4 Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT `title`, `length`
FROM `film`
WHERE `length`>= 120;

-- 5 Recupera los nombres de todos los actores.
SELECT `first_name`
FROM `actor`;

-- 6 Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT `first_name`, `last_name`
FROM `actor`
WHERE `last_name` LIKE '%Gibson%';

-- 7 Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT `first_name`, `last_name`, `actor_id`
FROM `actor`
WHERE `actor_id`BETWEEN 10 AND 20;

-- 8 Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT `title`, `rating`
FROM `film`
WHERE `rating` NOT IN ("PG-13", "R");

-- 9 Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT `rating`, COUNT(`rating`) 
FROM `film` 
GROUP BY `rating`;

-- 10 Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
-- su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT `customer`.`customer_id`, `customer`.`first_name`, `customer`.`last_name`, COUNT(`rental`.`rental_id`)
FROM `customer` 
INNER JOIN `rental` 
ON `customer`.`customer_id` = `rental`.`customer_id` 
GROUP BY `customer`.`customer_id`;

-- 11 Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre 
-- de la categoría junto con el recuento de alquileres.
-- (select me pide el category name de **category** y la suma de las pelis alquiladas de **rental** por el rental id
-- tengo q sacar de **film category** el film id y el category id
-- tengo q juntarlo con el film id de **rental**)

SELECT `category`.`name`, COUNT(`rental`.`rental_id`) 
FROM `category` 
INNER JOIN `film_category` 
ON `category`.`category_id` = `film_category`.`category_id`; 


-- 12 Encuentra el promedio de duración de las películas para cada 
-- clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT `rating`, avg (length) as promedioduración
FROM `film`
GROUP BY `rating`;

-- 13 Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT actor.first_name, actor.last_name
FROM actor
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
JOIN film 
ON film.film_id = film_actor.film_id
WHERE film.title = 'Indian Love';



-- 14 Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT `title`, `description`
FROM `film`
WHERE `description` LIKE '%DOG%' OR `description` LIKE '%dog%' or `description` LIKE '%cat%' OR `description` LIKE '%Cat%';

-- 15 Hay algún que no aparecen en ninguna película en la tabla film_actor. NO, NO HAY NULOS
SELECT `actor`.`first_name`, `actor`.`last_name`
FROM `actor`
LEFT JOIN `film_actor`
ON `actor`.`actor_id`= `film_actor`.`actor_id`
WHERE `film_actor`.`actor_id` IS NULL;

-- 16 Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT `title`,`release_year`
FROM `film`
WHERE `release_year`BETWEEN 2005 AND 2010;

-- 17 Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT `title`
FROM `film` 
WHERE `film_id` IN (SELECT `film_id` 
					FROM `film_category` 
                    WHERE `category_id` = (SELECT `category_id` 
											FROM `category` 
                                            WHERE `name` = 'Family'));


-- 18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
                    
SELECT `first_name`, `last_name`, COUNT(`film_actor`.`actor_id`)
FROM `actor` 
INNER JOIN `film_actor` 
ON `actor`.`actor_id` = `film_actor`.`actor_id` 
GROUP BY `actor`.`actor_id` 
HAVING COUNT(`film_actor`.`actor_id`) > 10;


-- 19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title, rating, length
FROM film 
WHERE rating = "R" and length > 120;


-- 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre 
-- de la categoría junto con el promedio de duración.
-- media duracion categorias >120

SELECT category.name AS 'Nombrecategoría', AVG (film.length) AS 'Promedioduración'
FROM film
JOIN film_category 
ON film.film_id = film_category.film_id
JOIN category 
ON category.category_id = film_category.category_id
WHERE category.category_id IN (SELECT film_category.category_id
								FROM film
								JOIN film_category ON film.film_id = film_category.film_id
								GROUP BY film_category.category_id
								HAVING AVG(film.length) > 120)
AND film.length > 120
GROUP BY category.name;


-- 21 Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto 
-- con la cantidad de películas en las que han actuado.
SELECT actor.first_name , actor.last_name , COUNT(*) AS Peliculas_en_las_que_ha_actuado
FROM actor
INNER JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(*) >= 5;

-- 22 Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
--  encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
SELECT film.title
FROM rental
INNER JOIN inventory
ON rental.inventory_id=inventory.inventory_id
INNER JOIN film
ON inventory.film_id=film.film_id
WHERE rental.rental_id IN (SELECT rental_id
						   FROM rental
						    WHERE DATEDIFF(return_date,rental_date)>5)
GROUP BY film.title;

-- 23 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría 
-- "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y
--  luego exclúyelos de la lista de actores.

SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id NOT IN (SELECT DISTINCT film_actor.actor_id
							 FROM film_actor
							 INNER JOIN film_category 
                             ON film_actor.film_id = film_category.film_id
							 JOIN category 
                             ON film_category.category_id = category.category_id
                             WHERE category.name = 'Horror');


-- 24 BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.




