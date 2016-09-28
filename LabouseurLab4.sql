/*
Marcus Zimmermann
Labouseur Lab Four
*/

/*	1	*/
SELECT city
FROM Agents
WHERE aid in (
	SELECT aid
	FROM Orders
	WHERE cid in (
		SELECT cid
		FROM Customers
		WHERE cid = 'c006'
	)
);

/*	2	*/
SELECT pid
FROM Products
WHERE pid in (
	SELECT pid
	FROM Orders
	WHERE aid in (
		SELECT aid
		FROM Orders	
		WHERE cid in (
			SELECT cid
			FROM Customers
			WHERE city = 'Kyoto'
		)
	)
)
ORDER BY pid ASC;


/*	3	*/
SELECT cid, name
FROM Customers
WHERE cid in (
	SELECT cid
	FROM Orders
	WHERE aid LIKE 'a0%'
		EXCEPT
	SELECT cid
	FROM Orders
	WHERE aid = 'a03'
	
);

/*	4	*/
SELECT cid
FROM Customers
WHERE cid in (
	SELECT cid
	FROM Orders
	WHERE pid = 'p01'
		INTERSECT
	SELECT cid
	FROM Orders
	WHERE pid = 'p07'
);

/*	5	*/
SELECT distinct pid
FROM Orders
WHERE cid NOT in (
	SELECT cid
	FROM Orders
	WHERE aid = 'a08'
)
ORDER BY pid DESC;

/*	6	*/
SELECT name, discount, city
FROM Customers
WHERE cid in (
	SELECT cid
	FROM Orders
	WHERE aid in (
		SELECT aid
		FROM Agents
		WHERE city = 'New York'
			OR city = 'Dallas'
	)
);

/*	7	*/
SELECT name
FROM Customers
WHERE discount in (
	SELECT discount
	FROM Customers
	WHERE city = 'Dallas' OR city = 'London'
);

/*	8	*/ 
/*
Check constraints are used in order to specify limitations on data entry.
They are attached to attribute declarations, and, in principle, they can refer
	to anything that follows the WHERE clause in SQL.

For example, if you want the input for a Gender column to be either 'M'
	or 'F', a check constraint could ensure that only 'M' or 'F'
	can be entered. This sort of limitation on data entry is definitely
	a good thing.

With that being said, there are certainly examples of how NOT to 
	use a check constraint. Consider trying to use a check constraint
	in the place of a referential integrity constraint.
This is problematic because it will reject NULL entries if the corresponding
	entry is not NULL. Furthermore, deletion, an action that is a violation
	of the check constraint, is invisible to the same check constraint. This
	should not be allowed. Consider the snippets of code below, taken from
	this class' book. While violating the check constraint, if we were to 
	change or delete the president tuple from the MovieExec relation, the
	change or deletion would be permissible.

	Studio(name, address, presC#)
	MovieExec(name, address, cert# , netWorth)

	presC# INT CHECK
		(presC# IN (SELECT cert# FROM MovieExec))
*/




