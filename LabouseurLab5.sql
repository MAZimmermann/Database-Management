-- 1	show city of agents booking order for 'c006'
SELECT a.city
FROM Agents a INNER JOIN Orders o ON o.aid = a.aid
	INNER JOIN Customers c ON o.cid = c.cid
WHERE c.cid = 'c006';
--


-- 2	show pid(s) of product(s) ordered through agents that made at least one order from a customer in Kyoto
-- order by pid from highest to lowest (DESC)
SELECT DISTINCT o2.pid
FROM Orders o INNER JOIN Customers c ON o.cid = c.cid
	INNER JOIN Agents ON c.city = 'Kyoto'
	INNER JOIN Orders o2 ON o2.aid = o.aid
ORDER BY pid DESC;
--


-- 3	show names of customers who have never placed an order
-- use subquery
SELECT DISTINCT name
FROM Customers 
WHERE cid NOT IN (
	SELECT cid
	FROM Orders
	WHERE aid = 'a03' -- forgot to include this line
);
--


-- 4 	show names of customers who have never placed an order 
-- use OUTER JOIN
SELECT DISTINCT c.name
FROM Customers c LEFT OUTER JOIN Orders o ON o.cid = c.cid
WHERE o.cid IS NULL;
--


-- 5	show names of customers who placed at least one order through agent in same city
-- also show the agents name with that of the customer
SELECT DISTINCT c.name, a.name
FROM Customers c INNER JOIN Orders o ON o.cid = c.cid
	INNER JOIN Agents a ON o.aid = a.aid
WHERE c.city = a.city;
--


-- 6	show names of customers and agents in the same city, along with the name of the city
-- regardless of whether the customer placed an order through that agent
INSERT INTO Customers (cid, name, city, discount)
VALUES ('c007', 'Yutani', 'New York', 9.00);
-- Yutani inserted for testing

SELECT c.name, a.name, c.city
FROM Customers c FULL OUTER JOIN Agents a ON c.city = a.city
WHERE c.city = a.city;

-- delete Yutani
DELETE FROM Customers
WHERE cid = 'c007';
--


-- 7	show name and city of customers who live in THE city that makes the fewest different kind of products
-- use COUNT and GROUP BY on the products table
SELECT c.name, c.city
FROM Customers c INNER JOIN Orders o ON c.cid = o.cid
	INNER JOIN Products p ON o.pid = p.pid
GROUP BY c.name, c.city
ORDER BY COUNT(p.city) ASC LIMIT 1;
-- This one really stumped me
