-- Практическое задание по теме “Транзакции, переменные, представления”

-- 1.	В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
COMMIT;

SELECT * FROM sample.users;

-- 2.	Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.
DROP VIEW IF EXISTS names;
CREATE VIEW names (product_name, catalog_name) 
	AS SELECT pr.name, ct.name
		FROM shop.products pr
			JOIN shop.catalogs ct
		ON ct.id = pr.catalog_id;

SELECT * FROM shop.names;

-- 3.	по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.


-- 4.	(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.



-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- 1.	Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
	RETURNS VARCHAR(255) DETERMINISTIC
		BEGIN
			IF (CURRENT_TIME >= '6:00:00' AND CURRENT_TIME < '12:00:00') THEN
				RETURN 'Доброе утро';
			ELSEIF (CURRENT_TIME >= '12:00:00' AND CURRENT_TIME < '18:00:00') THEN
				RETURN 'Добрый день';
			ELSEIF (CURRENT_TIME >= '18:00:00' OR CURRENT_TIME < '00:00:00') THEN
				RETURN 'Добрый вечер';
			ELSE
				RETURN 'Быстро спать';
			END IF;
		END//

SELECT hello()//

-- 2.	В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.
DROP TRIGGER IF EXISTS products_not_null//
CREATE TRIGGER products_not_null BEFORE UPDATE ON products
	FOR EACH ROW
	BEGIN
		DECLARE name_desc VARCHAR(255);
		SET NEW.name = COALESCE(NEW.name, OLD.name, name_desc);
		SET NEW.description = COALESCE (NEW.description, OLD.description, name_desc);
	END//

-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

