-- Marc Beitchman

--modified postgresql config settings by editing postgresql.conf file
-- set shared buffers to 512MB 
show SHARED_BUFFERS;

--set temporary buffers to 16MB
show TEMP_BUFFERS;

--set working memory to 128MB
show WORK_MEM;

--set max_stack_depth to 3584kB
show MAX_STACK_DEPTH;

--indexes
-- primary key indexes, speeds up joins and selections across most queries
CREATE INDEX movie_pkey on movie(id);
CREATE INDEX directors_pkey on directors(id);
CREATE INDEX actor_pkey on actor(id);

-- speed up group by in q7/q8/a10, select in q2/q7/q8 and where in q2/q3/q5/q6/q7/q8/q10  
CREATE INDEX movie_year_idx on movie(year);

-- speed up where in q7 and q8
CREATE INDEX actor_genre_idx ON actor(gender);

-- speed up joins on most queries (q1, q3, q5, q7, q8, q9, q11)  
-- since casts.pid and casts.pid are foreign keys
CREATE INDEX casts_pid_idx ON casts(pid);
CREATE INDEX casts_mid_idx ON casts(mid);

--speed up group by and selection in in q9, join in q11, selections in q6
CREATE INDEX movie_name_idx ON movie(name);

-- speed up selection and joins in q6, group by in q5 and selection in q11
CREATE INDEX actor_fname_idx ON actor(fname);
CREATE INDEX actor_lname_idx ON actor(lname);

-- speed up where in q7 and q8
CREATE INDEX actor_gender_idx ON actor(gender);

--speed up joins in q2 and q4
CREATE INDEX movie_directors_did_idx on movie_directors(did);
CREATE INDEX movie_directors_mid_idx on movie_directors(mid);