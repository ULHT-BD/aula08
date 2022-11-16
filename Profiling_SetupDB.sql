#setup database

drop database index_example;
create database index_example;
use index_example;


CREATE TABLE random_data 
(
  id int AUTO_INCREMENT,
  number1 int,
  number2 double,
  string1 varchar(255),
  string2 varchar(100),
  PRIMARY KEY (`id`)
);

#stored procedure to generate random data
DELIMITER $$
CREATE PROCEDURE generate_data(IN n_tuples INT)
BEGIN
  DECLARE i INT DEFAULT 0;
  SET autocommit = 0;
  WHILE i < n_tuples DO
    INSERT INTO random_data(number1, number2, string1, string2) VALUES (
      RAND()*200000,
      ROUND(RAND()*200000,2),
      SUBSTRING(REPLACE(REPLACE(REPLACE( TO_BASE64(MD5(RAND())), '=',''),'+',''),'/',''), 2, FLOOR(210+RAND()*31)),
      SUBSTRING(REPLACE(REPLACE(REPLACE( TO_BASE64(MD5(RAND())), '=',''),'+',''),'/',''), 2, FLOOR(70+RAND()*31))
    );
    SET i = i + 1;
  END WHILE;
  SET autocommit = 1;
END$$
DELIMITER ;

#generate random data
CALL generate_data(250000);