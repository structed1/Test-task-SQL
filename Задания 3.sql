/*Задание 1. Сделайте запрос к таблице payment и с помощью оконных функций
добавьте вычисляемые колонки согласно условиям:
•	Пронумеруйте все платежи от 1 до N по дате
•	Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате
•	Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя,
	сортировка должна быть сперва по дате платежа, а затем по сумме платежа от наименьшей к большей
•	Пронумеруйте платежи для каждого покупателя по стоимости платежа от наибольших к меньшим так,
	чтобы платежи с одинаковым значением имели одинаковое значение номера.
Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.
*/
select payment_id
	,rank() over (partition by customer_id order by amount) as amount_num_for_customer --Нумерация платежей по стоимости
	,sum(amount) over (partition by customer_id order by payment_date, amount) as pay_sum_date_for_customer --Сумма платежей для каждого покупателя
	,customer_id
	,staff_id
	,rental_id
	,amount
	,payment_date
	,rank() over (order by payment_date) as pay_date_num --Нумерация платежей по дате
	,rank() over (partition by customer_id order by payment_date) as pay_date_num_for_customer --Нумерация платежей для каждого покупателя
from payment p;
/*Задание 2. С помощью оконной функции выведите для каждого покупателя стоимость платежа
и стоимость платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.*/
select amount 
	,case
		when lag(amount) over (partition by customer_id order by payment_date) is null then
			0.0
		else
			lag(amount) over (partition by customer_id order by payment_date)
	end as "Предыдущая строка"
from payment p;
/*Задание 3. С помощью оконной функции определите,
на сколько каждый следующий платеж покупателя больше или меньше текущего.*/
select amount 
	,lag(amount) over (partition by customer_id order by payment_date) as "Предыдущая строка"
	,abs(amount-(lag(amount) over (partition by customer_id order by payment_date))) as "Разность"
from payment p;
/*Задание 4. С помощью оконной функции для каждого покупателя
выведите данные о его последней оплате аренды.*/
select payment_id
	,customer_id
	,staff_id
	,rental_id
	,amount
	,max(payment_date) over (partition by customer_id order by customer_id)
from payment p;
/*Задание 5. С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года
с нарастающим итогом по каждому сотруднику
и по каждой дате продажи (без учёта времени) с сортировкой по дате.*/
select payment_id
	,customer_id
	,staff_id
	,rental_id
	,amount
	,date(payment_date) as payment_date
	,sum(amount) over (partition by staff_id order by payment_date, amount) as pay_sum_for_staff --Сумма продаж для каждого сотрудника
	,sum(amount) over (partition by date(payment_date) order by date(payment_date)) as pay_sum_for_date --Сумма продаж по каждой дате
from payment p
where payment_date between '2005-08-01' and '2005-08-31';
group by payment_id
order by payment_id;