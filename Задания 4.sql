/*Задание 1. Напишите SQL-запрос,
который выводит всю информацию о фильмах
со специальным атрибутом (поле special_features) равным “Behind the Scenes”.*/
select *
from film f
where 'Behind the Scenes' = any (special_features);
/*Задание 2. Напишите ещё 2 варианта поиска фильмов с атрибутом “Behind the Scenes”,
используя другие функции или операторы языка SQL для поиска значения в массиве.*/
select *
from film f
where '{"Behind the Scenes"}' && special_features;
select *
from film f
where '{"Behind the Scenes"}' <@ (special_features);
/*Задание 3. Для каждого покупателя посчитайте,
сколько он брал в аренду фильмов со специальным атрибутом “Behind the Scenes”.
Обязательное условие для выполнения задания:
используйте запрос из задания 1, помещённый в CTE.*/
with behind_the_scenes as (select *
	from film f
	where 'Behind the Scenes' = any (special_features)
)
select distinct c.customer_id
	,c.store_id
	,c.first_name
	,c.last_name
	,c.email
	,count(i.film_id) over (partition by c.customer_id)
	,c.address_id
	,c.activebool
	,c.create_date
	,c.last_update
	,c.active
from public.customer c
inner join public.rental r
	on c.customer_id = r.customer_id
inner join public.inventory i
	on r.inventory_id = i.inventory_id
where i.film_id in (select film_id from behind_the_scenes)
group by c.customer_id, i.film_id
order by c.customer_id;
/*Задание 4. Для каждого покупателя посчитайте,
сколько он брал в аренду фильмов со специальным атрибутом “Behind the Scenes”.
Обязательное условие для выполнения задания: используйте запрос из задания 1,
помещённый в подзапрос, который необходимо использовать для решения задания.*/
select distinct c.customer_id
	,c.store_id
	,c.first_name
	,c.last_name
	,c.email
	,count(i.film_id) over (partition by c.customer_id)
	,c.address_id
	,c.activebool
	,c.create_date
	,c.last_update
	,c.active
from public.customer c
inner join public.rental r
	on c.customer_id = r.customer_id
inner join public.inventory i
	on r.inventory_id = i.inventory_id
where i.film_id in (select f.film_id
	from film f
	where 'Behind the Scenes' = any (special_features)
)
group by c.customer_id, i.film_id
order by c.customer_id;
/*Задание 5. Создайте материализованное представление с запросом из предыдущего задания
и напишите запрос для обновления материализованного представления.*/
create materialized view matview as
	select distinct c.customer_id
		,c.store_id
		,c.first_name
		,c.last_name
		,c.email
		,count(i.film_id) over (partition by c.customer_id)
		,c.address_id
		,c.activebool
		,c.create_date
		,c.last_update
		,c.active
	from public.customer c
	inner join public.rental r
		on c.customer_id = r.customer_id
	inner join public.inventory i
		on r.inventory_id = i.inventory_id
	where i.film_id in (select f.film_id
		from film f
		where 'Behind the Scenes' = any (special_features)
	)
	group by c.customer_id, i.film_id
	order by c.customer_id;
refresh materialized view matview;
drop materialized view matview;
/*Задание 6. С помощью explain analyze
проведите анализ скорости выполнения запросов из предыдущих заданий и ответьте на вопросы:
с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания,
поиск значения в массиве происходит быстрее;
какой вариант вычислений работает быстрее: с использованием CTE или с использованием подзапроса.*/
explain analyze
with behind_the_scenes as (select *
	from film f
	where 'Behind the Scenes' = any (special_features)
)
select distinct c.customer_id
	,c.store_id
	,c.first_name
	,c.last_name
	,c.email
	,count(i.film_id) over (partition by c.customer_id)
	,c.address_id
	,c.activebool
	,c.create_date
	,c.last_update
	,c.active
from public.customer c
inner join public.rental r
	on c.customer_id = r.customer_id
inner join public.inventory i
	on r.inventory_id = i.inventory_id
where i.film_id in (select film_id from behind_the_scenes)
group by c.customer_id, i.film_id
order by c.customer_id; --execution time: от 41.1 ms до 50.514 ms

explain analyze
select distinct c.customer_id
	,c.store_id
	,c.first_name
	,c.last_name
	,c.email
	,count(i.film_id) over (partition by c.customer_id)
	,c.address_id
	,c.activebool
	,c.create_date
	,c.last_update
	,c.active
from public.customer c
inner join public.rental r
	on c.customer_id = r.customer_id
inner join public.inventory i
	on r.inventory_id = i.inventory_id
where i.film_id in (select f.film_id
	from film f
	where 'Behind the Scenes' = any (special_features)
)
group by c.customer_id, i.film_id
order by c.customer_id; --execution time: от 41.902 ms до 53.608 ms
/*Задание 7. Используя оконную функцию,
выведите для каждого сотрудника сведения о первой его продаже.*/
with first_sell as (select staff_id
		,min(rental_date) over (partition by staff_id order by rental_date) as "rental_date"
	from rental r)
select *
from rental r
where rental_date in (select "rental_date" from first_sell);