
--Ejercicios DataProject

--1. Crea el esquema de la BBDD

/* 
 1. Crear nueva base de datos 
 2. Abrir la BD proporcionada y ejecutarla
 3. Refresh y analizar el esquema haciendo clic en public -> ver esquema
 */


--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ

select "title" as "Film title"
from "film"
where "rating" = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.

select concat("first_name", ' ', "last_name") as "Actor name"
from "actor"
where "actor_id" between 30 and 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.

select "film_id", "title"
from "film"
where "language_id" = "original_language_id";

--todos los campos de original language id son nulls

--5. Ordena las películas por duración de forma ascendente.

select "film_id", "title", "length"
from "film"
order by "length" asc;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.

select concat("first_name", ' ', "last_name") as "Actor name"
from "actor"
where "last_name" like '%ALLEN%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.

select "rating", count("film_id") as "number of films"
from "film"
group by "rating";

--8. Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.

select "title"
from "film"
where "rating" = 'PG-13' or "length" < 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select round(stddev("replacement_cost"),2) as "Variability of the cost of replacing the movies"
from "film";

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select max("length") as "maximun length", min("length") as "minimum length"
from film;

--11.Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select p."amount" as "cost of the third-to-last rental"
from "rental" r inner join "payment" p on p."rental_id" = r."rental_id"
order by "rental_date" desc
limit 1 offset 2;

--12 Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.

select "title"
from "film"
where "rating" not in ('G', 'NC-17');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

select "rating", round(avg("length"),2) as "Average length"
from film
group by "rating";

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select "title"
from "film"
where "length"> 180;

--15. ¿Cuánto dinero ha generado en total la empresa?

select round(sum("amount"),2) as "total amount of money earned"
from "payment";

--16. Muestra los 10 clientes con mayor valor de id.

select "customer_id", concat("first_name", ' ', "last_name") as "Customer name"
from "customer"
order by "customer_id" desc 
limit 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.

--opcion 1
select a."first_name", a."last_name" 
from "actor" a 
	inner join "film_actor" fa 
		on a."actor_id" = fa."actor_id"
	inner join "film" f
		on fa."film_id" = f."film_id"
where f."title" = 'EGG IGBY';

--opcion 2 
select a."first_name", a."last_name" 
from "actor" a 
	inner join "film_actor" fa 
		on a."actor_id" = fa."actor_id"
where fa."film_id" = (select "film_id"
						from film f where "title" = 'EGG IGBY')	;
					
--18. Selecciona todos los nombres de las películas únicos.
					
select count(distinct("title")) as "distinc film names"
from "film";
--comprobando la respuesta con un count normal, todos los títulos son únicos 

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.

select f."title"
from "film" f 
	inner join "film_category" fc on fc."film_id" = f."film_id"
	inner join "category" c on c."category_id" = fc."category_id"
where c."name" = 'Comedy' and f."length" > 180;

--opcion 2 
select f."title"
from "film" f 
	inner join "film_category" fc on fc."film_id" = f."film_id"
where fc."category_id" in (select "category_id"
							from "category" 
							where "name" = 'Comedy')
					   and f."length" > 180;
	
--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select "rating", round(avg("length"),2) as "lenght average"
from "film"
group by "rating"
having avg("length") > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?

select avg("return_date" - "rental_date") as " Average rental duration"
from "rental"

--24. Encuentra las películas con una duración superior al promedio.

select "title", "length"
from "film"
where "length" > (select avg("length") from film);

--25. Averigua el número de alquileres registrados por mes.

select count("rental_id") as "number of rentals", extract(month from "rental_date") as mes
from "rental"
group by "mes"


--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

select round(avg("amount"),2) as "average money paid", round(stddev("amount"),2) as "variability of money paid", round(variance("amount"),2) as "variance of money paid"
from "payment";

--27. ¿Qué películas se alquilan por encima del precio medio?


select i."film_id"
from "inventory" i 
	inner join "rental" r 
		on i."inventory_id" = r."inventory_id"
	inner join "payment" p 
		on p."rental_id" = r."rental_id"
where p."amount" > (select avg("amount")
					from "payment");

--si quisieramos el title juntariamos con otro join la tabla film 
				
--28. Muestra el id de los actores que hayan participado en más de 40 películas.

select "actor_id"
from "film_actor"
group by "actor_id"
having count("film_id") > 40;
			
--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select f."film_id", f."title", count(i."film_id") as "quantity"
from "film" as f
	left join "inventory" as i 
		on f."film_id" = i."film_id"
group by f."film_id";				

--30. Obtener los actores y el número de películas en las que ha actuado.

select "actor_id", count("film_id")
from "film_actor"
group by "actor_id";

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select f."film_id", f."title", fa."actor_id"
from "film" as f
	left join "film_actor" as fa
		on f."film_id" = fa."film_id";

	--Si queremos saber el numero de actores y no los nombres, podriamos hacer un count y agrupar para no tener peliculas repetidas:
	
select f."film_id", f."title",count(fa."actor_id")
from "film" as f
	left join "film_actor" as fa
		on f."film_id" = fa."film_id"
group by f."film_id";
	

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

select a."actor_id", concat(a."first_name", ' ', a."last_name") as "Actor name", fa."film_id"
from "actor" as a
	left join "film_actor" as fa
		on a."actor_id" = fa."actor_id";

-- igual que antes, si queremos saber número de peliculas en vez de que peluculas y asi no repetir actor id y su nombre hacemos count y agrupamos:
				
select a."actor_id", concat(a."first_name", ' ', a."last_name") as "Actor name", count(fa."film_id")
from "actor" as a
	left join "film_actor" as fa
		on a."actor_id" = fa."actor_id"
group by  a."actor_id", "Actor name";
				
--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

select f."film_id", f."title", count(r."rental_id") as "Number of rentals"
from "film" as f
	left join "inventory" as i
		on f."film_id" = i."film_id"
	left join "rental" as r
		on i."inventory_id" = r."inventory_id"
group by f."film_id";				
				
--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.				
				
select c."customer_id", concat(c."first_name", ' ', c."last_name") as "Customer name", sum(p."amount") as "Money spent"
from "customer" c 
	inner join "payment" p 
		on c."customer_id" = p."customer_id"
group by c."customer_id"	
order by "Money spent" desc		
limit 5;				

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select * 
from "actor"
where "first_name" = 'JOHNNY';

--36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
				
SELECT "first_name" AS "Nombre", "last_name" AS "Apellido"
FROM "actor";

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select max("actor_id") as "maximum actor_id", min("actor_id") as "minimum actor_id"
from "actor";

--38. Cuenta cuántos actores hay en la tabla “actorˮ.
				
select count("actor_id") as	"number of actors"
from "actor";
				
--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select *
from "actor"
order by "last_name" asc;

--40. Selecciona las primeras 5 películas de la tabla “filmˮ.
				
select *
from "film"
order by "film_id" asc
limit 5;
				
--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

select "first_name", count("first_name" ) as "numbers of times"
from "actor"
group by "first_name" 
order by "numbers of times" desc;		
--nombre mas repetido es Kenneth, penelope y julia, los 3 salen 4 veces, podriamos hacer un limit 1 para ver solamente el mas repetido aunque no veriamos los empates
				
--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.		

select r."rental_id", concat(c."first_name", ' ', c."last_name") as "Customer name"
from "rental" as r
	inner join "customer" as c 
		on r."customer_id" = c."customer_id";
				

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
	
select concat(c."first_name", ' ', c."last_name") as "Customer name", r."rental_id"
from "customer" as c
	left join "rental" as r
		on c."customer_id" = r."customer_id";
	
--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
		
select * 
from "film" as f cross join "category" as c;

--No aporta nada, al revés, ya que mezcla cada pelicula con todas las categorias existentes, cosa que no tienen ningun sentido

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.

select "actor_id" 
from "film_actor" 
where "film_id" IN (select "film_id" 
					from "film_category" 
					where "category_id" IN (select "category_id"
											from "category"
											where "name" = 'Action'));			

--opcion 2
select "actor_id" 
from "film_actor" 
where "film_id" IN (select f."film_id" 
					from "film_category" f inner join "category" c on f."category_id" = c."category_id"
					where c."name" = 'Action');
					
--opcion 3
WITH ActionFilms AS (
    SELECT f."film_id"
    FROM "film_category" f
    	INNER JOIN "category" c ON f."category_id" = c."category_id"
    WHERE c."name" = 'Action'
)
SELECT fa."actor_id"
FROM "film_actor" fa
WHERE fa."film_id" IN (SELECT "film_id" FROM ActionFilms);

-- Cuál sería mejor usar? entiendo que la 1 es menos eficiente, y del resto solo lo diferenncia la forma en que se organiza y la legibilidad no? 				


--46. Encuentra todos los actores que no han participado en películas.

select "actor_id", concat("first_name", ' ', "last_name") as "Actor name"
from "actor" 
where "actor_id" not in (select "actor_id" from "film_actor");

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado

select a."actor_id", concat(a."first_name", ' ', a."last_name") as "Actor name", count(fa."film_id") as "number of films"
from "actor" as a
	left join "film_actor" as fa
		on a."actor_id" = fa."actor_id"
group by  a."actor_id";
		

--48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.

create view “actor_num_peliculasˮ as 
select a."actor_id", concat(a."first_name", ' ', a."last_name") as "Actor name", count(fa."film_id") as "number of films"
from "actor" as a
	left join "film_actor" as fa
		on a."actor_id" = fa."actor_id"
group by  a."actor_id";

--49. Calcula el número total de alquileres realizados por cada cliente.

select c."customer_id", concat(c."first_name", ' ', c."last_name") as "Customer name", count(r."rental_id") as "number of rentals"
from "customer" as c
	left join "rental" as r
		on c."customer_id" = r."customer_id"
group by c."customer_id"
order by "number of rentals" desc;

--50. Calcula la duración total de las películas en la categoría 'Action'.
WITH "ActionFilms" AS (
    SELECT f."film_id"
    FROM "film_category" f
    	INNER JOIN "category" c ON f."category_id" = c."category_id"
    WHERE c."name" = 'Action'
)
select sum("length") as "sum of durations"
from "film"
where "film_id" in (SELECT "film_id" FROM "ActionFilms");

--51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.

create temporary table “cliente_rentas_temporalˮ as
select c."customer_id", concat(c."first_name", ' ', c."last_name") as "Customer name", count(r."rental_id") as "number of rentals"
from "customer" as c
	left join "rental" as r
		on c."customer_id" = r."customer_id"
group by c."customer_id"
order by "number of rentals" desc;

--52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.

create temporary table “peliculas_alquiladasˮ as
select i."film_id"
from "inventory" as i
	inner join "rental" as r
		on i."inventory_id" = r."inventory_id"
group by i."film_id"
having count(r."rental_id") >= 10;


--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

select f."title"
from "film" as f
	inner join "inventory" as i
		on f."film_id" = i."film_id"
	inner join "rental" as r
		on i."inventory_id" = r."inventory_id"
	inner join "customer" as c
		on r."customer_id" = c."customer_id"
where c."first_name" = 'TAMMY' and c."last_name" = 'SANDERS' and r."return_date" is null
order by f."title";

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.

select a."first_name", a."last_name"
from "actor" a
	inner join "film_actor" as fa 
		on a."actor_id" = fa."actor_id"
where fa."film_id" in (select fc."film_id" 
						from "film_category" as fc
							inner join "category" c
								on fc."category_id" = c."category_id"
						where c."name" = 'Sci-Fi')
group by a."first_name", a."last_name"
order by a."last_name";


--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.


WITH "SpartacusCheaperFirstRentalDate" AS (
	select r."rental_date"
	from "rental" as r
		inner join "inventory" as i
			on r."inventory_id" = i."inventory_id"
		inner join "film" as f
			on i."film_id" = f."film_id"
	where f."title" = 'SPARTACUS CHEAPER'
	order by r."rental_date" asc
	limit 1),
	"FilmsRentedAfterSpartacus" AS (
	select i."film_id"
	from "inventory" as i
		inner join "rental" as r
			on r."inventory_id" = i."inventory_id"
where r."rental_date" > (select "rental_date" from "SpartacusCheaperFirstRentalDate")
group by i."film_id")
select a."first_name", a."last_name"
from "actor" a
	inner join "film_actor" as fa 
		on a."actor_id" = fa."actor_id"
where fa."film_id" in (select "film_id" from "FilmsRentedAfterSpartacus")
group by a."first_name", a."last_name"
order by a."last_name";

--56 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.

WITH "MusicFilms" AS (
    SELECT f."film_id"
    FROM "film_category" f
    	INNER JOIN "category" c ON f."category_id" = c."category_id"
    WHERE c."name" = 'Music'
)
select a."first_name", a."last_name"
from "actor" a
	inner join "film_actor" as fa 
		on a."actor_id" = fa."actor_id"
where fa."film_id" in (select "film_id" from "MusicFilms")
group by a."first_name", a."last_name";

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

select f."title"
from "film" as f
	inner join "inventory" as i
		on f."film_id" = i."film_id"
	inner join "rental" as r
		on i."inventory_id" = r."inventory_id"
WHERE (r."return_date" - r."rental_date") > interval '8 days';


--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.

SELECT f."title"
FROM "film" f
inner join "film_category" fc
	on f."film_id" = fc."film_id"
where fc."category_id" = (select "category_id" from "category" where "name" = 'Animation');

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.

select "title" 
from "film"
where "length" = (select "length" from "film" where "title" = 'DANCING FEVER')
order by "title";

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

select c."first_name", c."last_name"
from "customer" c
	inner join "rental" r	
		on c."customer_id" = r."customer_id"
group by c."customer_id"
having count(r.rental_id) > 6;

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

select c."name" as "Category", count(r."rental_id") as "Number of rentals"
from "category" c
inner join film_category as fc on c."category_id" = fc."category_id"
inner join "inventory" as i on fc."film_id" = i."film_id"
inner join "rental" as r on i."inventory_id" = r."inventory_id"
group by "Category";


--62. Encuentra el número de películas por categoría estrenadas en 2006.

select c."name" as "Category", count(f."film_id") as "Number of films in 2006"
from "category" c
inner join film_category as fc on c."category_id" = fc."category_id"
inner join "film" as f on f."film_id" = f."film_id"
where f."release_year" = 2006
group by "Category";

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

select * 
from "staff"
cross join "store";


--64.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

select c."customer_id", concat(c."first_name", ' ', c."last_name") as "Customer name", count(r."rental_id") as "Number of rentals"
from "customer" as c
	left join "rental" as r
		on c."customer_id" = r."customer_id"
group by c."customer_id"
order by "number of rentals" desc;

