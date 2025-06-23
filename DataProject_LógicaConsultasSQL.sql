-- 1. Crea el esquema de la BBDD.
	-- Se encuentra en el repositorio con el nombre de Proyecto-SQL - Esquema.png


-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
SELECT TITLE 
FROM FILM AS F 
WHERE RATING = 'R';


-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT ACTOR_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) 
FROM ACTOR AS A 
WHERE ACTOR_ID BETWEEN 30 AND 40;


-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT TITLE 
FROM FILM AS F 
WHERE LANGUAGE_ID = ORIGINAL_LANGUAGE_ID;
		--Aqui la consulta no saca ningun valor ya que estan como null, asi que entiendo que ningun 
		--idioma se ha modificado. Se podria poner un OR ORIGINAL_LANGUAGE_ID = NULL ya que da a entender eso
		--y aparecerian todas las peliculas que no han sido modificadas.


-- 5. Ordena las películas por duración de forma ascendente.
SELECT FILM_ID ,TITLE ,LENGTH 
FROM FILM AS F 
ORDER BY LENGTH, TITLE;


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT FIRST_NAME ,LAST_NAME 
FROM ACTOR AS A 
WHERE LAST_NAME LIKE '%ALLEN%';


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
SELECT RATING ,COUNT(RATING) AS NUMBER_OF_FILMS
FROM FILM AS F 
GROUP BY RATING ;


-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT TITLE ,RATING ,LENGTH
FROM FILM AS F 
WHERE RATING = 'PG-13' OR LENGTH > 180
ORDER BY RATING ,LENGTH;


-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT VARIANCE(REPLACEMENT_COST) AS VARIANCE_REPLACEMENT_COST
FROM FILM AS F ;


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT MAX(LENGTH) as MAX_LENGTH, MIN(LENGTH) as MIN_LENGTH 
FROM FILM AS F ;


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT AMOUNT 
FROM PAYMENT AS P 
ORDER BY PAYMENT_DATE DESC 
OFFSET 2
LIMIT 1;


-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
SELECT TITLE, RATING 
FROM FILM AS F 
WHERE RATING NOT IN (
	SELECT RATING
	FROM FILM
	WHERE RATING = 'NC-17' OR RATING = 'G'
	)
ORDER BY RATING ,TITLE ;


-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación 
-- junto con el promedio de duración.
SELECT RATING, AVG(LENGTH) AS AVERAGE_DURATION
FROM FILM AS F 
GROUP BY RATING ;


-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT TITLE , LENGTH 
FROM FILM AS F 
WHERE LENGTH >180
ORDER BY LENGTH , TITLE ;


-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(AMOUNT) AS TOTAL_AMOUNT
FROM PAYMENT AS P ;


-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT  CUSTOMER_ID, FIRST_NAME , LAST_NAME
FROM CUSTOMER AS C 
ORDER BY CUSTOMER_ID DESC 
LIMIT 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
	--Creamos una vista del enlace entre las tablas ya que vamos a usarlo varias veces en los ejercicios.
 CREATE VIEW ACTOR_FILM AS 
	SELECT A.FIRST_NAME, A.LAST_NAME, A.ACTOR_ID, F.FILM_ID
	FROM ACTOR AS A 
	INNER JOIN FILM_ACTOR AS FA 
		ON A.ACTOR_ID = FA.ACTOR_ID
	INNER JOIN FILM AS F 
		ON FA.FILM_ID = F.FILM_ID ;

SELECT AF.FIRST_NAME ,AF.LAST_NAME 
FROM ACTOR_FILM AS AF 
WHERE AF.TITLE = 'EGG IGBY';


-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT TITLE
FROM FILM AS F 
ORDER BY TITLE ;


-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 
-- 180 minutos en la tabla “film”.
	--Creamos una vista del enlace entre las tablas ya que vamos a usarlo varias veces en los ejercicios.
CREATE VIEW CATEGORY_FILMS AS 
SELECT F.FILM_ID ,F.TITLE , F.LENGTH,F.RELEASE_YEAR ,c."name" 
	FROM FILM AS F 
	INNER JOIN FILM_CATEGORY AS FC 
		ON F.FILM_ID = FC.FILM_ID
	INNER JOIN CATEGORY AS C 
		ON FC.CATEGORY_ID = C.CATEGORY_ID ;

SELECT CF.TITLE , CF.LENGTH 
FROM CATEGORY_FILMS AS CF 
WHERE CF."name" = 'Comedy' AND CF.LENGTH >180;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos 
-- y muestra el nombre de la categoría junto con el promedio de duración.
SELECT CF.name , AVG(CF.LENGTH) AS AVERAGE_LENGTH
FROM CATEGORY_FILMS AS CF 
WHERE CF.LENGTH > (
	SELECT AVG(LENGTH)FROM CATEGORY_FILMS AS CF2 
		) 
GROUP BY CF.name 
ORDER BY CF."name" ;


-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT ROUND(AVG(RENTAL_DURATION)) AS AVERAGE_RENTAL_DURATION
FROM FILM AS F ;


-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(FIRST_NAME, ' ',LAST_NAME) AS FULL_NAME
from ACTOR AS A;


-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT RENTAL_DATE ,RENTAL_ID ,COUNT(RENTAL_ID) AS TIMES_RENTED
FROM RENTAL AS R 
GROUP BY RENTAL_DATE,RENTAL_ID 
ORDER BY RENTAL_DATE DESC;


-- 24. Encuentra las películas con una duración superior al promedio.
SELECT TITLE ,LENGTH 
FROM FILM AS F 
WHERE LENGTH > (
	SELECT AVG(LENGTH)
	FROM FILM AS F2 
)
ORDER BY LENGTH ;


-- 25. Averigua el número de alquileres registrados por mes.
SELECT COUNT(RENTAL_ID) AS TOTAL_PER_MONTH,
		EXTRACT(MONTH FROM RENTAL_DATE) AS RENTAL_MONTH
FROM RENTAL AS R 
GROUP by RENTAL_MONTH
ORDER BY RENTAL_MONTH ;


-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT 
    AVG(P.AMOUNT) AS AVERAGE_AMOUNT,
    STDDEV(P.AMOUNT) AS STANDARD_DEVIATION,
    VARIANCE(P.AMOUNT) AS VARIANCE_AMOUNT
FROM PAYMENT AS P;


-- 27. ¿Qué películas se alquilan por encima del precio medio?
WITH average_price AS (
  SELECT AVG(amount) AS media FROM payment
),

movies_with_prices AS (
  SELECT f.title, p.amount
  FROM film f
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  JOIN payment p ON r.rental_id = p.rental_id
)

SELECT DISTINCT title
FROM movies_with_prices, average_price
WHERE movies_with_prices.amount > average_price.media
ORDER BY title;


-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT AF.ACTOR_ID, AF.FIRST_NAME, AF.LAST_NAME, COUNT(AF.FILM_ID) AS TOTAL_MOVIES
FROM ACTOR_FILM AS AF 
GROUP BY AF.ACTOR_ID, AF.FIRST_NAME, AF.LAST_NAME
HAVING COUNT(AF.FILM_ID) > 40;


--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT F.FILM_ID, F.TITLE, COUNT(I.INVENTORY_ID) AS COPIAS_DISPONIBLES
FROM FILM AS F
LEFT JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
GROUP BY F.FILM_ID, F.TITLE
ORDER BY F.TITLE;


-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT AF.FIRST_NAME , AF.LAST_NAME, COUNT(AF.FILM_ID) AS ACTING_IN_MOVIES
from ACTOR_FILM AS AF 
GROUP BY AF.FIRST_NAME ,AF.LAST_NAME ;


-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT F.TITLE, A.FIRST_NAME, A.LAST_NAME
FROM FILM AS F 
LEFT JOIN FILM_ACTOR AS FA 
	ON F.FILM_ID = FA.FILM_ID
LEFT JOIN ACTOR AS A 
	ON FA.ACTOR_ID  = A.ACTOR_ID
ORDER BY F.TITLE ;


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT A.FIRST_NAME, A.LAST_NAME, F.TITLE
FROM ACTOR AS A 
RIGHT JOIN FILM_ACTOR AS FA 
	ON A.ACTOR_ID = FA.ACTOR_ID
RIGHT JOIN FILM AS F 
	ON FA.FILM_ID = F.FILM_ID
ORDER BY A.FIRST_NAME, A.LAST_NAME, F.TITLE;


-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT F.TITLE, R.RENTAL_ID, R.RENTAL_DATE
FROM RENTAL AS R
RIGHT JOIN INVENTORY AS I 
    ON R.INVENTORY_ID = I.INVENTORY_ID
RIGHT JOIN FILM AS F 
    ON I.FILM_ID = F.FILM_ID
ORDER BY F.TITLE;



-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, P.AMOUNT
FROM CUSTOMER AS C 
JOIN PAYMENT AS P 
	ON C.CUSTOMER_ID = P.PAYMENT_ID
ORDER BY P.AMOUNT DESC LIMIT 5;


-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT *
FROM ACTOR AS A 
WHERE A.FIRST_NAME LIKE '%JOHNNY%';
	--En este caso lo he hecho asi, porque de esta forma, si en un futuro se introduce un nombre compuesto en la BBDD se contemplaria tambien.


-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT A.FIRST_NAME AS NOMBRE, A.LAST_NAME AS APELLIDO
FROM ACTOR AS A;


-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN(A.ACTOR_ID) AS FIRST_ACTOR, MAX(A.ACTOR_ID) AS LAST_ACTOR
FROM ACTOR AS A;


-- 38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(A.ACTOR_ID ) AS TOTAL_ACTORS
FROM ACTOR AS A;


-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT *
FROM ACTOR AS A
ORDER BY A.LAST_NAME ASC;


-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT *
FROM FILM AS F 
ORDER BY F.FILM_ID ASC LIMIT 5;


-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT A.FIRST_NAME, COUNT(A.FIRST_NAME) AS COUNTER_OF_NAMES 
FROM ACTOR AS A 
GROUP BY A.FIRST_NAME
ORDER BY COUNTER_OF_NAMES DESC , A.FIRST_NAME;
	-- Los nombres mas repetidos son: JULIA, KENNETH Y PENELOPE.


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT R.RENTAL_ID, C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME
FROM RENTAL AS R 
LEFT JOIN CUSTOMER AS C 
	ON R.CUSTOMER_ID = C.CUSTOMER_ID
ORDER BY C.FIRST_NAME;


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, R.RENTAL_ID
FROM CUSTOMER AS C 
LEFT JOIN RENTAL AS R 
	ON C.CUSTOMER_ID = R.CUSTOMER_ID
ORDER BY C.FIRST_NAME;


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select *
FROM FILM AS F 
CROSS JOIN CATEGORY AS C ;
	-- Esta consulta no aportaria valor, ya que el cross join realiza todas las combinaciones posibles,sin hacer distinciones y en este caso, 
	-- no tiene sentido que te muestre que una pelicula esta en una categoria a la cual no pertence en realidad.


-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT AF.FIRST_NAME, AF.LAST_NAME
FROM ACTOR_FILM AS AF 
INNER JOIN CATEGORY_FILMS AS CF 
	ON AF.FILM_ID = CF.FILM_ID
WHERE CF."name" = 'Action'
ORDER BY AF.FIRST_NAME  ;


-- 46. Encuentra todos los actores que no han participado en películas.
SELECT A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME, FA.ACTOR_ID
FROM ACTOR AS A 
LEFT JOIN FILM_ACTOR AS FA 
	ON A.ACTOR_ID = FA.ACTOR_ID
WHERE FA.ACTOR_ID IS NULL ;


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT DISTINCT A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME, FA.ACTOR_ID
FROM ACTOR AS A 
LEFT JOIN FILM_ACTOR AS FA 
	ON A.ACTOR_ID = FA.ACTOR_ID
WHERE FA.ACTOR_ID IS NULL ;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW ACTOR_NUM_PELICULAS AS 
	SELECT A.FIRST_NAME, A.LAST_NAME, A.ACTOR_ID, COUNT(F.FILM_ID) AS NUMBER_OF_FILMS
	FROM ACTOR AS A 
	INNER JOIN FILM_ACTOR AS FA 
		ON A.ACTOR_ID = FA.ACTOR_ID
	INNER JOIN FILM AS F 
		ON FA.FILM_ID = F.FILM_ID 
	GROUP BY A.ACTOR_ID
	ORDER BY A.ACTOR_ID;


-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, COUNT(R.RENTAL_ID) AS TOTAL_RENTALS
FROM CUSTOMER AS C 
INNER JOIN RENTAL AS R 
ON C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY C.CUSTOMER_ID;


-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(CF.LENGTH) AS TOTAL_LENGTH
FROM CATEGORY_FILMS AS CF 
WHERE CF."name" = 'Action';


-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE CLIENTE_RENTAS_TEMPORAL AS 
	SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, COUNT(R.RENTAL_ID) AS TOTAL_RENTALS
	FROM CUSTOMER AS C 
	INNER JOIN RENTAL AS R 
	ON C.CUSTOMER_ID = R.CUSTOMER_ID
	GROUP BY C.CUSTOMER_ID;

SELECT *
FROM CLIENTE_RENTAS_TEMPORAL AS CRT
ORDER BY CRT.CUSTOMER_ID;


-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE PELICULAS_ALQUILADAS AS 
	SELECT F.TITLE, COUNT(R.RENTAL_ID) AS TIMES_RENTED
	FROM FILM AS F
	INNER JOIN INVENTORY AS I 
   	 ON F.FILM_ID = I.FILM_ID
	INNER JOIN RENTAL AS R 
  	  ON I.INVENTORY_ID = R.INVENTORY_ID
	GROUP BY F.TITLE
	HAVING COUNT(R.RENTAL_ID) > 10;

SELECT *
FROM PELICULAS_ALQUILADAS AS PA
ORDER BY PA.TITLE;


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
-- los resultados alfabéticamente por título de película.
SELECT F.TITLE,R.RETURN_DATE
FROM FILM AS F 
INNER JOIN INVENTORY AS I 
	ON F.FILM_ID = I.FILM_ID
INNER JOIN RENTAL AS R 
	ON I.INVENTORY_ID = R.INVENTORY_ID
INNER JOIN CUSTOMER AS C 
	ON R.CUSTOMER_ID = C.CUSTOMER_ID
WHERE C.FIRST_NAME = 'TAMMY' AND C.LAST_NAME = 'SANDERS' AND R.RETURN_DATE IS NOT NULL ;


-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
-- alfabéticamente por apellido.
SELECT DISTINCT AF.FIRST_NAME,AF.LAST_NAME
FROM ACTOR_FILM AS AF 
INNER JOIN CATEGORY_FILMS AS CF 
ON AF.FILM_ID = CF.FILM_ID 
WHERE CF."name" = 'Sci-Fi'
ORDER BY AF.LAST_NAME;


-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus
-- Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
WITH PRIMER_ALQUILER AS (
    SELECT MIN(R2.RENTAL_DATE) AS DATE_MIN
    FROM FILM AS F
    INNER JOIN INVENTORY AS I2 
    	ON F.FILM_ID = I2.FILM_ID
    INNER JOIN RENTAL AS R2 
    	ON I2.INVENTORY_ID = R2.INVENTORY_ID
    WHERE F.TITLE = 'SPARTACUS CHEAPER'
)

SELECT DISTINCT AF.FIRST_NAME, AF.LAST_NAME
FROM ACTOR_FILM AS AF
INNER JOIN INVENTORY AS I 
	ON AF.FILM_ID = I.FILM_ID
INNER JOIN RENTAL AS R 
	ON I.INVENTORY_ID = R.INVENTORY_ID
INNER JOIN PRIMER_ALQUILER AS PA 
ON R.RENTAL_DATE > PA.DATE_MIN
ORDER BY AF.LAST_NAME;
 


-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT DISTINCT AF.FIRST_NAME,AF.LAST_NAME
FROM ACTOR_FILM AS AF 
INNER JOIN CATEGORY_FILMS AS CF 
	ON AF.FILM_ID = CF.FILM_ID 
WHERE CF."name" NOT IN ('Music')
ORDER BY AF.LAST_NAME;


-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT F.TITLE, (R.RETURN_DATE - R.RENTAL_DATE) AS RENTAL_TIME
FROM RENTAL AS R 
INNER JOIN INVENTORY AS I 
	ON R.INVENTORY_ID = I.INVENTORY_ID
INNER JOIN FILM AS F 
	ON I.FILM_ID = F.FILM_ID 
WHERE R.RETURN_DATE IS NOT NULL 
  AND (R.RETURN_DATE - R.RENTAL_DATE) > INTERVAL '8 days';


-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT CF.TITLE
FROM CATEGORY_FILMS AS CF 
WHERE CF."name" = 'Animation';


-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. 
-- Ordena los resultados alfabéticamente por título de película.
SELECT F.TITLE,F.LENGTH
FROM FILM AS F 
WHERE LENGTH = (
    SELECT LENGTH
    FROM FILM
    WHERE TITLE = 'DANCING FEVER'
)
ORDER BY F.TITLE ;


-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. 
-- Ordena los resultados alfabéticamente por apellido.
SELECT C.CUSTOMER_ID,C.FIRST_NAME ,C.LAST_NAME,COUNT(I.FILM_ID) AS NUMBER_OF_FILMS
FROM CUSTOMER AS C 
INNER JOIN RENTAL AS R 
	ON C.CUSTOMER_ID = R.CUSTOMER_ID
INNER JOIN INVENTORY AS I 
	ON R.INVENTORY_ID = I.INVENTORY_ID
GROUP BY C.CUSTOMER_ID ,C.FIRST_NAME,C.LAST_NAME
HAVING COUNT(I.FILM_ID) >=7
ORDER BY C.LAST_NAME;


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT CF."name", COUNT(R.RENTAL_ID) AS RENTALS
FROM CATEGORY_FILMS AS CF 
INNER JOIN INVENTORY AS I 
	ON  CF.FILM_ID = I.FILM_ID
INNER JOIN RENTAL AS R 
	ON I.INVENTORY_ID = R.INVENTORY_ID
GROUP BY CF."name"; 


-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT CF."name", COUNT(CF.FILM_ID) AS NUMBER_OF_FILMS
FROM CATEGORY_FILMS AS CF
WHERE CF.RELEASE_YEAR = 2006
GROUP BY CF."name" ;


-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT *
FROM STAFF AS S 
CROSS JOIN STORE AS S2 ;


-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de
-- películas alquiladas.
SELECT C.CUSTOMER_ID ,C.FIRST_NAME, C.LAST_NAME, COUNT(R.RENTAL_ID) AS NUMBER_OF_FILMS
FROM CUSTOMER AS C 
INNER JOIN RENTAL AS R 
	ON C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY C.CUSTOMER_ID; 