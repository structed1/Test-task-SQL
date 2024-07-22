--Задание 1. Выведите уникальные названия городов из таблицы городов
select distinct city from city c order by city;
/*Задание 2. Доработайте запрос из предыдущего задания,
чтобы запрос выводил только те города,
названия которых начинаются на “L” и заканчиваются на “a”,
и названия не содержат пробелов*/
select distinct city from city c
where city like 'L%' and city like '%a' and city not like '% %'
order by city;
/*Задание 3. Получите из таблицы платежей за прокат фильмов информацию по платежам,
которые выполнялись в промежуток
с 17 июня 2005 года по 19 июня 2005 года включительно
и стоимость которых превышает 1.00.
Платежи нужно отсортировать по дате платежа.*/
select * from payment p
where date(payment_date) between '2005-06-17' and '2005-06-19'
	and amount > 1.00
order by payment_date;
--Задание 4. Выведите информацию о 10-ти последних платежах за прокат фильмов.
select * from payment p
	order by payment_date desc limit 10;
/*Задание 5. Выведите следующую информацию по покупателям:
•	Фамилия и имя (в одной колонке через пробел)
•	Электронная почта
•	Длину значения поля email
•	Дату последнего обновления записи о покупателе (без времени)
Каждой колонке задайте наименование на русском языке.*/
select concat(last_name,' ',first_name) as "Фамилия и имя"
	,email as "Электронная почта"
	,length(email) as "Длина поля email"
	,date(last_update) as "Дата последнего обновления"
from customer c;
/*Задание 6. Выведите одним запросом только активных покупателей,
имена которых KELLY или WILLIE.
Все буквы в фамилии и имени из верхнего регистра 
должны быть переведены в нижний регистр.*/
select customer_id
	,store_id
	,lower(first_name)
	,lower(last_name)
	,email
	,address_id
	,activebool
	,create_date
	,last_update
	,active
from customer c
where first_name in ('KELLY','WILLIE') and active = 1;
/*Задание 7. Выведите одним запросом информацию о фильмах,
у которых рейтинг “R” и стоимость аренды указана от 0.00 до 3.00 включительно,
а также фильмы c рейтингом “PG-13” и стоимостью аренды больше или равной 4.00.*/
select * from film f
where rating = 'R' and rental_rate between 0.00 and 3.00
	or rating = 'PG-13' and rental_rate >= 4.00;
--Задание 8. Получите информацию о трёх фильмах с самым длинным описанием фильма.
select * from film f
order by length(f.description) desc limit 3;
/*Задание 9. Выведите Email каждого покупателя, 
разделив значение Email на 2 отдельных колонки:
•	в первой колонке должно быть значение, указанное до @,
•	во второй колонке должно быть значение, указанное после @.*/
select substring(email,1,strpos(email,'@')-1) as "До @"
	,substring(email,strpos(email,'@')+1,length(email)-strpos(email,'@')) as "После @"
from customer c;
/*Задание 10. Доработайте запрос из предыдущего задания,
скорректируйте значения в новых колонках:
первая буква должна быть заглавной, остальные строчными.*/
select initcap(substring(email,1,strpos(email,'@')-1)) as "До @"
	,initcap(substring(email,strpos(email,'@')+1,length(email)-strpos(email,'@'))) as "После @"
from customer c;