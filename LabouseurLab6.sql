-- Marcus Anton Zimmermann
-- Labouseur Lab 6

-- 1
-- Display the name and city of customers who live in ANY city that makes the MOST
--	different kinds of products.
-- (There are two cities that make the most different products.
-- Return the name and city of customers from EITHER ONE of those.)
--
SELECT c.name, most.city
FROM Customers c, (
	SELECT city, count(city)
	FROM Products
	Group BY city
	Having COUNT(city) = (
		SELECT COUNT(city)
		FROM Products
		GROUP BY city
		ORDER BY COUNT(city) DESC LIMIT 1
	)
)  as most
WHERE c.city=most.city;

-- 2
-- Display the names of products whose priceUSD is strictly below the average priceUSD, 
-- in reverse-alphabetical order.
--
SELECT name
FROM Products
WHERE priceUSD < (
	SELECT AVG(priceUSD)
	FROM Products
)
ORDER BY name DESC;

-- 3
-- Display the customer name, pid ordered, and the total for all orders,
-- sorted by total from low to high
--
SELECT c.name, o.pid, sum(totalUSD)
FROM Customers c INNER JOIN Orders o ON o.cid = c.cid
GROUP BY c.name, o.pid
ORDER BY sum(totalUSD) ASC;

-- 4
-- Display all customer names (in alphabetical order) and their total ordered,
-- 	and nothing more. Use Coalesce to avoid showing NULLs
--
SELECT COALESCE(name), COALESCE(sum(totalUSD))
FROM Customers INNER JOIN Orders on Orders.cid = Customers.cid
GROUP BY name
Order by name ASC;

-- 5
-- Display the names of all customers who bought products from agents based in NY
-- 	along with the names of the products they ordered,
-- 	and the names of the agents who sold it to them.
--
SELECT c.name, p.name, a.name
FROM Customers c INNER JOIN Orders o ON o.cid = c.cid
	INNER JOIN Products p ON o.pid = p.pid
	INNER JOIN Agents a ON o.aid = a.aid
	WHERE o.aid in (
		SELECT DISTINCT a.aid
		FROM Agents a
		WHERE a.city = 'New York'
	);

-- 6
-- Write a query to check the accuracy of the dollars collumn in the Orders table.
-- This means calculating Orders.totalUSD from data in other tables and
-- 	comparing those values to the values in Orders.totalUSD.
-- Display all rows in Orders where Orders.totalUSD is incorrect, if any.
--
SELECT o.ordnum, o.totalUSD, ((p.priceUSD * o.qty) * (1 - (c.discount / 100)))AS orderCalc
FROM Orders o INNER JOIN Customers c ON c.cid = o.cid
	INNER JOIN Products p ON p.pid = o.pid
WHERE o.totalUSD != (p.priceUSD * o.qty) * (1 - (c.discount / 100))
GROUP BY ordnum, c.cid, p.pid
ORDER BY ordnum ASC;

-- 7
-- What's the difference between LEFT OUTER JOIN and RIGHT OUTER JOIN
-- Give example queries to demonstrate

-- When you build a query using OUTER JOIN, the first table listed in the JOIN is
-- 	considered the "left" table. The second table listed in the JOIN is
-- 	considered the "right" table.
-- So, if you want all of the rows in the first table plus any mathing rows in the
-- 	second table, you use a LEFT OUTER JOIN
-- If you want all of the rows in the second table plus any matching rows in the
-- 	first table, you use a RIGHT OUTER JOIN
--
-- for example... imagine we made the following tables
-- We can perform LEFT and RIGHT OUTER JOINs on these tables in order to get different results
--

CREATE TABLE english (
	num TEXT NOT NULL,
	val INT NOT NULL
);


INSERT INTO english(num, val) VALUES ('one', 1);
INSERT INTO english(num, val) VALUES ('tow', 2);
INSERT INTO english(num, val) VALUES ('three', 3);

CREATE TABLE chinese (
	num TEXT NOT NULL,
	val INT NOT NULL
);


INSERT INTO chinese(num, val) VALUES ('ar', 2);
INSERT INTO chinese(num, val) VALUES ('sun', 3);
INSERT INTO chinese(num, val) VALUES ('si', 4);

--
-- Two example queries involving LEFT and RIGHT OUTER JOINs include the following...
--

SELECT *
FROM english LEFT OUTER JOIN chinese ON english.val = chinese.val;

SELECT *
FROM chinese RIGHT OUTER JOIN english ON english.val = chinese.val;


