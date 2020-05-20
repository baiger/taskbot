CREATE DATABASE IF NOT EXISTS `taskdb`;
CREATE ROLE IF NOT EXISTS 'taskdb_user';
GRANT SELECT, INSERT, DELETE, UPDATE ON `taskdb`.* TO 'taskdb_user';
CREATE USER IF NOT EXISTS 'taskbot' IDENTIFIED BY 'DWeHqKP3wumuFIKvbyu0' DEFAULT ROLE 'taskdb_user';
USE `taskdb`;

CREATE TABLE IF NOT EXISTS `lists` (
       `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
       `name` VARCHAR(250) NOT NULL,
       `description` VARCHAR(2000),
       `server_id` BIGINT UNSIGNED NOT NULL,
       `creator_id` BIGINT UNSIGNED NOT NULL,
       PRIMARY KEY (`id`),
       UNIQUE (`name`,`server_id`)
       );

-- work in progress
CREATE FUNCTION taskdb.ServerDefault(server BIGINT UNSIGNED, list BIGINT UNSIGNED)
RETURNS INT READS SQL DATA
BEGIN
	DECLARE match_count INT;
	SET match_count = (
		SELECT COUNT(*) FROM `lists` WHERE `id` = list AND `server_id` = server);
	RETURN match_count;
END;

CREATE TABLE IF NOT EXISTS `server_default` (
       `server_id` BIGINT UNSIGNED NOT NULL UNIQUE,
       `list_id` BIGINT UNSIGNED NOT NULL REFERENCES `lists`(`id`)
       -- CHECK (taskdb.ServerDefault(`server_id`,`list_id`) > 0)
);
CREATE TABLE IF NOT EXISTS `tasks` (
       `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
       `name` VARCHAR(250) NOT NULL,
       `description` VARCHAR(2000),
       `due` DATETIME,
       `remind` DATETIME,
       `status` ENUM ('todo', 'doing', 'done') NOT NULL,
       `creator_id` BIGINT UNSIGNED NOT NULL,
       `owner_type` ENUM ('server', 'role', 'user'),
       `owner_id` BIGINT UNSIGNED,
       `list_id` BIGINT UNSIGNED NOT NULL REFERENCES `lists`(`id`),
       PRIMARY KEY (`id`),
       UNIQUE (`name`, `list_id`)
       );
CREATE TABLE IF NOT EXISTS `tags` (
       `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
       `tag` VARCHAR(500) NOT NULL,
       `count` BIGINT UNSIGNED NOT NULL,
       `server_id` BIGINT UNSIGNED NOT NULL,
       PRIMARY KEY (`id`),
       UNIQUE (`tag`, `server_id`)
       );
CREATE TABLE IF NOT EXISTS `tag_map` (
       `task_id` BIGINT UNSIGNED NOT NULL REFERENCES `tasks`(`id`),
       `tag_id` BIGINT UNSIGNED NOT NULL REFERENCES `tags`(`id`),
       UNIQUE (`task_id`, `tag_id`)
       );
CREATE TABLE IF NOT EXISTS `roles` (
       `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
       `name` VARCHAR(250) NOT NULL,
       `description` VARCHAR(2000),
       `server_id` BIGINT UNSIGNED NOT NULL,
       PRIMARY KEY (`id`),
       UNIQUE (`name`, `server_id`)
       );
CREATE TABLE IF NOT EXISTS `role_map` (
       `user_id` BIGINT UNSIGNED NOT NULL,
       `role_id` BIGINT UNSIGNED NOT NULL REFERENCES `roles`(`id`),
       UNIQUE (`user_id`, `role_id`)
       );
CREATE TABLE IF NOT EXISTS `privilege` (
       `subject_type` ENUM('role', 'user') NOT NULL,
       `subject_id` BIGINT UNSIGNED NOT NULL,
       `object_type` ENUM('server', 'list', 'task', 'tag') NOT NULL,
       `object_id` BIGINT UNSIGNED NOT NULL,
       `action_type` ENUM('read', 'write') NOT NULL,
       `permitted` BOOLEAN NOT NULL,
       UNIQUE (`subject_type`, `subject_id`, `object_type`, `object_id`, `action_type`)
       );
