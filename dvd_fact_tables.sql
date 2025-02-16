CREATE TABLE factsales
	(
		sales_key SERIAL PRIMARY KEY,
		date_key integer REFERENCES dimDate (datekey),
		customer_key integer REFERENCES dimCustomer (customer_key),
		movie_key integer REFERENCES dimMovie (movie_key),
		store_key integer REFERENCES dimStore (store_key),
		sales_amount numeric
	); 

INSERT INTO factSales (date_key, customer_key, movie_key, store_key, sales_amount)
SELECT 
	TO_CHAR(payment_date :: DATE, 'yyyMMDD')::integer AS datekey,
	p.customer_id as customer_key,
	i.film_id as movie_key,
	i.store_id as store_key,
	p.amount as sales_amount
FROM payment p
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i on (r.inventory_id = i.inventory_id);

select * from factsales