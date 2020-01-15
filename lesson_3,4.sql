	-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

DROP DATABASE IF EXISTS lesson_5;
CREATE DATABASE lesson_5;

SHOW DATABASES;
USE lesson_5;


-- task 1
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

SHOW TABLES;

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29'),
	('Светлана', '1988-02-04'),
	('Олег', '1998-03-20'),
	('Юлия', '2006-07-12');

SELECT * FROM users;

-- Заполните их текущими датой и временем.
UPDATE users SET
	created_at = now(),
	updated_at = now();

SELECT * FROM users;


-- task 2
-- Таблица users была неудачно спроектирована.
DESC users;
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
ALTER TABLE users CHANGE created_at created_at DATETIME;
ALTER TABLE users CHANGE updated_at updated_at DATETIME;

DESC users;
SELECT * FROM users;


-- task 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SHOW TABLES;
DESC storehouses_products;

INSERT INTO storehouses_products(storehouse_id, product_id, value) VALUES 
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5)),
	(FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 100) + 1, FLOOR(RAND() * 5));

-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
SELECT * FROM storehouses_products ORDER BY value IN (0), value;


-- task 4
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
SELECT 
	id, 
	name, 
	DATE_FORMAT(birthday_at, '%M')birthday_at 
FROM users
WHERE DATE_FORMAT(birthday_at, '%M')
IN ('may', 'august')
ORDER BY birthday_at;

-- task 5
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

-- Отсортируйте записи в порядке, заданном в списке IN.
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY id IN (5) desc;


	-- Практическое задание теме “Агрегация данных”

-- tasc 1
-- Подсчитайте средний возраст пользователей в таблице users
SELECT AVG(FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25)) AS average_age FROM users;

-- tasc 2
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.


-- tasc 3
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы

