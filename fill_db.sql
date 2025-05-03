-- Клиенты (6 штук)
INSERT INTO client (name, age, phone, balance, status)
VALUES 
('Корнилов Игорь', 20, '89998887766', 1000, 'VIP'),
('Гречишников Иван', 18, '88005553535', 550, 'обычный'),
('Илларионов Пантелемей', 22, '89612344556', 300, 'VIP'),
('Дарков Соул', 19, '79883247656', 0, 'обычный'),
('Холлоув Найт', 35, '89334441584', 1500, 'обычный'),
('Берсерков Олег', 16, '86573455676', 5450, 'VIP');

-- Сотрудники (4)
INSERT INTO employee (profession, name, payment)
VALUES 
('Администратор', 'Екатерина Лапина', 45000.00),
('Сисадмин', 'Михаил Громов', 60000.00),
('Кассир', 'Татьяна Белова', 40000.00),
('Уборщик', 'Игорь Климов', 30000.00);

-- Мебель (6 позиций)
INSERT INTO furniture (type, name)
VALUES 
('Кресло', 'DXRacer Formula F08'),
('Стол', 'IKEA Gaming Table 140см'),
('Полка', 'Настенная для периферии'),
('Кресло', 'Cougar Armor One'),
('Стол', 'Arozzi Arena Desk'),
('Тумба', 'Под системный блок');

-- Гаджеты (6 наборов)
INSERT INTO gadgets (mouse, carpet, keyboard, headphones, monitor)
VALUES 
('Logitech G502', 'SteelSeries QcK', 'HyperX Alloy FPS', 'Razer Kraken', 'Acer Predator 27"'),
('Razer DeathAdder', 'Razer Goliathus', 'Razer BlackWidow', 'HyperX Cloud II', 'ASUS TUF 24"'),
('Zowie EC2', 'Zowie G-SR', 'Ducky One 2 Mini', 'Logitech G Pro X', 'BenQ XL2546'),
('SteelSeries Rival 600', 'CoolerMaster Pad', 'SteelSeries Apex 7', 'Corsair Void RGB', 'LG UltraGear 24"'),
('Bloody V8', 'Redragon Flick', 'Redragon K552', 'Bloody G300', 'Samsung Odyssey G5'),
('Glorious Model O', 'Glorious XL', 'Anne Pro 2', 'Logitech G435', 'MSI Optix MAG274');

-- Конфигурации ПК (6 штук)
INSERT INTO configuration (motherboard, coolering, CPU, RAM, SSD, graphics_card, power_unit)
VALUES 
('MSI B550 Tomahawk', 'BeQuiet Pure Rock', 'Ryzen 5 5600X', '16GB DDR4 3200MHz', '512GB NVMe', 'RTX 3060', '650W Corsair'),
('ASUS TUF B450', 'CoolerMaster Hyper 212', 'Ryzen 7 3700X', '32GB DDR4', '1TB SSD', 'RTX 3070', '700W Seasonic'),
('Gigabyte Z590', 'Noctua NH-U12S', 'Intel i7-11700K', '16GB DDR4', '512GB SSD', 'RTX 3080', '750W BeQuiet'),
('ASRock B660M', 'Deepcool GAMMAXX 400', 'Intel i5-12400F', '16GB DDR4', '256GB SSD', 'RTX 3050', '600W AeroCool'),
('MSI B450M', 'Stock AMD Cooler', 'Ryzen 3 3100', '8GB DDR4', '256GB SATA SSD', 'GTX 1650', '500W Chieftec'),
('ASUS Prime Z690', 'NZXT Kraken X53', 'Intel i9-12900K', '32GB DDR5', '1TB NVMe', 'RTX 4090', '850W Corsair');

-- Игровые места (6 штук)
INSERT INTO gaming_place (type)
VALUES 
('Стандартное'),
('Премиум'),
('VIP'),
('Стримерское'),
('Соревновательное'),
('Кибер-зона');

INSERT INTO PC (is_functionable, gaming_place_id)
VALUES
(TRUE, 1),
(TRUE, 2),
(TRUE, 3),
(TRUE, 4),
(TRUE, 5),
(TRUE, 6);

INSERT INTO pc_configuration (pc_id, configuration_id, setting_date, is_being_used)
VALUES
(1, 1, '2025-01-01', TRUE),
(2, 2, '2025-01-01', TRUE),
(3, 3, '2025-01-01', TRUE),
(4, 4, '2025-01-01', TRUE),
(5, 5, '2025-01-01', TRUE),
(6, 6, '2025-01-01', TRUE);


INSERT INTO gaming_place_gadgets (place_id, gadget_id, setting_date, is_being_used)
VALUES
(1, 1, '2025-01-01', TRUE),
(2, 2, '2025-01-01', TRUE),
(3, 3, '2025-01-01', TRUE),
(4, 4, '2025-01-01', TRUE),
(5, 5, '2025-01-01', TRUE),
(6, 6, '2025-01-01', TRUE);


INSERT INTO gaming_place_furniture (gaming_place_id, furniture_id, setting_date, is_being_used)
VALUES
(1, 1, '2025-01-01', TRUE),
(2, 2, '2025-01-01', TRUE),
(3, 3, '2025-01-01', TRUE),
(4, 4, '2025-01-01', TRUE),
(5, 5, '2025-01-01', TRUE),
(6, 6, '2025-01-01', TRUE);

INSERT INTO client_rents_gaming_place (client_id, gaming_place_id, session_start, session_end)
VALUES
(1, 1, '13:00:00', '15:00:00'),
(2, 2, '14:00:00', '16:30:00'),
(3, 3, '12:30:00', '14:30:00'),
(4, 4, '15:15:00', '17:00:00'),
(5, 5, '13:45:00', '15:15:00'),
(6, 6, '11:00:00', '12:00:00');

INSERT INTO employee_maintains_gaming_place (employee_id, gaming_place_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(1, 5),
(2, 6);

-- SET FOREIGN_KEY_CHECKS = 1;
-- TRUNCATE TABLE client;