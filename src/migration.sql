DROP TABLE `users`;

CREATE TABLE  `users` (
 `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
 `name` VARCHAR( 50 ) NOT NULL ,
 `email` VARCHAR( 50 ) NOT NULL ,
 `password` VARCHAR( 250 ) NOT NULL ,
 `twitter` VARCHAR( 50 ) NULL ,
 `tagline` VARCHAR( 50 ) NULL ,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ,
UNIQUE (`email`)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

DROP TABLE `pingers`;

CREATE TABLE  `pingers` (
 `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
 `name` VARCHAR( 50 ) NOT NULL ,
 `type` VARCHAR( 50 ) NOT NULL ,
 `user_id` INT NOT NULL ,
 `end_point` VARCHAR( 250 ) NOT NULL ,
 `frequency` INT NOT NULL ,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB DEFAULT CHARSET=latin1;

DROP TABLE `subscriptions`;

CREATE TABLE  `subscriptions` (
 `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
 `type` VARCHAR( 50 ) NOT NULL ,
 `user_id` INT NOT NULL ,
 `pinger_id` INT NOT NULL ,
 `down_time` INT NOT NULL ,
 `notify_when_up` BOOL NOT NULL DEFAULT  '0',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB DEFAULT CHARSET=latin1;
