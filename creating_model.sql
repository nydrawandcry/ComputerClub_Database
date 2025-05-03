-- drop DATABASE comp_club_db;

CREATE DATABASE if not exists comp_club_db;
USE comp_club_db;

CREATE TABLE if not exists client
(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
age INT NOT NULL,
phone VARCHAR(100) NOT NULL,
balance FLOAT NOT NULL,
status VARCHAR(100) NOT NULL
);

CREATE TABLE if not exists employee
(
id INT AUTO_INCREMENT PRIMARY KEY,
profession VARCHAR(100) NOT NULL,
name VARCHAR(100) NOT NULL,
payment FLOAT NOT NULL
);

CREATE TABLE if not exists furniture
(
id INT AUTO_INCREMENT PRIMARY KEY,
type VARCHAR(100) NOT NULL,
name VARCHAR(100) NOT NULL
);

CREATE TABLE if not exists gadgets
(
id INT AUTO_INCREMENT PRIMARY KEY, 
mouse VARCHAR(100) NOT NULL,
carpet VARCHAR(100) NOT NULL,
keyboard VARCHAR(100) NOT NULL,
headphones VARCHAR(100) NOT NULL,
monitor VARCHAR(100) NOT NULL
);

CREATE TABLE if not exists configuration
(
id INT AUTO_INCREMENT PRIMARY KEY,
motherboard VARCHAR(100) NOT NULL,
coolering VARCHAR(100) NOT NULL,
CPU VARCHAR(100) NOT NULL,
RAM VARCHAR(100) NOT NULL,
SSD VARCHAR(100) NOT NULL,
graphics_card VARCHAR(100) NOT NULL,
power_unit VARCHAR(100) NOT NULL
);

CREATE TABLE if not exists gaming_place
(
id INT AUTO_INCREMENT PRIMARY KEY,
type VARCHAR(100) NOT NULL
);

CREATE TABLE if not exists PC
(
id INT AUTO_INCREMENT PRIMARY KEY,
is_functionable BOOL NOT NULL,
gaming_place_id INT UNIQUE,
FOREIGN KEY (gaming_place_id) REFERENCES gaming_place(id)
);

CREATE TABLE if not exists pc_configuration
(
pc_id INT UNIQUE,
configuration_id INT,
setting_date DATE,
is_being_used BOOL,
PRIMARY KEY (pc_id, configuration_id),
FOREIGN KEY (pc_id) REFERENCES PC(id),
FOREIGN KEY (configuration_id) REFERENCES configuration(id)
);

CREATE TABLE if not exists gaming_place_gadgets
(
place_id INT,
gadget_id INT UNIQUE,
setting_date DATE,
is_being_used BOOL,
PRIMARY KEY (place_id, gadget_id),
FOREIGN KEY (place_id) REFERENCES gaming_place(id),
FOREIGN KEY (gadget_id) REFERENCES gadgets(id)
);

CREATE TABLE if not exists gaming_place_furniture
(
gaming_place_id INT,
furniture_id INT UNIQUE,
setting_date DATE,
is_being_used BOOL,
PRIMARY KEY(gaming_place_id, furniture_id),
FOREIGN KEY (gaming_place_id) REFERENCES gaming_place(id),
FOREIGN KEY (furniture_id) REFERENCES furniture(id)
);

CREATE TABLE if not exists client_rents_gaming_place
(
client_id INT,
gaming_place_id INT UNIQUE,
session_start TIME,
session_end TIME,
PRIMARY KEY (client_id, gaming_place_id),
FOREIGN KEY (client_id) REFERENCES client(id),
FOREIGN KEY (gaming_place_id) REFERENCES gaming_place(id)
);

CREATE TABLE if not exists employee_maintains_gaming_place
(
employee_id INT,
gaming_place_id INT UNIQUE,
PRIMARY KEY(employee_id, gaming_place_id),
FOREIGN KEY (employee_id) REFERENCES employee(id),
FOREIGN KEY (gaming_place_id) REFERENCES gaming_place(id)
);