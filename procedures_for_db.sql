-- Пополнение баланса клиента
DELIMITER $$

CREATE PROCEDURE addBalance(IN clientId INT, IN amount FLOAT)
BEGIN
  DECLARE current_balance FLOAT;

  SELECT balance INTO current_balance FROM client WHERE id = clientId;

  IF ISNULL(current_balance) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Клиент не найден';
  ELSE
    UPDATE client SET balance = balance + amount WHERE id = clientId;
  END IF;
END$$

DELIMITER ;

-- Вывод оборудования игрового места
DELIMITER $$

CREATE PROCEDURE getGamingPlaceEquipment(IN placeId INT)
BEGIN
  SELECT g.mouse, g.keyboard, f.name AS furniture
  FROM gaming_place_gadgets gpg
  JOIN gadgets g ON g.id = gpg.gadget_id
  JOIN gaming_place_furniture gpf ON gpf.gaming_place_id = gpg.place_id
  JOIN furniture f ON f.id = gpf.furniture_id
  WHERE gpg.place_id = placeId;
END$$

DELIMITER ;

-- Массовое обновление статуса клиентов по возрасту
DELIMITER $$

CREATE PROCEDURE updateStatusByAge(IN minAge INT)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE cid INT;
  DECLARE cur CURSOR FOR SELECT id FROM client WHERE age >= minAge;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO cid;
    IF done THEN
      LEAVE read_loop;
    END IF;

    UPDATE client SET status = 'Возрастной VIP' WHERE id = cid;
  END LOOP;

  CLOSE cur;
END$$

DELIMITER ;

-- ВЫЗОВЫ
-- 1
CALL addBalance(1, 50.00);
-- 2
CALL getGamingPlaceEquipment(2);
-- 3
CALL updateStatusByAge(40);
