-- indexes for boosting requests

-- Индекс по статусу клиента (для фильтрации VIP)
CREATE INDEX idx_client_status ON client(status);

-- Индекс по client_id и gaming_place_id (часто используется в JOIN)
CREATE INDEX idx_client_rents ON client_rents_gaming_place(client_id, gaming_place_id);

-- Индексы для join и фильтрации по gadget_id и place_id
CREATE INDEX idx_gpg_place ON gaming_place_gadgets(place_id);
CREATE INDEX idx_gpg_gadget ON gaming_place_gadgets(gadget_id);

-- Индексы для join по furniture
CREATE INDEX idx_gpf_place ON gaming_place_furniture(gaming_place_id);
CREATE INDEX idx_gpf_furniture ON gaming_place_furniture(furniture_id);

-- Индекс по employee_id (группировка и join)
CREATE INDEX idx_emp_maintain_empid ON employee_maintains_gaming_place(employee_id);

-- Индекс по gaming_place_id для оптимизации группировки
CREATE INDEX idx_emp_maintain_placeid ON employee_maintains_gaming_place(gaming_place_id);

-- Индекс по типу места (например, VIP)
CREATE INDEX idx_gp_type ON gaming_place(type);

-- Индексы для session_start и session_end — часто фильтруются и сортируются
CREATE INDEX idx_crgp_session_end ON client_rents_gaming_place(session_end);
CREATE INDEX idx_crgp_session_start_end ON client_rents_gaming_place(session_start, session_end);

-- Индекс по балансу (для сравнения со средним)
CREATE INDEX idx_client_balance ON client(balance);
