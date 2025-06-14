--1. Crea el esquema de la BBDD.
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
SELECT  A.FIRST_NAME , A.LAST_NAME 
FROM ACTOR AS A 
INNER JOIN FILM_ACTOR AS FA 
	ON A.ACTOR_ID = FA.ACTOR_ID 
INNER JOIN FILM AS F 
	ON FA.FILM_ID = F.FILM_ID 
WHERE F.TITLE = 'EGG IGBY';


-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT TITLE
FROM FILM AS F 
ORDER BY TITLE ;


-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 
-- 180 minutos en la tabla “film”.
SELECT F.TITLE , F.LENGTH 
FROM FILM AS F 
INNER JOIN FILM_CATEGORY AS FC 
	ON F.FILM_ID = FC.FILM_ID 
INNER JOIN CATEGORY AS C 
	ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Comedy' AND F.LENGTH >180;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos 
-- y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c.name , AVG(F.LENGTH) AS AVERAGE_LENGTH
FROM FILM AS F 
INNER JOIN FILM_CATEGORY AS FC 
	ON F.FILM_ID = FC.FILM_ID 
INNER JOIN CATEGORY AS C 
	ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE F.LENGTH > (
	SELECT AVG(LENGTH)FROM FILM AS F2
		) 
GROUP BY C.name ;


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

