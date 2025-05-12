-- триггер
DELIMITER $$

CREATE TRIGGER before_client_balance_update
BEFORE UPDATE ON client
FOR EACH ROW
BEGIN
  IF NEW.balance < 0 THEN
    SET NEW.balance = 0;
  END IF;
END$$

DELIMITER ;

-- Создадим тестового клиента и проведем с ним несколько манипуляций, чтобы проверить работу триггера
INSERT INTO client (name, age, phone, balance, status)
VALUES ('Иван Тестовый', 25, '1234567890', 100.00, 'Обычный');

-- чек его баланса
SELECT id, name, balance FROM client WHERE name = 'Иван Тестовый';

-- попытка установить отрицательный баланс
UPDATE client SET balance = -50 WHERE id = 10010;

-- снова чек баланса на работу триггера
SELECT id, name, balance FROM client WHERE name = 'Иван Тестовый';
