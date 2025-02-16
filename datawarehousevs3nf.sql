-- search using star schema. It should take less, because its datawarehouse. But the drastic difference in speed 
-- can be seen in larger dataset

SELECT dimmovie.title, dimdate.month, dimcustomer.city, sum(sales_amount) as revenue
FROM factSales
JOIN dimmovie on (dimmovie.movie_key = factSales.movie_key)
JOIN dimdate on (dimdate.datekey = factSales.date_key)
JOIN dimCustomer on (dimCustomer.customer_key = factSales.customer_key)
group by (dimmovie.title, dimdate.month, dimcustomer.city)
order by dimmovie.title, dimdate.month, dimcustomer.city, revenue desc; 

-- now search using 3NF. It should take more time since there are more tables.

SELECT f.title, EXTRACT(month FROM p.payment_date) as month, ci.city, sum(p.amount) as revenue
FROM payment p
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (r.inventory_id = i.inventory_id)
JOIN film f ON (i.film_id = f.film_id)
JOIN customer c ON (p.customer_id = c.customer_id)
JOIN address a ON (c.address_id = a.address_id)
JOIN city ci ON (a.city_id = ci.city_id)
group by (f.title, month, ci.city)
order by f.title, month, ci.city, revenue desc;
