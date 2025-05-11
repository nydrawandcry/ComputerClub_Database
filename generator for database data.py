# generator for database
# скрипт для заполнения таблиц БД рандомными данными

import random
import string
import os
from datetime import datetime, timedelta

def random_string(length=8):
    return ''.join(random.choices(string.ascii_lowercase, k=length))

def random_phone():
    return "+7" + ''.join(random.choices("0123456789", k=10))

def random_date(days_back=730):
    return (datetime.today() - timedelta(days=random.randint(0, days_back))).strftime('%Y-%m-%d')

def random_time(start_hour=10, max_hours=5):
    start = datetime.strptime(f"{start_hour}:00", "%H:%M")
    end = start + timedelta(hours=random.randint(1, max_hours))
    return start.strftime('%H:%M:%S'), end.strftime('%H:%M:%S')

output = []

# --- Клиенты ---
for _ in range(10000):
    name = random_string(10)
    age = random.randint(12, 42)
    phone = random_phone()
    balance = round(random.uniform(0, 1000), 2)
    status = random.choice(['active', 'banned', 'vip'])
    output.append(f"INSERT INTO client (name, age, phone, balance, status) VALUES ('{name}', {age}, '{phone}', {balance}, '{status}');")

# --- Сотрудники ---
for _ in range(100):
    profession = random.choice(['admin', 'cleaner', 'tech_support'])
    name = random_string(8)
    payment = round(random.uniform(30000, 80000), 2)
    output.append(f"INSERT INTO employee (profession, name, payment) VALUES ('{profession}', '{name}', {payment});")

# --- Мебель ---
for _ in range(1000):
    type_ = random.choice(['chair', 'desk', 'shelf'])
    name = f"{type_}_{random_string(5)}"
    output.append(f"INSERT INTO furniture (type, name) VALUES ('{type_}', '{name}');")

# --- Гаджеты ---
for _ in range(1000):
    mouse = f"mouse_{random_string(5)}"
    carpet = f"carpet_{random_string(5)}"
    keyboard = f"keyboard_{random_string(5)}"
    headphones = f"headphones_{random_string(5)}"
    monitor = f"monitor_{random_string(5)}"
    output.append(f"INSERT INTO gadgets (mouse, carpet, keyboard, headphones, monitor) VALUES ('{mouse}', '{carpet}', '{keyboard}', '{headphones}', '{monitor}');")

# --- Конфигурации ---
for _ in range(500):
    motherboard = f"mb_{random_string(5)}"
    coolering = f"cool_{random_string(5)}"
    CPU = f"cpu_{random_string(4)}"
    RAM = f"ram_{random.randint(8, 64)}GB"
    SSD = f"ssd_{random.randint(128, 1024)}GB"
    graphics_card = f"gpu_{random_string(5)}"
    power_unit = f"psu_{random.randint(400, 800)}W"
    output.append(f"INSERT INTO configuration (motherboard, coolering, CPU, RAM, SSD, graphics_card, power_unit) VALUES ('{motherboard}', '{coolering}', '{CPU}', '{RAM}', '{SSD}', '{graphics_card}', '{power_unit}');")

# --- Игровые места ---
for i in range(1, 1001):
    type_ = random.choice(['standard', 'premium', 'vip'])
    output.append(f"INSERT INTO gaming_place (id, type) VALUES ({i}, '{type_}');")

# --- ПК ---
for i in range(1, 1001):
    is_functionable = random.choice(['true', 'false'])
    output.append(f"INSERT INTO PC (id, is_functionable, gaming_place_id) VALUES ({i}, {is_functionable}, {i});")

# ТАБЛИЦЫ ДЛЯ СВЯЗЕЙ ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ ПОМОГИТЕ

# --- Клиенты арендуют игровые места ---
# --- client_rents_gaming_place ---
for place_id in range(1, 1001):
    client_id = random.randint(1, 10000)
    start_time, end_time = random_time()
    output.append(f"INSERT INTO client_rents_gaming_place (client_id, gaming_place_id, session_start, session_end) VALUES ({client_id}, {place_id}, '{start_time}', '{end_time}');")

# --- Сотрудники обслуживают игровые места ---
# --- employee_maintains_gaming_place ---
for place_id in range(1, 1001):
    employee_id = random.randint(1, 100)
    output.append(f"INSERT INTO employee_maintains_gaming_place (employee_id, gaming_place_id) VALUES ({employee_id}, {place_id});")

# --- ПК используют конфигурации ---
# --- pc_configuration ---
for pc_id in range(1, 1001):
    configuration_id = random.randint(1, 500)
    setting_date = random_date()
    is_being_used = random.choice(['true', 'false'])
    output.append(f"INSERT INTO pc_configuration (pc_id, configuration_id, setting_date, is_being_used) VALUES ({pc_id}, {configuration_id}, '{setting_date}', {is_being_used});")

# --- Гаджеты для игровых мест ---
# --- gaming_place_gadgets ---
for place_id in range(1, 1001):
    gadget_id = place_id  # чтобы сохранить уникальность (по твоей схеме)
    setting_date = random_date()
    is_being_used = random.choice(['true', 'false'])
    output.append(f"INSERT INTO gaming_place_gadgets (place_id, gadget_id, setting_date, is_being_used) VALUES ({place_id}, {gadget_id}, '{setting_date}', {is_being_used});")

# --- Мебель для игровых мест ---
# --- gaming_place_furniture ---
for place_id in range(1, 1001):
    furniture_id = place_id  # уникальность сохраняем
    setting_date = random_date()
    is_being_used = random.choice(['true', 'false'])
    output.append(f"INSERT INTO gaming_place_furniture (gaming_place_id, furniture_id, setting_date, is_being_used) VALUES ({place_id}, {furniture_id}, '{setting_date}', {is_being_used});")

# --- Сохранение в файл ---
filename = "generate_10000data.sql"
with open(filename, "w", encoding="utf-8") as f:
    f.write('\n'.join(output))

print("✅ Файл создан:", os.path.abspath(filename))
