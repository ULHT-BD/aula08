#profiling using Performance Schema
SET SQL_SAFE_UPDATES = 0;
UPDATE performance_schema.setup_instruments
       SET ENABLED = 'YES', TIMED = 'YES'
       WHERE NAME LIKE '%statement/%';
       
 UPDATE performance_schema.setup_instruments
       SET ENABLED = 'YES', TIMED = 'YES'
       WHERE NAME LIKE '%stage/%'; 
       
UPDATE performance_schema.setup_consumers
       SET ENABLED = 'YES'
       WHERE NAME LIKE '%events_statements_%';
       
UPDATE performance_schema.setup_consumers
       SET ENABLED = 'YES'
       WHERE NAME LIKE '%events_stages_%';

#execute queries
flush status;
CALL generate_data(50000);
flush status;
select sql_no_cache count(*) from random_data where id > 900 and id < 1000;
flush status;
select sql_no_cache count(*) from random_data where number1 > 900 and number1 < 1000;
flush status;
select sql_no_cache count(*) from random_data where number2 > 900 and number2 < 1000;
flush status;
explain select sql_no_cache count(*) from random_data where string1 LIKE '%abc%';

SELECT EVENT_ID, TRUNCATE(TIMER_WAIT/1000000000000,6) as Duration, SQL_TEXT
       FROM performance_schema.events_statements_history_long WHERE SQL_TEXT like '%select sql_no_cache count%' OR SQL_TEXT like 'call%';

#add indexes
create index random_data_ix2 on random_data(number2);


#execute queries
flush status;
CALL generate_data(50000);
flush status;
select sql_no_cache count(*) from random_data where id > 900 and id < 1000;
flush status;
select sql_no_cache count(*) from random_data where number1 > 900 and number1 < 1000;
flush status;
select sql_no_cache count(*) from random_data where number2 > 900 and number2 < 1000;
flush status;
select sql_no_cache count(*) from random_data where string1 LIKE '%abc%';

#show execution times       
SELECT EVENT_ID, TRUNCATE(TIMER_WAIT/1000000000000,6) as Duration, SQL_TEXT
       FROM performance_schema.events_statements_history_long WHERE SQL_TEXT like '%select sql_no_cache count%' OR SQL_TEXT like 'call%';
