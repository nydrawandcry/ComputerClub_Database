#нормальная генерация гаджетов и мебели для бд
#ПОТОМУ ЧТО НАХУЙ Я СНАЧАЛА ПОСТАВИЛА РЭНДЖ В 500 ХОТЯ ИГРОВЫХ МЕСТ У МЕНЯ КОСАРЬ И ТАК ЖЕ С МЕБЕЛЬЮ Я АЛЬТЕРНАТИВНО ОДАРЕННАЯ

import string
import random
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

#furniture
for _ in range(507, 1000):
    type_ = random.choice(['chair', 'desk', 'shelf'])
    name = f"{type_}_{random_string(5)}"
    output.append(f"INSERT INTO furniture (type, name) VALUES ('{type_}', '{name}');")

#gadgets
for _ in range(507, 1000):
    mouse = f"mouse_{random_string(5)}"
    carpet = f"carpet_{random_string(5)}"
    keyboard = f"keyboard_{random_string(5)}"
    headphones = f"headphones_{random_string(5)}"
    monitor = f"monitor_{random_string(5)}"
    output.append(f"INSERT INTO gadgets (mouse, carpet, keyboard, headphones, monitor) VALUES ('{mouse}', '{carpet}', '{keyboard}', '{headphones}', '{monitor}');")

    # --- Сохранение в файл ---
filename = "ihatethis.sql"
with open(filename, "w", encoding="utf-8") as f:
    f.write('\n'.join(output))

print("✅ Файл создан:", os.path.abspath(filename))