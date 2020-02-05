-- Практическое задание по теме “Оптимизация запросов”
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время 
-- и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
USE shop;
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	content_id INT NOT NULL,
	name_of_content VARCHAR(255) NOT NULL,
	created_at DATETIME DEFAULT NULL,
	name_of_table VARCHAR(255) NOT NULL
) ENGINE=Archive;

DELIMITER //
DROP TRIGGER IF EXISTS logs_from_users//
CREATE TRIGGER logs_from_users AFTER INSERT ON users
FOR EACH ROW
BEGIN 
	INSERT INTO logs(content_id, name_of_content, created_at, name_of_table) 
	SELECT id, name, created_at, 'users' FROM users ORDER BY id DESC LIMIT 1;
END//

DROP TRIGGER IF EXISTS logs_from_catalogs//
CREATE TRIGGER logs_from_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN 
	INSERT INTO logs(content_id, name_of_content, created_at, name_of_table) 
	SELECT id, name, NULL, 'catalogs' FROM catalogs ORDER BY id DESC LIMIT 1;
END//

DROP TRIGGER IF EXISTS logs_from_products//
CREATE TRIGGER logs_from_products AFTER INSERT ON products
FOR EACH ROW
BEGIN 
	INSERT INTO logs(content_id, name_of_content, created_at, name_of_table) 
	SELECT id, name, created_at, 'products' FROM products ORDER BY id DESC LIMIT 1;
END

-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

-- Практическое задание по теме “NoSQL”
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
SET ip1
INCR ip1

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу 
-- и наоборот, поиск электронного адреса пользователя по его имени.
MSET email 'name' name 'email'
GET email
GET name

-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
db.shop.insert({categories : 'Процессоры'})
db.shop.insert({categories : 'Материнские платы'})
db.shop.insert({categories : 'Видеокарты'})
db.shop.insert({categories : 'Жесткие диски'})
db.shop.insert({categories : 'Оперативная память'})

db.shop.update({categories : 'Процессоры'}, {$set : {product : ['Intel Core i3-8100']}})
db.shop.update({categories : 'Процессоры'}, {$push : {product : 'Intel Core i5-7400'}})
db.shop.update({categories : 'Процессоры'}, {$push : {product : 'AMD FX-8320E'}})
db.shop.update({categories : 'Процессоры'}, {$push : {product : 'AMD FX-8320'}})
db.shop.update({categories : 'Материнские платы'}, {$set : {product : ['ASUS ROG MAXIMUS X HERO']}})
db.shop.update({categories : 'Материнские платы'}, {$push : {product : 'Gigabyte H310M S2H'}})
db.shop.update({categories : 'Материнские платы'}, {$push : {product : 'MSI B250M GAMING PRO'}})
