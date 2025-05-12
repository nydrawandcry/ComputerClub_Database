-- Возвращает статус клиента по его ID
DELIMITER $$

CREATE FUNCTION getClientStatusById(client_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
DECLARE client_status VARCHAR(100);

SELECT status INTO client_status
FROM client
WHERE id = client_id;

RETURN IFNULL(client_status, 'Неизвестный клиент');
END$$

DELIMITER ;

-- Возвращает среднюю продолжительность сессий клиента в минутах
DELIMITER $$

CREATE FUNCTION avgSessionDuration(clientId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE avg_minutes INT;

  SELECT AVG(TIMESTAMPDIFF(MINUTE, session_start, session_end))
  INTO avg_minutes
  FROM client_rents_gaming_place
  WHERE client_id = clientId;

  RETURN IFNULL(avg_minutes, 0);
END$$

DELIMITER ;

-- Проверяет, функционален ли ПК и возвращает текст
DELIMITER $$

CREATE FUNCTION checkPcStatus(pcId INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE result VARCHAR(100);
  DECLARE is_working BOOL;

  SELECT is_functionable INTO is_working FROM PC WHERE id = pcId;

  SET result = CASE
    WHEN ISNULL(is_working) THEN 'ПК не найден'
    WHEN is_working THEN 'Работает'
    ELSE 'Не работает'
  END;

  RETURN result;
END$$

DELIMITER ;

-- ВЫЗОВЫ ТРЕХ ФУНКЦИЙ --
-- 
SELECT getClientStatusById(1);
-- 
SELECT avgSessionDuration(5);
-- 
SELECT checkPcStatus(2);