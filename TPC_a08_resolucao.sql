-- create new database (check aula9 homework if you have user permission related problems)

CREATE DATABASE deisiflix;

-- select database deisiflix

USE deisiflix;

-- create table load_genres

CREATE TABLE load_genres (
  name varchar(50),
  id_movie int
);

-- load dos ficheiros de dados pelo interface dbeaver (veja as notas no trabalho de casa da aula9 se obteve erros) ou usando o comando load data

LOAD DATA LOCAL INFILE 'deisi_genre.txt' 
INTO TABLE load_genre FIELDS 
TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';


#profiling using SHOW PROFILES
set profiling=1;

#execute queries
flush status;
select sql_no_cache * from load_genres lg where id_movie >400000 order by id_movie desc limit 5;

#add indexes
create index load_genres_ix1 on load_genres(id_movie);

#execute queries
select sql_no_cache * from load_genres lg where id_movie >400000 order by id_movie desc limit 5;

#show execution times
show profiles;
