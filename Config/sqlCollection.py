
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xxxxx';

SELECT count(1) from z_performance_date1

alter table z_performance_date1 modify enter_date datetime

CREATE TABLE IF NOT EXISTS `z_performance_date1`(
   `z_id` INT UNSIGNED AUTO_INCREMENT,
   `remarks` VARCHAR(100),
   `enter_date` DATETIME,
   PRIMARY KEY ( `z_id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


insert into z_performance_date1 (enter_date,remarks) values ("2022-0519 11:35:02","test1")