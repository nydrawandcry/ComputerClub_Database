-- представления view

-- vip_client_equipment_view
-- Показывает VIP-клиентов и всё оборудование их игровых мест: гаджеты и мебель.
CREATE VIEW vip_client_equipment_view AS
SELECT 
  c.name AS client_name,
  gp.type AS place_type,
  g.mouse,
  g.keyboard,
  g.headphones,
  f.name AS furniture_name
FROM client c
JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id
JOIN gaming_place gp ON gp.id = crgp.gaming_place_id
JOIN gaming_place_gadgets gpg ON gp.id = gpg.place_id
JOIN gadgets g ON g.id = gpg.gadget_id
JOIN gaming_place_furniture gpf ON gp.id = gpf.gaming_place_id
JOIN furniture f ON f.id = gpf.furniture_id
WHERE c.status = 'VIP';


-- employee_support_summary_view
-- Показывает сотрудников и количество игровых мест, которые они обслуживают.
CREATE VIEW employee_support_summary_view AS
SELECT 
  e.id AS employee_id,
  e.name AS employee_name,
  e.profession,
  COUNT(egp.gaming_place_id) AS supported_places
FROM employee e
JOIN employee_maintains_gaming_place egp ON e.id = egp.employee_id
GROUP BY e.id, e.name, e.profession;


-- client_session_durations_view
-- Выводит клиентов, тип арендуемого игрового места и длительность последнего сеанса.
CREATE VIEW client_session_durations_view AS
SELECT 
  c.name AS client_name,
  gp.type AS place_type,
  crgp.session_start,
  crgp.session_end,
  TIMESTAMPDIFF(MINUTE, crgp.session_start, crgp.session_end) AS session_duration_min
FROM client c
JOIN client_rents_gaming_place crgp ON c.id = crgp.client_id
JOIN gaming_place gp ON gp.id = crgp.gaming_place_id;


-- CALLS
-- 1
SELECT * FROM vip_client_equipment_view;
-- 2
SELECT * FROM employee_support_summary_view;
-- 3
SELECT * FROM client_session_durations_view;