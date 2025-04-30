# -------------------------------Importación de librerías-------------------------------

import serial # pip install pyserial
import pymysql # pip install pymysql
import json
from datetime import datetime
import time

# -------------------------------Configuración conexión Arduino y Base de Datos-------------------------------

puerto_serie = serial.Serial('COM4', 9600, timeout=1) # Puede varíar el COM4.
time.sleep(2)  # Tiempo de espera para que se estabilice el puerto.

conexion = pymysql.connect(host="100.77.20.77", user="root", password="Mangorfid", database="rfid")
cursor = conexion.cursor()

# -------------------------------Diccionario para rastrear la última vez que se detectó cada tarjeta-------------------------------

tarjetas_detectadas = {} # La clave es el UID y el valor es el último datetime en que se detectó.
TIEMPO_DESAPARICION = 5  # Tiempo de inactividad.

# -------------------------------Funciones-------------------------------

def registrar_entrada(uid, id_antena=1):
    tiempo_actual = datetime.now()
    # Buscar si la tarjeta ya está activa en la misma antena
    cursor.execute("""
        SELECT tiempo_entrada, estado FROM rfid_senales 
        WHERE rfid_tag = %s AND id_antena = %s AND estado = 'activo'
        ORDER BY tiempo_entrada DESC LIMIT 1
    """, (uid, id_antena))
    resultado = cursor.fetchone()

    if not resultado:
        # Insertar nuevo registro con tiempo_total=0
        cursor.execute("""
            INSERT INTO rfid_senales (rfid_tag, id_antena, tiempo_entrada, estado, tiempo_total)
            VALUES (%s, %s, %s, 'activo', 0)
        """, (uid, id_antena, tiempo_actual))
        conexion.commit()
        tarjetas_detectadas[uid] = tiempo_actual
        print(f"Entrada UID {uid} en antena {id_antena}")

def registrar_salida(uid, id_antena=1):
    tiempo_actual = datetime.now()
    # Obtener el registro activo de esta etiqueta
    cursor.execute("""
        SELECT tiempo_entrada, tiempo_total FROM rfid_senales 
        WHERE rfid_tag = %s AND id_antena = %s AND estado = 'activo'
        ORDER BY tiempo_entrada DESC LIMIT 1
    """, (uid, id_antena))
    resultado = cursor.fetchone()

    if resultado:
        tiempo_entrada, tiempo_total_actual = resultado
        if isinstance(tiempo_entrada, str):
            formato = "%Y-%m-%d %H:%M:%S"
            tiempo_inicio = datetime.strptime(tiempo_entrada, formato)
        else:
            tiempo_inicio = tiempo_entrada

        incremento = int((tiempo_actual - tiempo_inicio).total_seconds()) - 5  # Restamos los 5s de margen

        cursor.execute("""
            UPDATE rfid_senales 
            SET tiempo_salida = %s, 
                tiempo_total = IFNULL(tiempo_total, 0) + %s, 
                estado = 'inactivo'
            WHERE rfid_tag = %s AND id_antena = %s AND estado = 'activo'
        """, (tiempo_actual, incremento, uid, id_antena))
        conexion.commit()

        print(f"Salida UID {uid} en antena {id_antena}, tiempo incrementado (ajustado): {incremento} segundos")

        if uid in tarjetas_detectadas:
            del tarjetas_detectadas[uid]
    else:
        print(f"No se encontró registro activo para UID {uid} en antena {id_antena}")

# -------------------------------Inicio del programa-------------------------------

print("Esperando datos del Arduino...")

while True:
    try:
        if puerto_serie.in_waiting > 0:
            linea = puerto_serie.readline().decode('utf-8').strip()
            if linea.startswith("{") and linea.endswith("}"):
                try:
                    datos = json.loads(linea)
                    uid = datos.get("UID")
                    if uid:
                        # Si el UID no está siendo rastreado, registrar entrada
                        if uid not in tarjetas_detectadas:
                            registrar_entrada(uid, 1)  # Suponiendo que id_antena es 1
                        else:
                            # Actualiza la última detección para mantenerlo activo
                            tarjetas_detectadas[uid] = datetime.now()
                            print(f"UID {uid} sigue presente")
                except json.JSONDecodeError:
                    print("Error al decodificar JSON")
    except Exception as e:
        print("Error en lectura serial:", e)
    
    # Comprobar cada segundo si alguna etiqueta ha dejado de detectarse durante más de 5 segundos
    ahora = datetime.now()
    uids_para_salir = []
    for uid, ultimo in tarjetas_detectadas.items():
        if (ahora - ultimo).total_seconds() > TIEMPO_DESAPARICION:
            uids_para_salir.append(uid)
    for uid in uids_para_salir:
        registrar_salida(uid, 1)