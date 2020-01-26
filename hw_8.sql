-- Урок 8. "Сложные запросы"
USE vk;
SHOW TABLES;

-- 1. Добавить необходимые внешние ключи для всех таблиц базы данных vk (приложить команды).

ALTER TABLE communities
	ADD CONSTRAINT communities_photo_id_fk
		FOREIGN KEY (photo_id) REFERENCES media(id)
			ON DELETE SET NULL;

ALTER TABLE communities_users
	ADD CONSTRAINT communities_users_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT communities_users_community_id_fk -- пишет, что не можкт быть привязан
		FOREIGN KEY (community_id) REFERENCES communities(id)
			ON DELETE CASCADE;

ALTER TABLE friendship
	ADD CONSTRAINT friendship_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT friendship_friend_id_fk
		FOREIGN KEY (friend_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT friendship_status_id_fk -- на диаграмме видно что не связаны, почему не ясно... Хотя про манда выдаёт ошибку о том, что ключ дублирунется
		FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);

ALTER TABLE likes
	ADD CONSTRAINT likes_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT likes_target_type_id_fk
		FOREIGN KEY (target_type_id) REFERENCES target_types(id)
			ON DELETE CASCADE;

ALTER TABLE media
	ADD CONSTRAINT media_media_type_id_fk
		FOREIGN KEY (media_type_id) REFERENCES media_types(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT media_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;

ALTER TABLE meetings_users
	ADD CONSTRAINT meetings_users_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT meetings_users_meeting_id_fk
		FOREIGN KEY (meeting_id) REFERENCES meetings(id)
			ON DELETE CASCADE;

ALTER TABLE messages
	ADD CONSTRAINT messages_from_user_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT messages_to_user_id_fk
		FOREIGN KEY (to_user_id) REFERENCES users(id)
			ON DELETE CASCADE;

ALTER TABLE posts
	ADD CONSTRAINT posts_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT posts_media_id_fk
		FOREIGN KEY (media_id) REFERENCES media(id)
			ON DELETE CASCADE;


-- 2. По созданным связям создать ER диаграмму, используя Dbeaver (приложить графический файл к ДЗ).
-- Приложен

-- 3. Переписать запросы, заданые к ДЗ урока 6 с использованием JOIN (четыре запроса).

-- 1 Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

SELECT
	ms.from_user_id,
	COUNT(*) AS messages
	FROM messages ms
		JOIN users u
	ON u.id = 14
		AND ms.to_user_id = u.id
		JOIN friendship fr
	ON fr.user_id = u.id
		AND ms.from_user_id = fr.friend_id
		OR fr.friend_id = u.id
		AND ms.from_user_id = fr.user_id
	GROUP BY ms.from_user_id
	ORDER BY messages DESC;

-- 2 Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
SELECT 
	li.target_id,
	TIMESTAMPDIFF(YEAR, pr.birthday, NOW()) AS age,
	COUNT(li.target_id)
	FROM likes li
		JOIN profiles pr
	ON li.target_id = pr.user_id
		AND target_type_id = 2
	GROUP BY li.target_id
	ORDER BY pr.birthday DESC
	LIMIT 10;

-- 3 Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT
	CASE(pr.sex)
		WHEN 'm' THEN 'male'
		WHEN 'f' THEN 'female'
	END AS sex, 
	COUNT(pr.sex) AS likes
	FROM profiles pr
		JOIN likes li
	ON li.user_id = pr.user_id
	GROUP BY pr.sex 
	ORDER by likes DESC
	LIMIT 1;


-- 4 Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
SELECT
	CONCAT(first_name, ' ', last_name) AS user,
	li.user_id,
	med.user_id,
	mes.from_user_id
	FROM users us
		LEFT JOIN likes li
	ON us.id = li.user_id
		LEFT JOIN media med
	ON us.id = med.user_id
		LEFT JOIN messages mes
	ON us.id = mes.from_user_id
	ORDER BY li.user_id, med.user_id, mes.from_user_id
	LIMIT 10;
-- как сложить результаты, не понимаю...
