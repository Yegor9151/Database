DROP DATABASE IF EXISTS youtube;
CREATE DATABASE youtube;
USE youtube;


-- 1. каналы
DROP TABLE IF EXISTS channels;
CREATE TABLE channels (
	id SERIAL PRIMARY KEY,							-- id канала
	name VARCHAR(100) NOT NULL,						-- название
	condition_type_id TINYINT(1) UNSIGNED NOT NULL,	-- состояние
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 2. статусы канала
DROP TABLE IF EXISTS condition_types;
CREATE TABLE condition_types (
	id TINYINT(1) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- id состояния
	name VARCHAR(100) NOT NULL									-- значения
); INSERT INTO condition_types(name) VALUES ('active'), ('delete');


-- 3. подписчики каналов
DROP TABLE IF EXISTS followers;
CREATE TABLE followers (
	channel_id SERIAL PRIMARY KEY,		-- id канала
	follower_count INT(100) NOT NULL,	-- количество подписчиков 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 4. подписки каналов
DROP TABLE IF EXISTS subscriptions;
CREATE TABLE subscriptions (
	channel_id BIGINT UNSIGNED NOT NULL,					-- id фоловера
	subscription_id BIGINT UNSIGNED NOT NULL,				-- id подписки	
	subscription_status_id TINYINT(1) UNSIGNED NOT NULL,	-- статут подписки
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 5. статусы подписки
DROP TABLE IF EXISTS subscription_statuses;
CREATE TABLE subscription_statuses (
	id TINYINT(1) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,		-- id статуса
	name VARCHAR(12) NOT NULL										-- значение
); INSERT INTO subscription_statuses(name) VALUES ('subscribed'), ('unsubscribed');


-- 6. плэйлисты
DROP TABLE IF EXISTS playlists;
CREATE TABLE playlists (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- id плейлиста
	name VARCHAR(100) NOT NULL,									-- название
	channel_id BIGINT UNSIGNED NOT NULL,						-- id канала
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 7. видео
DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
	id SERIAL PRIMARY KEY,							-- id видео
	name VARCHAR(100) NOT NULL,						-- название
	link VARCHAR(100) NOT NULL,						-- ссылка
	views INT(100) DEFAULT NULL,					-- количество просмотров
	longest TIME NOT NULL,							-- длительность
	description VARCHAR(100) DEFAULT NULL,			-- описание
	`size` TINYINT(10) NOT NULL,					-- вес
	channel_id BIGINT UNSIGNED NOT NULL,			-- id канала
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 8. расположение видео в плейлистах
DROP TABLE IF EXISTS videos_playlists;
CREATE TABLE videos_playlists (
	playlist_id TINYINT UNSIGNED NOT NULL,			-- id плейлиста
	video_id BIGINT UNSIGNED NOT NULL,				-- id видео
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- 9. комменты
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL PRIMARY KEY,							-- id коммента
	channel_id BIGINT UNSIGNED NOT NULL,			-- id канала - автора
	object_type_id TINYINT(1) UNSIGNED NOT NULL,	-- тип прокомментированого объекта
	object_id BIGINT UNSIGNED NOT NULL,				-- id прокомментированого объекта
	body VARCHAR(255) NOT NULL,						-- содержание
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 10. оценка
DROP TABLE IF EXISTS assessments;
CREATE TABLE assessments (
	channel_id BIGINT UNSIGNED NOT NULL,				-- id канала - оценщика
	object_type_id TINYINT(1) UNSIGNED NOT NULL,		-- тип оценённого объекта
	object_id BIGINT UNSIGNED NOT NULL,					-- id оценённого объекта
	assessment_type_id TINYINT(1) UNSIGNED NOT NULL,	-- тип оценки
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- 11. тип оценки
DROP TABLE IF EXISTS assessment_types;
CREATE TABLE assessment_types (
	id TINYINT(1) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,		-- id оценки
	name VARCHAR(7) NOT NULL										-- значение
); INSERT INTO assessment_types(name) VALUES ('like'), ('dislike'), ('removed');


-- 12. типы объекта
DROP TABLE IF EXISTS object_types;
CREATE TABLE object_types (
	id TINYINT(1) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,		-- id типа объекта
	name VARCHAR(7) NOT NULL										-- значение
); INSERT INTO object_types(name) VALUES ('video'), ('comment');


-- 13. архив переименований каналов
DROP TABLE IF EXISTS name_channels;
CREATE TABLE name_channels (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- id переименования
	channel_id BIGINT UNSIGNED NOT NULL,					-- id канала
	channel_name VARCHAR(100),								-- имя канала
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE = Archive;


-- 8.	хранимые процедуры / триггеры;
DELIMITER //
DROP TRIGGER IF EXISTS after_insert_archive_name_channel//
CREATE TRIGGER after_insert_archive_name_channel AFTER INSERT ON channels
FOR EACH ROW
BEGIN 
	INSERT INTO name_channels(channel_id, channel_name) 
	SELECT id, name FROM channels ORDER BY created_at DESC LIMIT 1;
END//


DROP TRIGGER IF EXISTS after_update_archive_name_channel//
CREATE TRIGGER after_update_archive_name_channel AFTER UPDATE ON channels
FOR EACH ROW
BEGIN 
	INSERT INTO name_channels(channel_id, channel_name) 
	SELECT id, name FROM channels ORDER BY updated_at DESC LIMIT 1;
END//
DELIMITER ;

SHOW TABLES;
