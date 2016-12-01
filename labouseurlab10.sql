-- view everything
SELECT *
FROM Courses
INNER JOIN Prerequisites on Courses.num = Prerequisites.CourseNum ;


-- get the prerequisites for a course by inputing the course number
create or replace function PreReqsFor(int, REFCURSOR) returns refcursor as 
$$
declare
   crn int := $1;
   resultset REFCURSOR := $2;
begin
   open resultset for 
	select name AS CourseName, num AS CourseNum, preReqNum
	FROM Courses c INNER JOIN Prerequisites p on c.num = p.courseNum
	where crn = courseNum;
   return resultset;
end;
$$ 
language plpgsql;

-- 499 has the following prerequisites...
select PreReqsFor(499, 'results');
Fetch all from results;


-- get the courses that a course is a prerequisite for
create or replace function IsPreReqFor(int, REFCURSOR) returns refcursor as 
$$
declare
   crn int := $1;	
   resultset REFCURSOR := $2;
begin
   open resultset for
      select name AS CourseName, num AS CourseNum, preReqNum
      from Courses c INNER JOIN Prerequisites p on c.num = p.courseNum
      where crn = preReqNum;
   return resultset;
end;
$$ 
language plpgsql;

-- 120 is a prerequisite for...
select IsPreReqFor(120, 'results');
Fetch all from results;





