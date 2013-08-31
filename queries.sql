-- Marc Beitchman

-- q1 13 rows
select a.fname, a.lname
from Actor a, Movie m, Casts c
where m.name = 'Officer 444' and m.id = c.mid and a.id = c.pid;


-- q2 113 rows
select d.fname, d.lname, m.name, m.year
from Genre g, Directors d, Movie_Directors md, Movie m
where g.genre = 'Film-Noir' and m.year%4 = 0 and md.did = d.id and m.id = md.mid and g.mid = m.id;

-- q3 48 rows
select distinct a.fname, a.lname
from Actor a, Casts c1, Movie m1, Casts c2, Movie m2 
where a.id = c1.pid and c1.mid = m1.id 
           and  a.id = c2.pid  and c2.mid = m2.id
           and  m1.year < 1900 and m2.year > 2000;

/* The movie year appears to be the year the move was set in and not the year it was filmed. This
 query shows Morgan Freeman played Frederick Douglas in the film which led me to this conclusion.

select  *
from Movie m, Actor a, Casts c
where m.year < 1900 and m.id = c.mid and c.pid = a.id and m.name = 'Valley of the Shadow of Death';*/

-- q4 47 rows--
select  d.fname, d.lname, count(m.name) 
from Directors d, Movie_Directors md, Movie m
where d.id = md.did and m.id = md.mid 
group by d.lname, d.fname 
having count(m.name) >= 500
order by COUNT(m.name) DESC;

-- q5 24 rows 
select a.fname, a.lname, m.name, count(c.role)
from Movie m, Casts c, Actor a
where m.year = '2010' and c.mid = m.id and a.id = c.pid
group by m.name, a.lname, a.fname
having count(c.role) >= 5;

-- q6 137 rows
select a_outer.fname, a_outer.lname, m_outer.name, c_outer.role
from Actor a_outer, Movie m_outer, Casts c_outer,
	(select a.fname, a.lname, m.name, count(c.role)as total
	 from Movie m, Casts c, Actor a
	 where m.year = '2010' and c.mid = m.id and a.id = c.pid
	 group by m.name, a.lname, a.fname
	 having count(c.role) >= 5) AS AQual
where m_outer.id = c_outer.mid and a_outer.id = c_outer.pid and a_outer.fname = AQual.fname 
and m_outer.name=AQual.name and a_outer.lname = AQual.lname and AQual.total >= 5
order by a_outer.fname, a_outer.lname;

-- q7 129 rows
select m.year, count(distinct m.id)
from Movie m
	where not exists
		(select m.id
		 from Actor a, Casts c
		 where m.id=c.mid and c.pid=a.id and a.gender='M')
group by m.year;

-- q8 123 rows
select NM.year,cast(NM.totalnonmalemovies as float)/cast(ALL_M.totalmovies as float) as PercentFemale, ALL_M.totalmovies
from
    (select m.year, count(distinct m.id) as totalnonmalemovies
     from Movie m
     where not exists
	(select m.id
	 from Actor a, Casts c
	 where m.id=c.mid and c.pid=a.id and a.gender='M')
     group by m.year) as NM,
	 (select y.year, COUNT(*) as totalmovies
	  from Actor x, Movie y, Casts z
	  where y.id = z.mid and z.pid = x.id
	  group by y.year) as ALL_M
where NM.year = ALL_M.year;

--q9 1 row
select *
from (select m.name, COUNT(DISTINCT c.pid) AS size
from Movie m, Casts c
where m.id = c.mid
group by m.name) AS TOTAL
order by TOTAL.size DESC
LIMIT 1;

-- q10 1 row
select m.year as firstyear, m.year + 9 as lastyear, sum(distinct moviesperyear.TotalPerYear) as totalmovies
from Movie m,
    (select m1.year, count(m1.id) as TotalPerYear
     from Movie m1
     group by m1.year) as moviesperyear
where moviesperyear.year>=m.year and moviesperyear.year < m.year+9
group by m.year
order by sum(distinct moviesperyear.TotalPerYear) desc
LIMIT 1;

-- q11 1 row
-- select count of actor id's of all actors who have been in movies with actors who have acted with films with Kevin Bacon (Bacon number 2) --
select Count(distinct a4.id)
from Actor a4, Casts c4, Movie m4 Inner JOIN
(
	-- select movie names of all movies who have actors that have acted in films with Kevin Bacon --
	select distinct m3.name
	from Movie m3, Casts c3, Actor a3 INNER JOIN
	(
		-- select actor id's who have been in films with Kevin Bacon (Bacon number 1) --
		select distinct a2.id
		from Casts c2, Actor a2, Movie m2 INNER JOIN
		(
			-- select movie names of movie's with Kevin Bacon --
			select m1.name
			from Actor a1, Casts c1, Movie m1
			where m1.id = c1.mid and a1.id = c1.pid and a1.fname = 'Kevin' and a1.lname = 'Bacon'
		) as Q1 on Q1.name = m2.name
		where c2.pid = a2.id and m2.id = c2.mid and a2.fname != 'Kevin' and a2.lname != 'Bacon') as Q2 on Q2.id = a3.id
	where m3.id = c3.pid and m3.id = c3.mid) as Q3 on Q3.name = m4.name
where a4.id = c4.pid and m4.id = c4.mid; 