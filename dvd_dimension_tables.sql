-- insert data into dimdate

INSERT INTO dimDate
(datekey, date, year, quarter, month, day, week, is_weekend)
SELECT
DISTINCT(TO_CHAR(payment_date :: DATE, 'yyyMMDD')::integer) as date_key,
date(payment_date) as date,
EXTRACT(year from payment_date) as year,
EXTRACT(quarter from payment_date) as quarter,
EXTRACT(month from payment_date) as month,
EXTRACT(day from payment_date) as day,
EXTRACT(week from payment_date) as week,
CASE WHEN EXTRACT (ISODOW FROM payment_date) IN (6, 7) THEN true ELSE false END AS is_weekend
FROM payment;

SELECT * FROM dimDate;

-- insert data into dimcustomer

INSERT INTO dimcustomer
(customer_key, customer_id, first_name, last_name, email, address, address_2, district, city,
country, postal_code, phone, active, create_date, start_date, end_date)
SELECT
c.customer_id as customer_key,
c.customer_id,
c.first_name,
c.last_name,
c.email,
a.address,
a.address2,
a.district,
ci.city,
co.country,
postal_code,
a.phone,
c.active,
c.create_date,
now() AS start_date,
now() AS end_date
FROM customer c
JOIN address a ON (c.address_id = a.address_id)
JOIN city ci ON (a.city_id = ci.city_id)
JOIN country co ON (ci.country_id = co.country_id);

--insert data into dimstore

INSERT INTO dimstore
(store_key, store_id, address, address_2, district, city, country, postal_code, manager_first_name,
manager_last_name, start_date, end_date)
SELECT
s.store_id as store_key,
s.store_id,
a.address,
a.address2,
a.district,
ci.city,
co.country,
postal_code,
st.first_name,
st.last_name,
now() as start_date,
now() as end_date
FROM store s
JOIN staff st ON (s.manager_staff_id = st.staff_id)
JOIN address a ON (s.address_id = a.address_id)
JOIN city ci ON (a.city_id = ci.city_id)
JOIN country co ON (ci.country_id = co.country_id);

select * from dimstore;

-- insert data into dimovie

INSERT INTO dimmovie
(movie_key, film_id, title, description, release_year, language, original_language,
rental_duration, length, rating, special_features)
SELECT
f.film_id as movie_key,
f.film_id,
f.title,
f.description,
f.release_year,
l.name,
l.name,
f.rental_duration,
f.length,
f.rating,
f.special_features
FROM film f
JOIN language l on (f.language_id = l.language_id)