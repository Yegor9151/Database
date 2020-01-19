-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:
USE vk;
SHOW TABLES;

-- 1.	Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).
-- "Единственное, что Я могу предложить - это стандартизировать код и добавить комментарии для лучшего понимания"

-- 2.	Пусть задан некоторый пользователь.
SELECT
	id,
	CONCAT(first_name, ' ', last_name) AS full_name,
	(SELECT sex
		FROM profiles
		WHERE user_id = users.id) AS sex,
	(SELECT birthday
		FROM profiles
		WHERE user_id = users.id) AS birthday,
	(SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) 
		FROM profiles 
		WHERE user_id = users.id) AS age,
	(SELECT filename 
		FROM media 
		WHERE id = (SELECT photo_id 
			FROM profiles 
			WHERE user_id = users.id)) AS photo,
	(SELECT hometown 
		FROM profiles 
		WHERE user_id = users.id) AS hometown
	FROM users
	WHERE id = 14;

--	Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- ВЫБРАТЬ ДРУГА И ЮЗЕРА
SELECT 
	friend_id, user_id
-- ИЗ ВСЕХ ДРУЗЕЙ (С 2х СТОЛБЦОВ)
	FROM
		((SELECT user_id, friend_id, status_id
			FROM friendship)
		UNION
		(SELECT friend_id, user_id, status_id
			FROM friendship)) AS frinds_user
-- ГДЕ: ЮЗЕР = 14, СТАТУС = 2(ПОДТВЕРЖДЁН) И ОТПРАВЛЯЛИСЬ СООБЩЕНИЯ ДЛЯ ЮЗЕРА 14
	WHERE
		user_id = 14 AND
		status_id = 2 AND
		friend_id IN
			(SELECT from_user_id
				FROM messages
				WHERE to_user_id = frinds_user.user_id);

-- 3.	Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- ВЫБРАТЬ ЮЗЕРОВ, ИХ ВОЗРАСТ И ИХ ЛАЙКИ
SELECT 
	user_id, 
	TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age,
	(SELECT COUNT(target_id)
		FROM likes
		WHERE target_id = prf.user_id
		GROUP BY target_id) AS likes
-- ИЗ ПРОФИЛЯ
	FROM profiles AS prf
-- ОТСОРТИРОВАТЬ ПОЛЬЗОВАТЕЛЕЙ ПО ВОЗРАСТУ УМЕНЬШИТЬ ВЫБОРКУ ДО 10
	ORDER BY age
	LIMIT 10;

-- 4.	Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- ВЫЬРАТЬ ПОЛ И СУММУ ВСЕХ ЛАЙКОВ
SELECT
	sex, 
	COUNT(sex) AS likes
-- ИЗ ВСЕХ МУХЧИН И ЖЕНЩИН В ТАБЛИЦЕ ЛАЙКОВ
	FROM
		(SELECT 
			(SELECT sex 
				FROM profiles
				WHERE user_id = lks.user_id) AS sex
			FROM likes AS lks) AS sex
-- СГРУППИРОВАТЬ РЕЗУЛЬТАТЫ ПО ПОЛУ
	GROUP BY sex;

-- 5.	Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
SELECT
	id,
	(SELECT COUNT(user_id)
		FROM media
		WHERE user_id = us.id
		GROUP BY user_id) AS media,
	(SELECT COUNT(user_id)
		FROM posts
		WHERE user_id = us.id
		GROUP BY user_id) AS posts,
	(SELECT COUNT(user_id)
		FROM communities_users
		WHERE user_id = us.id
		GROUP BY user_id) AS cmmnts,
	(SELECT COUNT(user_id)
		FROM likes
		WHERE user_id = us.id
		GROUP BY user_id) AS likes,
	(SELECT COUNT(from_user_id)
		FROM messages
		WHERE from_user_id = us.id
		GROUP BY from_user_id) AS messages
	FROM users AS us
	ORDER BY media, posts, likes, cmmnts, messages
	LIMIT 10;
