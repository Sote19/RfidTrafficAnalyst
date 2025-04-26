-- 📌 Creación de la base de datos
CREATE DATABASE IF NOT EXISTS rfid;
USE rfid;

-- 📌 Tabla de planes (para definir diferentes accesos a las empresas)
CREATE TABLE IF NOT EXISTS planes (
	id_plan INT AUTO_INCREMENT PRIMARY KEY,
	nombre_plan VARCHAR(50) NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	descripcion TEXT NOT NULL
);

-- 📌 Insertar planes básicos
INSERT INTO planes (nombre_plan, precio, descripcion) VALUES
('basico', 9.99, 'Acceso básico con funcionalidades esenciales'),
('medio', 19.99, 'Acceso intermedio con características avanzadas'),
('pro', 29.99, 'Acceso profesional con todas las funcionalidades');

-- 📌 Tabla de empresas (clientes que contratan el servicio)
CREATE TABLE IF NOT EXISTS empresas (
	id_empresa INT AUTO_INCREMENT PRIMARY KEY,
	nombre_empresa VARCHAR(100) NOT NULL,
	email_empresa VARCHAR(100) NOT NULL UNIQUE,
	contraseña_empresa VARCHAR(255) NOT NULL,
	id_plan INT DEFAULT 1,
	FOREIGN KEY (id_plan) REFERENCES planes(id_plan)
);

-- 📌 Insertar empresa por defecto "RFIDTrafficAnalyst"
INSERT INTO empresas (nombre_empresa, email_empresa, contraseña_empresa, id_plan)
VALUES ('RFIDTrafficAnalyst', 'admin@rfidtraffic.com', 'admin123', 3)
ON DUPLICATE KEY UPDATE nombre_empresa = nombre_empresa;

-- 📌 Tabla de antenas (dispositivos que leen los RFID en la feria)
CREATE TABLE IF NOT EXISTS antenas (
	id_antena INT AUTO_INCREMENT PRIMARY KEY,
	id_empresa INT NOT NULL,
	ubicacion VARCHAR(100) NOT NULL,
	FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

-- 📌 Insertar antena por defecto "Arduino" para RFIDTrafficAnalyst
INSERT INTO antenas (id_empresa, ubicacion)
VALUES ((SELECT id_empresa FROM empresas WHERE nombre_empresa = 'RFIDTrafficAnalyst' LIMIT 1), 'Arduino')
ON DUPLICATE KEY UPDATE ubicacion = ubicacion;

-- 📌 Tabla de señales RFID (registro de lectura de tarjetas)
CREATE TABLE IF NOT EXISTS rfid_senales (
	id_senal INT AUTO_INCREMENT PRIMARY KEY,
	rfid_tag VARCHAR(100) NOT NULL, -- 📌 Identificador único de cada tarjeta RFID
	id_antena INT NOT NULL, -- 📌 Ubicación donde se detectó
	tiempo_entrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 📌 Hora de detección
	tiempo_salida DATETIME NULL, -- 📌 Hora de salida (se actualiza cuando desaparece)
	tiempo_total INT DEFAULT 0, -- 📌 Tiempo total en segundos (se acumula si vuelve)
	estado ENUM('activo', 'inactivo') DEFAULT 'activo', -- 📌 Si la persona sigue o se ha ido
	FOREIGN KEY (id_antena) REFERENCES antenas(id_antena)
);

-- 📌 Crear un índice para optimizar las consultas
CREATE INDEX idx_rfid ON rfid_senales (rfid_tag);

