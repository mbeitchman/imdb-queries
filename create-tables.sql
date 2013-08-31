-- Marc Beitchman

create table actor (id integer primary key, fname varchar(30), lname varchar(30), gender char(1));
create table movie (id integer primary key NOT NULL, name varchar(150), year integer);
create table directors(id integer primary key NOT NULL, fname varchar(30), lname varchar(30));
create table casts(pid integer references actor(id), mid integer references movie(id), role varchar(30));
create table movie_directors(did integer references directors(id), mid integer references movie(id));
create table genre(mid integer, genre varchar(50));

\copy actor from 'c:\actor-ascii.txt' with delimiter '|' csv quote E'\n'
\copy movie from 'c:\movie-ascii.txt' with delimiter '|' csv quote E'\n'
\copy directors from 'c:\directors-ascii.txt' with delimiter '|' csv quote E'\n'
\copy casts from 'c:\casts-ascii.txt' with delimiter '|' csv quote E'\n'
\copy movie_directors from 'c:\movie_directors-ascii.txt' with delimiter '|' csv quote E'\n'
\copy genre from 'c:\genre-ascii.txt' with delimiter '|' csv quote E'\n'