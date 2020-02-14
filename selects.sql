USE youtube;
SHOW TABLES;


-- у какого канала самое большое количество комментов под видео?
SELECT
	ch.id,
	ch.name AS channels,
	COUNT(cm.body) +
	COUNT(cm2.body) AS comments
FROM channels ch
	JOIN videos v
		ON v.channel_id = ch.id
	JOIN comments cm
		ON cm.object_type_id = 1
			AND cm.object_id = v.id
	LEFT JOIN comments cm2
		ON cm2.object_type_id = 2
			AND cm2.object_id = cm.id
GROUP BY ch.id
ORDER BY comments DESC
LIMIT 1;


-- сортировка видео по количеству оценок и выводом оценивающих 
SELECT
	v.id, v.name, v.views, v.link, atl.name, atd.name,
	COUNT(atl.name) OVER w +
	COUNT(atd.name) OVER w AS total,
	a.channel_id
FROM videos v
	JOIN assessments a
		ON a.object_id = v.id
	LEFT JOIN assessment_types atl
		ON atl.name = 'like'
			AND a.assessment_type_id = atl.id
	LEFT JOIN assessment_types atd
		ON atd.name = 'dislike'
			AND a.assessment_type_id = atd.id
WINDOW w AS (PARTITION BY v.id)
ORDER BY total DESC;


-- представление год с самым больших количеством созданных каналов
DROP VIEW IF EXISTS successful_year;
CREATE VIEW successful_year(year, channels)
	AS SELECT
		DISTINCT YEAR(created_at) AS year,
		COUNT(id) OVER (PARTITION BY YEAR(created_at)) AS channels
	FROM channels c
	ORDER BY channels DESC
	LIMIT 1;

SELECT * FROM youtube.successful_year;


-- представление вывод всех прокомментированных видео с подкомментами
DROP VIEW IF EXISTS comments_view;
CREATE VIEW comments_view(id, channels, first_comments, last_comments)
	AS SELECT
		ch.id, ch.name, cm.body, cm2.body
	FROM channels ch
		JOIN videos v
			ON v.channel_id = ch.id
		JOIN comments cm
			ON cm.object_type_id = 1
				AND cm.object_id = v.id
		LEFT JOIN comments cm2
			ON cm2.object_type_id = 2
				AND cm2.object_id = cm.id
	ORDER BY ch.id;

SELECT * FROM youtube.comments_view;



