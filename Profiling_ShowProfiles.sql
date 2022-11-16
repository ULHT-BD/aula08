#profiling using SHOW PROFILES
set profiling=1;

#execute queries
flush status;
select sql_no_cache count(*) from random_data where id > 900 and id < 1000;
flush status;
select sql_no_cache count(*) from random_data where number1 > 900 and number1 < 1000;
flush status;
select sql_no_cache count(*) from random_data where number2 > 900 and number2 < 1000;
flush status;
select sql_no_cache count(*) from random_data where string1 LIKE '%abc%';

#add indexes
create index random_data_ix1 on random_data(number1);

#execute queries
flush status;
select sql_no_cache count(*) from random_data where id > 900 and id < 1000;
flush status;
select sql_no_cache count(*) from random_data where number1 > 900 and number1 < 1000;
flush status;
select sql_no_cache count(*) from random_data where number2 > 900 and number2 < 1000;
flush status;
select sql_no_cache count(*) from random_data where string1 LIKE '%abc%';

#show execution times
show profiles;