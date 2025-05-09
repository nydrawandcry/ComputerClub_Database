INSERT INTO client (name, age, phone, balance, status) 
VALUES ('Новый Клиент', 25, '89997776655', 0, 'обычный');
  SELECT * FROM client;

UPDATE client 
SET balance = balance + 500 
WHERE id = 2;

UPDATE client 
SET balance = balance - 300 
WHERE id = 3;

UPDATE client 
SET balance = balance + 100 
WHERE status = 'VIP';

SELECT * FROM client 
WHERE phone = '89998887766';

ALTER TABLE client 
ADD CONSTRAINT unique_phone UNIQUE (phone);

-- Получить список всех компьютеров с конфигурацией и состоянием
SELECT PC.id AS pc_number, 
       configuration.*, 
       PC.is_functionable
FROM PC
JOIN pc_configuration ON PC.id = pc_configuration.pc_id
JOIN configuration ON pc_configuration.configuration_id = configuration.id;

-- Получить статус каждого компьютера (предположим: "занят", если is_being_used = TRUE, иначе "свободен", если is_functionable = TRUE)
SELECT PC.id,
       CASE 
           WHEN pc_configuration.is_being_used = TRUE THEN 'Занят'
           WHEN PC.is_functionable = FALSE THEN 'Неисправен'
           ELSE 'Свободен'
       END AS status
FROM PC
JOIN pc_configuration ON PC.id = pc_configuration.pc_id;


INSERT INTO client_rents_gaming_place (client_id, gaming_place_id, session_start, session_end)
VALUES (1, 2, '17:00:00', '19:00:00');

SELECT 
  crgp.client_id,
  crgp.gaming_place_id,
  TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end) AS duration_minutes,
  ROUND(TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end) / 60 * 100, 2) AS total_cost
FROM client_rents_gaming_place crgp
WHERE crgp.client_id = 1
ORDER BY crgp.session_start DESC
LIMIT 1;

-- Через кассу
UPDATE client
SET balance = balance + 1000
WHERE id = 1;

-- Через онлайн-платёж (по номеру телефона)
UPDATE client
SET balance = balance + 500
WHERE phone = '89998887766';

-- Автоматическое списание средств после окончания последнего сеанса клиента
UPDATE client
INNER JOIN (
    SELECT 
        crgp.client_id,
        ROUND(TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end) / 60 * 100, 2) AS amount_to_deduct
    FROM client_rents_gaming_place AS crgp
    INNER JOIN client AS c ON crgp.client_id = c.id
    WHERE c.name = 'Корнилов Игорь'
    ORDER BY crgp.session_start DESC
    LIMIT 1
) AS cost_subquery
ON client.id = cost_subquery.client_id
SET client.balance = client.balance - cost_subquery.amount_to_deduct;

-- Получение всех администраторов
SELECT * FROM employee
WHERE profession = 'администратор';

-- Проверка прав пользователя
SELECT profession FROM employee
WHERE login = 'admin1' AND password = 'securepass'; -- в реальной системе пароль будет хеширован

-- ТО ЧТО НА ЕОСЕ

-- Обновление ФИО клиента, у которого опечатка в имени
UPDATE client
SET name = 'Дарков Соулс'
WHERE name = 'Дарков Соул';

-- Обновление модели видеокарты у ПК с устаревшей конфигурацией
UPDATE configuration
SET graphics_card = 'GTX 1660 Super'
WHERE graphics_card = 'GTX 1650';

-- Изменение профессии сотрудника (например, если по ошибке указан «Сисадмин» вместо «Техник»)
UPDATE employee
SET profession = 'Техник'
WHERE name = 'Михаил Громов';

-- Исправление модели мыши в гаджетах (опечатка или неправильный вариант)
UPDATE gadgets
SET mouse = 'Logitech G502 Hero'
WHERE mouse = 'Logitech G502';

-- Замена мебели на более актуальную в игровом месте
UPDATE furniture
SET name = 'DXRacer King Series'
WHERE name = 'DXRacer Formula F08';
-- --------------------------------------------------------

-- Удаление клиента с фальшивым/тестовым ФИО
DELETE FROM client
WHERE name = 'Тестовый Клиент';
-- Удаление мебели с ошибочным названием
DELETE FROM furniture
WHERE name = 'IKEA Gaming Table 140см'
  AND type = 'Кресло';  -- логическая ошибка в типе
-- Удаление конфигурации с некорректным блоком питания
DELETE FROM configuration
WHERE power_unit = '0W Noname';
-- Удаление набора гаджетов с отсутствующим монитором
DELETE FROM gadgets
WHERE monitor IS NULL OR monitor = '';
-- Удаление сотрудника с пустым именем
DELETE FROM employee
WHERE name = '';

-- ---------------------------------------------------------
-- Получить уникальные профессии сотрудников
SELECT DISTINCT profession
FROM employee;

-- Вывести клиентов с балансом от 500 до 2000 ₽
SELECT name, balance
FROM client
WHERE balance BETWEEN 500 AND 2000;

-- Найти всех клиентов, у которых нет ни копейки на счёте
SELECT name
FROM client
WHERE balance = 0;

-- Сотрудники НЕ администраторы и НЕ уборщики
SELECT name, profession
FROM employee
WHERE profession NOT IN ('Администратор', 'Уборщик');

-- Гаджеты, у которых указаны мыши бренда Logitech или Razer
SELECT mouse, keyboard
FROM gadgets
WHERE mouse LIKE 'Logitech%' OR mouse LIKE 'Razer%';

-- ПК, конфигурации которых содержат видеокарты RTX
SELECT graphics_card
FROM configuration
WHERE graphics_card LIKE 'RTX%';

-- Столы, добавленные как мебель
SELECT name AS table_model
FROM furniture
WHERE type = 'Стол';

-- Получить клиентов с именем, начинающимся на «Г»
SELECT name
FROM client
WHERE name LIKE 'Г%';

-- Посещения, начавшиеся до 14:00
SELECT client_id, session_start
FROM client_rents_gaming_place
WHERE session_start < '14:00:00';

-- Конфигурации с более 16 ГБ ОЗУ (по ключевому слову)
SELECT CPU, RAM
FROM configuration
WHERE RAM LIKE '3%GB%' OR RAM LIKE '32%';

--  Подсчитать продолжительность сеанса в минутах
SELECT 
  client_id, 
  TIMESTAMPDIFF(MINUTE, session_start, session_end) AS duration_minutes
FROM client_rents_gaming_place;

-- Клиенты с VIP-статусом и положительным балансом
SELECT name, balance
FROM client
WHERE status = 'VIP' AND balance > 0;

-- Проверка на отсутствие оборудования (NULL монитор)
SELECT *
FROM gadgets
WHERE monitor IS NULL;

-- Вывод с форматированием дат
SELECT 
  DATE_FORMAT(setting_date, '%d.%m.%Y') AS formatted_date,
  is_being_used
FROM gaming_place_furniture;

-- Склейка текстов: название мыши + коврик
SELECT 
  CONCAT(mouse, ' + ', carpet) AS mousepad_set
FROM gadgets;

-- Посещения клиентов между двумя временами
SELECT client_id, session_start, session_end
FROM client_rents_gaming_place
WHERE session_start BETWEEN '12:00:00' AND '15:00:00';

-- Проверка клиентов, у которых имя содержит пробел (ФИО)
SELECT name
FROM client
WHERE name LIKE '% %';

-- -----------------------------------------------

-- Найти всех клиентов, у которых фамилия начинается на "Гр"
SELECT name
FROM client
WHERE name LIKE 'Гр%';

-- Поиск сотрудников, в чьих ФИО есть слово "Игорь"
SELECT name
FROM employee
WHERE name LIKE '%Игорь%';

-- Найти все конфигурации, где упоминается "Ryzen"
SELECT CPU, motherboard
FROM configuration
WHERE CPU LIKE '%Ryzen%';

-- Поиск типов игровых мест, содержащих слово "зона" (регистр игнорируется)
SELECT type
FROM gaming_place
WHERE LOWER(type) LIKE '%зона%';

-- Поиск всей мебели, где название длиннее 20 символов
SELECT name
FROM furniture
WHERE CHAR_LENGTH(name) > 20;

-- Клиенты, чьи имена оканчиваются на "ий"
SELECT name
FROM client
WHERE name LIKE '%ий';

-- Сокращённое имя клиента (только фамилия) через SUBSTRING_INDEX
SELECT 
  name AS full_name,
  SUBSTRING_INDEX(name, ' ', 1) AS last_name
FROM client;

-- -----------------------------------------

-- Создание тестовой таблицы для копирования клиентов со статусом VIP
CREATE TABLE vip_clients AS
SELECT * FROM client WHERE 1=0;  -- создаем структуру без данных

-- Создание тестовой таблицы для копирования информации о занятых ПК
CREATE TABLE busy_pcs (
  pc_id INT,
  place_type VARCHAR(255),
  is_functionable BOOLEAN
);

--  INSERT INTO ... SELECT (клиенты со статусом VIP)
INSERT INTO vip_clients
SELECT *
FROM client
WHERE status = 'VIP';

-- INSERT INTO ... SELECT (занятые игровые места с ПК)
INSERT INTO busy_pcs (pc_id, place_type, is_functionable)
SELECT pc.id, gp.type, pc.is_functionable
FROM pc
JOIN gaming_place gp ON pc.gaming_place_id = gp.id
JOIN pc_configuration pcc ON pcc.pc_id = pc.id
WHERE pcc.is_being_used = TRUE;

-- CREATE TABLE ... SELECT (альтернатива SELECT INTO)
CREATE TABLE employee_payment_report AS
SELECT name, profession, payment
FROM employee
WHERE payment >= 45000;

-- -----------------------------------------

-- INNER JOIN (Клиенты и арендованные ими места)
SELECT c.name AS client_name, gp.type AS place_type
FROM client c
INNER JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id
INNER JOIN gaming_place gp ON crgp.gaming_place_id = gp.id;

-- LEFT JOIN (все клиенты + информация об аренде, если есть)
SELECT c.name, crgp.session_start, crgp.session_end
FROM client c
LEFT JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id;

-- RIGHT JOIN (все игровые места + информация о клиенте, если арендовано)
SELECT gp.type, c.name
FROM client_rents_gaming_place crgp
RIGHT JOIN gaming_place gp ON gp.id = crgp.gaming_place_id
LEFT JOIN client c ON c.id = crgp.client_id;

-- FULL OUTER JOIN (эмуляция через UNION, т.к. MySQL не поддерживает FULL OUTER JOIN напрямую)
SELECT c.name, crgp.session_start
FROM client c
LEFT JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id

UNION

SELECT c.name, crgp.session_start
FROM client c
RIGHT JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id;

-- CROSS JOIN (все сочетания клиентов и сотрудников — не рекомендовано для больших данных)
SELECT c.name AS client_name, e.name AS employee_name
FROM client c
CROSS JOIN employee e;

-- NATURAL JOIN (gadgets и gaming_place_gadgets)
SELECT *
FROM gadgets
NATURAL JOIN gaming_place_gadgets;

-- INNER JOIN с фильтрацией (VIP-клиенты арендуют место)
SELECT c.name, gp.type
FROM client c
JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id
JOIN gaming_place gp ON gp.id = crgp.gaming_place_id
WHERE c.status = 'VIP';

-- Компьютеры с их конфигурацией и игровым местом
SELECT pc.id AS pc_id, cfg.CPU, gp.type
FROM pc
JOIN pc_configuration pcc ON pc.id = pcc.pc_id
JOIN configuration cfg ON cfg.id = pcc.configuration_id
JOIN gaming_place gp ON pc.gaming_place_id = gp.id;

-- Места и установленная на них мебель (многие ко многим)
SELECT gp.type, f.name AS furniture_name
FROM gaming_place gp
JOIN gaming_place_furniture gpf ON gp.id = gpf.gaming_place_id
JOIN furniture f ON f.id = gpf.furniture_id;

-- Места и гаджеты (многие ко многим)
SELECT gp.type, g.mouse, g.keyboard
FROM gaming_place gp
JOIN gaming_place_gadgets gpg ON gp.id = gpg.place_id
JOIN gadgets g ON g.id = gpg.gadget_id;

-- Сотрудники, обслуживающие игровые места (многие ко многим)
SELECT e.name AS employee, gp.type AS place
FROM employee e
JOIN employee_maintains_gaming_place emp ON e.id = emp.employee_id
JOIN gaming_place gp ON gp.id = emp.gaming_place_id;

-- Гаджеты, установленные после определенной даты
SELECT gp.type, g.mouse
FROM gaming_place gp
JOIN gaming_place_gadgets gpg ON gp.id = gpg.place_id
JOIN gadgets g ON g.id = gpg.gadget_id
WHERE gpg.setting_date > '2025-01-01';

-- Места с активными ПК (в эксплуатации)
SELECT gp.type, pc.id AS pc_id
FROM gaming_place gp
JOIN pc ON gp.id = pc.gaming_place_id
JOIN pc_configuration pcc ON pc.id = pcc.pc_id
WHERE pcc.is_being_used = TRUE;

-- VIP-клиенты и всё их оборудование
SELECT c.name, gp.type, g.mouse, f.name AS furniture
FROM client c
JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id
JOIN gaming_place gp ON gp.id = crgp.gaming_place_id
JOIN gaming_place_gadgets gpg ON gp.id = gpg.place_id
JOIN gadgets g ON g.id = gpg.gadget_id
JOIN gaming_place_furniture gpf ON gp.id = gpf.gaming_place_id
JOIN furniture f ON f.id = gpf.furniture_id
WHERE c.status = 'VIP';

-- Сотрудники + места + ПК, которые они обслуживают
SELECT e.name AS employee, gp.type AS place, pc.id AS pc_id
FROM employee e
JOIN employee_maintains_gaming_place emp ON e.id = emp.employee_id
JOIN gaming_place gp ON emp.gaming_place_id = gp.id
JOIN pc ON pc.gaming_place_id = gp.id;

-- --------------------------------
-- Кол-во клиентов по статусу
SELECT status, COUNT(*) AS count_clients
FROM client
GROUP BY status;

-- Средний баланс клиентов по статусу
SELECT status, AVG(balance) AS avg_balance
FROM client
GROUP BY status;

-- Суммарный баланс клиентов, где больше 1000
SELECT status, SUM(balance) AS total_balance
FROM client
GROUP BY status
HAVING SUM(balance) > 1000;

-- Кол-во сессий на каждое игровое место
SELECT gp.type, COUNT(*) AS sessions
FROM gaming_place gp
JOIN client_rents_gaming_place crgp ON gp.id = crgp.gaming_place_id
GROUP BY gp.type;

-- MAX, MIN и AVG продолжительности сессии по местам
SELECT gp.type,
       MAX(TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end)) AS max_duration,
       MIN(TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end)) AS min_duration,
       AVG(TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end)) AS avg_duration
FROM gaming_place gp
JOIN client_rents_gaming_place crgp ON gp.id = crgp.gaming_place_id
GROUP BY gp.type;

-- ТОП-3 клиента с наибольшим балансом
SELECT name, balance
FROM client
ORDER BY balance DESC
LIMIT 3;

-- Средняя зарплата по профессиям
SELECT profession, AVG(payment) AS avg_salary
FROM employee
GROUP BY profession;

-- Сотрудники с ЗП выше 45000
SELECT profession, payment
FROM employee
WHERE payment > 45000
ORDER BY payment DESC;

-- Кол-во мебели по типу
SELECT type, COUNT(*) AS total
FROM furniture
GROUP BY type;

-- Количество ПК с каждой конфигурацией
SELECT cfg.CPU, COUNT(pc.id) AS count_pc
FROM configuration cfg
JOIN pc_configuration pcc ON cfg.id = pcc.configuration_id
JOIN pc ON pc.id = pcc.pc_id
GROUP BY cfg.CPU;

-- Средняя длительность аренды по каждому клиенту
SELECT c.name, AVG(TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end)) AS avg_duration
FROM client c
JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id
GROUP BY c.name;

-- Места, на которых установлено больше 1 единицы оборудования
SELECT gp.type, COUNT(gpf.furniture_id) AS furniture_count
FROM gaming_place gp
JOIN gaming_place_furniture gpf ON gp.id = gpf.gaming_place_id
GROUP BY gp.type
HAVING furniture_count > 1;

-- Средний возраст клиентов с VIP-статусом
SELECT AVG(age) AS avg_age
FROM client
WHERE status = 'VIP';

-- Кол-во клиентов с балансом между 500 и 2000
SELECT COUNT(*) AS count_clients
FROM client
WHERE balance BETWEEN 500 AND 2000;

-- Сколько раз каждый сотрудник обслуживал место
SELECT e.name, COUNT(emp.gaming_place_id) AS places_maintained
FROM employee e
JOIN employee_maintains_gaming_place emp ON e.id = emp.employee_id
GROUP BY e.name;

-- ----------------------------------------

-- UNION: Клиенты с балансом выше 1000 или возрастом до 18 лет
SELECT name, age, balance FROM client WHERE balance > 1000
UNION
SELECT name, age, balance FROM client WHERE age < 18;

-- UNION ALL: Те же, но с возможными дубликатами
SELECT name, age, balance FROM client WHERE balance > 1000
UNION ALL
SELECT name, age, balance FROM client WHERE age < 18;

-- Эмуляция INTERSECT: Клиенты, у которых возраст < 18 и баланс > 1000
	-- В MySQL напрямую INTERSECT не поддерживается, поэтому используем обычный AND
SELECT name, age, balance FROM client
WHERE age < 18 AND balance > 1000;

-- Эмуляция EXCEPT: Клиенты с балансом > 1000, но исключая тех, кому меньше 18 лет
	-- EXCEPT реализован через подзапрос и NOT IN
SELECT name, age, balance FROM client
WHERE balance > 1000
AND id NOT IN (
    SELECT id FROM client WHERE age < 18
);

-- UNION с разными таблицами: Имена клиентов и сотрудников (с пометкой)
SELECT name, 'client' AS role FROM client
UNION
SELECT name, 'employee' AS role FROM employee;

-- --------------------------------------------

-- Клиенты, чей баланс больше, чем у ВСЕХ клиентов со статусом "обычный" (ALL)
SELECT name, balance
FROM client
WHERE balance > ALL (
    SELECT balance FROM client WHERE status = 'обычный'
);
-- Клиенты, чей баланс выше СРЕДНЕГО среди всех клиентов (AVG с GROUP BY)
SELECT name, balance
FROM client
WHERE balance > (
    SELECT AVG(balance) FROM client
);
-- Клиенты, у которых есть хотя бы одно посещение (EXISTS)
SELECT c.name
FROM client c
WHERE EXISTS (
    SELECT 1 FROM client_rents_gaming_place crgp
    WHERE crgp.client_id = c.id
);
-- ПК, чья конфигурация используется более чем на одном ПК (GROUP BY в подзапросе)
SELECT pc.id, pc.is_functionable
FROM pc
WHERE pc.id IN (
    SELECT pc_id
    FROM pc_configuration
    GROUP BY configuration_id
    HAVING COUNT(*) > 1
);
-- ПК с конфигурацией, у которой SSD больше любого из конфигураций с RTX 3050 (ANY + вложенный SELECT)
SELECT id, SSD
FROM configuration
WHERE SSD > ANY (
    SELECT SSD FROM configuration WHERE graphics_card = 'RTX 3050'
);

-- -----------------------------------

-- GROUP_CONCAT — список ПК, привязанных к каждой игровой зоне
SELECT gp.type AS gaming_place_type,
       GROUP_CONCAT(pc.id ORDER BY pc.id SEPARATOR ', ') AS pc_list
FROM gaming_place gp
JOIN pc ON gp.id = pc.gaming_place_id
GROUP BY gp.type;

-- CONCAT + UPPER — показать имена клиентов в верхнем регистре с припиской их статуса
SELECT UPPER(name) AS upper_name,
       CONCAT('Статус: ', status) AS status_info
FROM client;

-- LENGTH, SUBSTRING и арифметика — отрезать часть номера телефона, показать длину имени и удвоить баланс
SELECT name,
       LENGTH(name) AS name_length,
       SUBSTRING(phone, 4, 3) AS phone_code,
       balance * 2 AS double_balance
FROM client;

-- -----------------------------------

-- WITH + AVG — клиенты, у которых баланс выше среднего
WITH avg_balance_cte AS (
    SELECT AVG(balance) AS avg_balance FROM client
)
SELECT name, balance
FROM client, avg_balance_cte
WHERE client.balance > avg_balance_cte.avg_balance;

-- WITH + JOIN — игровая зона и имя клиента, который её арендовал
WITH rental_info AS (
    SELECT crgp.client_id, crgp.gaming_place_id, gp.type AS place_type
    FROM client_rents_gaming_place crgp
    JOIN gaming_place gp ON gp.id = crgp.gaming_place_id
)
SELECT c.name AS client_name, rental_info.place_type
FROM rental_info
JOIN client c ON c.id = rental_info.client_id;

-- WITH + GROUP BY — количество аренд по каждому типу зоны
WITH rents_by_type AS (
    SELECT gp.type, COUNT(*) AS rent_count
    FROM client_rents_gaming_place crgp
    JOIN gaming_place gp ON gp.id = crgp.gaming_place_id
    GROUP BY gp.type
)
SELECT * FROM rents_by_type
ORDER BY rent_count DESC;

-- -----------------------------------

-- LENGTH, LOWER, REPLACE — работа со строками
SELECT 
  name,
  LENGTH(name) AS name_length,
  LOWER(name) AS lower_name,
  REPLACE(name, 'о', '@') AS replaced_name
FROM client;

-- CONCAT, SUBSTRING_INDEX — строковые функции для ФИО
SELECT 
  name,
  SUBSTRING_INDEX(name, ' ', 1) AS first_word,
  CONCAT('Клиент: ', name) AS full_info
FROM client;

-- NOW(), DATE_FORMAT — вывод текущей даты и форматирование
SELECT 
  NOW() AS current_datetime,
  DATE_FORMAT(NOW(), '%d.%m.%Y %H:%i') AS formatted_datetime;

-- TIMEDIFF, HOUR, MINUTE — работа с временем аренды
SELECT 
  session_start,
  session_end,
  TIMEDIFF(session_end, session_start) AS duration,
  HOUR(TIMEDIFF(session_end, session_start)) AS hours,
  MINUTE(TIMEDIFF(session_end, session_start)) AS minutes
FROM client_rents_gaming_place;

-- Арифметика: ROUND, FLOOR, CEIL
SELECT 
  name,
  balance,
  ROUND(balance / 3, 2) AS third_of_balance,
  FLOOR(balance / 3) AS floored,
  CEIL(balance / 3) AS ceiled
FROM client;

-- DATEDIFF между текущей датой и вымышленной установкой конфигурации
SELECT 
  pc_id,
  setting_date,
  DATEDIFF(NOW(), setting_date) AS days_since_set
FROM pc_configuration;

-- Комбинация: строка + дата + арифметика
SELECT 
  CONCAT('ПК №', pc.id) AS pc_label,
  DATE_FORMAT(pcc.setting_date, '%M %Y') AS setup_month,
  DATEDIFF(NOW(), pcc.setting_date) DIV 30 AS approx_months_in_use
FROM pc
JOIN pc_configuration pcc ON pcc.pc_id = pc.id;

-- ---------------------------------------

-- Клиенты и их общее время аренды в минутах, отсортированные по убыванию
SELECT 
  c.name AS client_name,
  SUM(TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end)) AS total_minutes
FROM client_rents_gaming_place crgp
JOIN client c ON crgp.client_id = c.id
GROUP BY c.name
ORDER BY total_minutes DESC
LIMIT 5;

-- Игровые зоны с количеством арендуемых ПК и типом конфигурации
SELECT 
  gp.type AS gaming_place_type,
  COUNT(DISTINCT pc.id) AS pc_count,
  GROUP_CONCAT(DISTINCT cfg.CPU SEPARATOR ', ') AS cpu_models
FROM gaming_place gp
JOIN pc ON pc.gaming_place_id = gp.id
JOIN pc_configuration pcc ON pcc.pc_id = pc.id
JOIN configuration cfg ON cfg.id = pcc.configuration_id
GROUP BY gp.type
ORDER BY pc_count DESC;

-- Сотрудники, поддерживающие более одной игровой зоны
SELECT 
  e.name AS employee_name,
  COUNT(DISTINCT egp.gaming_place_id) AS supported_places
FROM employee e
JOIN employee_maintains_gaming_place egp ON e.id = egp.employee_id
GROUP BY e.id
HAVING COUNT(egp.gaming_place_id) > 1
ORDER BY supported_places DESC;

-- Клиенты, которые арендовали VIP-зоны, и продолжительность их сессий
SELECT 
  c.name,
  gp.type,
  TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end) AS session_duration_min
FROM client_rents_gaming_place crgp
JOIN client c ON crgp.client_id = c.id
JOIN gaming_place gp ON crgp.gaming_place_id = gp.id
WHERE gp.type = 'VIP'
ORDER BY session_duration_min DESC;

-- Средний баланс клиентов по статусу + вывод с форматированием
SELECT 
  status,
  ROUND(AVG(balance), 2) AS avg_balance
FROM client
GROUP BY status
ORDER BY avg_balance DESC;

-- Последние 3 сеанса по времени окончания
SELECT 
  c.name,
  gp.type AS place_type,
  crgp.session_end
FROM client_rents_gaming_place crgp
JOIN client c ON crgp.client_id = c.id
JOIN gaming_place gp ON gp.id = crgp.gaming_place_id
ORDER BY crgp.session_end DESC
LIMIT 3;

-- Клиенты с балансом выше среднего, которые арендовали игровые места
WITH avg_balance_cte AS (
  SELECT AVG(balance) AS avg_balance FROM client
)
SELECT 
  c.name,
  c.balance,
  gp.type AS gaming_place
FROM client c
JOIN client_rents_gaming_place crgp ON crgp.client_id = c.id
JOIN gaming_place gp ON gp.id = crgp.gaming_place_id,
avg_balance_cte
WHERE c.balance > avg_balance_cte.avg_balance
ORDER BY c.balance DESC;


















