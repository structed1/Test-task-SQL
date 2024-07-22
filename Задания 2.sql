--Задание 1. Выведите для каждого покупателя его адрес, город и страну проживания.
select address, city, country from customer_list cl;
/*Задание 2. С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
•	Доработайте запрос и выведите только те магазины, у которых количество покупателей больше 300.
	Для решения используйте фильтрацию по сгруппированным строкам с функцией агрегации.
•	Доработайте запрос, добавив в него информацию о городе магазина,
	фамилии и имени продавца, который работает в нём.*/
select s.store_id
	,c3.city_id
	,c3.city
	,s2.last_name
	,s2.first_name
	,count(c.customer_id)
from customer c
inner join store s
	on c.store_id = s.store_id
		and (select count(c2.customer_id) from customer c2 where c2.store_id = s.store_id) > 300
inner join address a
	on s.address_id = a.address_id
inner join city c3
	on a.city_id = c3.city_id
inner join staff s2
	on s.manager_staff_id = s2.staff_id 
group by s.store_id, c3.city_id, s2.staff_id;
--Задание 3. Выведите топ-5 покупателей, которые взяли в аренду за всё время наибольшее количество фильмов.
select c.customer_id
	,c.first_name
	,c.last_name
	,count(f.film_id) as fcount
from customer c
inner join store s
	on c.store_id = s.store_id
inner join inventory i
	on s.store_id = i.store_id
inner join film f
	on i.film_id = f.film_id
group by c.customer_id
order by fcount desc limit 5;
/*Задание 4. Посчитайте для каждого покупателя 4 аналитических показателя:
•	количество взятых в аренду фильмов;
•	общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа);
•	минимальное значение платежа за аренду фильма;
•	максимальное значение платежа за аренду фильма.*/
select c.customer_id
	,c.first_name
	,c.last_name
	,count(f.film_id) as fcount --Количество взятых в аренду фильмов
	,round(sum(p.amount)) as psum --общая стоимость платежей за аренду всех фильмов
	,min(p.amount) as pmin --минимальное значение платежа за аренду фильма
	,max(p.amount) as pmax --максимальное значение платежа за аренду фильма
from customer c
inner join store s
	on c.store_id = s.store_id
inner join inventory i
	on s.store_id = i.store_id
inner join film f
	on i.film_id = f.film_id
inner join payment p
	on c.customer_id = p.customer_id
group by c.customer_id
order by c.customer_id;
/*Задание 5. Используя данные из таблицы городов,
составьте одним запросом все возможные пары городов так,
чтобы в результате не было пар с одинаковыми названиями городов.
Для решения необходимо использовать декартово произведение.*/
select c.city, c2.city
from city c
cross join city c2
where c.city != c2.city;
/*Задание 6. Используя данные из таблицы rental
о дате выдачи фильма в аренду (поле rental_date) и дате возврата (поле return_date),
вычислите для каждого покупателя среднее количество дней, за которые он возвращает фильмы.*/
select c.customer_id
	,c.first_name
	,c.last_name
	,avg(date(r.return_date)-date(r.rental_date)) as "Среднее количество дней"
from customer c
inner join rental r
	on c.customer_id = r.customer_id
group by c.customer_id
order by c.customer_id;
/*Задание 7. Посчитайте для каждого фильма, сколько раз его брали в аренду,
а также общую стоимость аренды фильма за всё время.*/
select f.film_id
	,count(r.rental_id) as "Сколько раз брали в аренду"
	,sum(f.rental_rate*(date(r.return_date)-date(r.rental_date))) as "Стоимость аренды за всё время"
from film f
inner join inventory i
	on f.film_id = i.film_id
inner join rental r
	on i.inventory_id = r.inventory_id
group by f.film_id
order by f.film_id;
/*Задание 8. Доработайте запрос из предыдущего задания и выведите с помощью него фильмы,
которые ни разу не брали в аренду.*/
select f.film_id
	,count(r.rental_id) as "Сколько раз брали в аренду"
	,sum(f.rental_rate*(date(r.return_date)-date(r.rental_date))) as "Стоимость аренды за всё время"
from film f
inner join inventory i
	on f.film_id = i.film_id
inner join rental r
	on i.inventory_id = r.inventory_id or r.rental_id is null
group by f.film_id
order by f.film_id;
/*Задание 9. Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия».
Если количество продаж превышает 7 300, то значение в колонке будет «Да», иначе должно быть значение «Нет».*/
select s.staff_id
	,count(r.rental_id) as "Количество продаж"
	,case
		when count(r.rental_id) > 7300 then
			'Да'
		else
			'Нет'
	end as "Премия"
from staff s
inner join rental r
	on s.staff_id = r.staff_id
group by s.staff_id;