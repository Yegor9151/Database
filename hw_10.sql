-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.
USE vk;

CREATE INDEX communities_name_idx ON communities(name);
CREATE INDEX media_filename_idx ON media(filename);
CREATE INDEX meetings_name_idx ON meetings(name);
CREATE INDEX posts_header_idx ON posts(header);
CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);

/*
2. Задание на оконные функции
Построить запрос, который будет выводить следующие столбцы:
имя группы
среднее количество пользователей в группах
самый молодой пользователь в группе
самый пожилой пользователь в группе
общее количество пользователей в группе
всего пользователей в системе
отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
*/
-- функция OVER окно
SELECT DISTINCT c.name,
	COUNT(cu.user_id) OVER() / COUNT(c.name) OVER(PARTITION BY c.id) AS middle_users,
	MAX(p.birthday) OVER(PARTITION BY c.id) AS yongest,
	MIN(p.birthday) OVER(PARTITION BY c.id) AS oldest,
	COUNT(cu.user_id) OVER(PARTITION BY c.id) AS in_group,
	COUNT(cu.user_id) OVER() AS total,
	COUNT(cu.user_id) OVER(PARTITION BY c.id) / COUNT(cu.user_id) OVER() * 100 AS '%%'
FROM communities c
	LEFT JOIN communities_users cu
		ON c.id = cu.community_id
	LEFT JOIN profiles p
		ON cu.user_id = p.user_id;

desc profiles;
