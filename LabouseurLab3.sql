/*
Marcus Zimmermann
Labouseur Lab Three
*/

/*	1	*/
SELECT ordnum, totalUSD
FROM Orders;

/*	2	*/
SELECT name, city
FROM Agents
WHERE name = 'Smith';

/*	3	*/
SELECT pid, name, priceUSD
FROM Products
WHERE quantity > 201000;

/*	4	*/
SELECT name, city
FROM Customers
WHERE city = 'Duluth';

/*	5	*/
SELECT agents
FROM Agents
WHERE city != 'New York'
	AND city != 'Duluth';

/*	6	*/
SELECT *
FROM Products
WHERE city != 'Dallas'
	AND city != 'Duluth'
	AND priceUSD > 1.00;

/*	7	*/
SELECT *
FROM Orders
WHERE mon = 'feb'
	OR mon = 'mar';

/*	8	*/
SELECT *
FROM Orders
WHERE mon = 'feb'
	AND totalUSD >= 600;

/*	9	*/
SELECT *
FROM Orders
WHERE cid = 'c005';





