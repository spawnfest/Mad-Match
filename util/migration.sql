DROP TABLE IF EXISTS `users`;

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

DROP TABLE IF EXISTS `pingers`;

CREATE TABLE `pingers` (
 `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
 `name` VARCHAR( 50 ) NOT NULL ,
 `type` VARCHAR( 50 ) NOT NULL ,
 `user_id` INT NOT NULL ,
 `end_point` VARCHAR( 250 ) NOT NULL ,
 `frequency` INT NOT NULL ,
 `last_status` VARCHAR( 50 ) NULL ,
 `last_check` BIGINT NOT NULL DEFAULT 0,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `location` TEXT NULL,
 `data` TEXT
) ENGINE = INNODB DEFAULT CHARSET=latin1;

ALTER TABLE `pingers` ADD INDEX (`user_id`);

DROP TABLE IF EXISTS `subscriptions`;

CREATE TABLE `subscriptions` (
 `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
 `type` VARCHAR( 50 ) NOT NULL ,
 `user_id` INT NOT NULL ,
 `pinger_id` INT NOT NULL ,
 `down_time` INT NOT NULL ,
 `notify_when_up` BOOL NOT NULL DEFAULT  '0',
 `notification_delay` INT NOT NULL ,
 `last_notification` INT NOT NULL DEFAULT  0 ,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB DEFAULT CHARSET=latin1;

ALTER TABLE `subscriptions` ADD INDEX (`user_id`);
ALTER TABLE `subscriptions` ADD INDEX (`pinger_id`);
