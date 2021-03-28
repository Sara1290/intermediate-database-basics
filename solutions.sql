-- use this repo and postgres.devmountain.com to practice more queries! --
-- JOINS -- 
SELECT * FROM invoice_line
WHERE unit_price > 0.99;

SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice i
JOIN customer c ON i.customer_id

SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;

SELECT al.title, ar.name
FROM albums al 
JOIN artist ar ON al.artist_id = ar.artist_id;

-- say the above like a sentence. select 
--album title and artist name from albums, which we are calling al
--and join artist which we are calling ar on
--album dot artist id ASSIGNED as artist dot artist id ;


SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';

-- black diamond for JOINS 
SELECT t.name, g.name, a.title, ar.name
FROM track t
JOIN genre g ON g.genre_id = t.genre_id  
JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON ar.artist_id = a.artist_id
JOIN playlist_track pt ON pt.track_id = t.track_id
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';

-- NESTED QUERIES --

SELECT * FROM invoice_line
WHERE unit_price > 0.99;

SELECT * FROM playlist_track
WHERE playlist_id IN ( SELECT playlist_id FROM playlist 
WHERE name ILIKE 'MUSIC');

SELECT name FROM track
WHERE track_id IN ( SELECT track_id FROM playlist_track 
WHERE playlist_id = 5); 

SELECT * FROM track
WHERE genre_id IN (SELECT genre_id FROM genre
WHERE name = 'Comedy');

SELECT * FROM track 
WHERE album_id IN (SELECT album_id
FROM album 
WHERE title = 'Fireball');

SELECT * FROM track 
WHERE album_id IN ( SELECT album_id FROM album WHERE artist_id IN (
SELECT artist_id FROM artist WHERE name = 'Queen') 
);


-- UPDATING ROWS --

UPDATE customer
SET fax = null
WHERE fax IS NOT null;

UPDATE customer
SET company = 'Self'
WHERE company IS null;

UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal')
AND composer IS null;

-- GROUP BY --


SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;

SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

-- USE DISTINCT --

SELECT DISTINCT composer
FROM track;

SELECT DISTINCT billing_postal_code
FROM invoice;

SELECT DISTINCT company
FROM customer;

--DELETE ROWS --

CREATE TABLE practice_delete ( name TEXT, type TEXT, value INTEGER );
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);

SELECT * FROM practice_delete;


DELETE 
FROM practice_delete 
WHERE type = 'bronze';

DELETE 
FROM practice_delete 
WHERE type = 'silver';

DELETE 
FROM practice_delete 
WHERE value = 150;

-- e commerce no hints section --
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name TEXT,
  email VARCHAR(255)
  );

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name TEXT,
  price INT
);

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  user_id INTEGER references users(user_id),
  product_id INTEGER references products(product_id)
  );

INSERT INTO users (name, email)
VALUES
('Lucille', 'makemeadrink@gmel.com'),
('George', 'bananastand@money.com'),
('Job', 'illusionsformoney@gmel.com')

INSERT INTO products (name, price)
VALUES
('banana', 10.00),
('vodka' 25.00),
('stair car' 8.00),
('shoes' 800)

--LUCILLE ONE ORDERS THINGS ONE TWO AND THREE
INSERT INTO orders (user_id, product_id)
VALUES(1, 2);
INSERT INTO orders (user_id, product_id)
VALUES(1, 1);
INSERT INTO orders (user_id, product_id)
VALUES(1, 3);
--GEORGE TWO ORDERS THINGS ONE TWO AND THREE
INSERT INTO orders (user_id, product_id)
VALUES(2, 1);
INSERT INTO orders (user_id, product_id)
VALUES(2, 2);
INSERT INTO orders (user_id, product_id)
VALUES(2, 3);
--JOB THREE ORDERS THINGS ONE TWO AND THREE
INSERT INTO orders (user_id, product_id)
VALUES(3, 1);
INSERT INTO orders (user_id, product_id)
VALUES(3, 2);
INSERT INTO orders (user_id, product_id)
VALUES(3, 3);

SELECT * FROM orders;

SELECT products.name
FROM products
JOIN orders ON products.product_id = orders.product_id
WHERE orders.order_id = 1;

--trying some queries with aliases. 
SELECT SUM(price)
FROM products p
JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id = 2;

SELECT * 
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.user_id = 2;

SELECT *
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 3;

--THE INSTRUCTIONS SAY TO ADD A FOREIGN KEY REF FROM ORDERS TO USERS AT THIS STAGE. i SET MY ORDERS TABLE UP WITH
-- A REF TO USERS EVEN THOUGH THE INSTRUCTIONS ONLY SAID TO DO IT FOR PRODUCTS BECAUSE I COUDLN'T
--IMAGINE ORDERS NOT BEING LINKED TO USERS. 
--I THINK THE IDEA IS TO USE ALTER TABLE THOUGH, THAT'S PROBABLY WHY THE INSTRUCTIONS WERE SET UP THAT WAY. OKAY. 

SELECT * 
FROM orders o 
JOIN users u ON o.user_id = u.user_id
WHERE o.user_id = 2;


SELECT COUNT(order_id)
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 1;

SELECT COUNT(order_id)
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 2;

SELECT COUNT(order_id)
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE orders.user_id = 3;

--I JUST WANTED TO USER ALTER TABLE SOMEHOW >>
ALTER TABLE users 
ADD COLUMN age INTEGER;

ALTER TABLE users 
DROP COLUMN age;

ALTER TABLE orders
ADD COLUMN paid BOOLEAN;

ALTER TABLE orders
DROP COLUMN paid;