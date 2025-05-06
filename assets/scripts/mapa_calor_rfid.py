import mysql.connector
import matplotlib.pyplot as plt
import numpy as np
import time

# 🧠 IDs manuales de antenas en posiciones fijas (2 antenas)
matriz_ids = np.array([[1, 2]])

# 🖼️ Activar modo interactivo
plt.ion()
fig, ax = plt.subplots(figsize=(6, 3))

def color_por_cantidad(cantidad):
    if cantidad <= 1:
        return (0, 1, 0)     # Verde
    elif cantidad == 2:
        return (1, 0.65, 0)  # Naranja
    else:
        return (1, 0, 0)     # Rojo

def actualizar_mapa():
    # 🔄 Conectar, consultar y cerrar por cada ciclo para asegurar actualización en tiempo real
    try:
        conexion = mysql.connector.connect(
            host="10.20.30.15",
            user="admin",
            password="Mangorfid",
            database="rfid"
        )
        cursor = conexion.cursor()

        cursor.execute("""
            SELECT id_antena, COUNT(*) AS cantidad
            FROM rfid_senales
            WHERE estado = 'activo'
            GROUP BY id_antena
        """)
        resultados = cursor.fetchall()

        datos_antenas = {id_antena: cantidad for id_antena, cantidad in resultados}

        # Preparar matrices de cantidad y color
        cantidad_senales = np.zeros(matriz_ids.shape)
        colores = np.empty(matriz_ids.shape + (3,))

        for i in range(matriz_ids.shape[0]):
            for j in range(matriz_ids.shape[1]):
                id_antena = matriz_ids[i, j]
                cantidad = datos_antenas.get(id_antena, 0)
                cantidad_senales[i, j] = cantidad
                colores[i, j] = color_por_cantidad(cantidad)

        # 🧼 Limpiar y redibujar gráfico
        ax.clear()
        ax.imshow(colores, extent=[0, 2, 0, 1])
        ax.set_xticks([0.5, 1.5])
        ax.set_xticklabels([f'Antena {id}' for id in matriz_ids[0]])
        ax.set_yticks([])
        ax.grid(color='black', linestyle='-', linewidth=2)

        for j in range(matriz_ids.shape[1]):
            ax.text(j + 0.5, 0.5, int(cantidad_senales[0, j]),
                    ha='center', va='center', fontsize=14, color='black')

        ax.set_title('Mapa de Calor RFID - Señales Activas')
        plt.draw()
        plt.pause(0.001)

    except mysql.connector.Error as e:
        print("❌ Error al consultar la base de datos:", e)
    finally:
        try:
            cursor.close()
            conexion.close()
        except:
            pass

# 🔁 Loop con actualización cada 2 segundos
try:
    while True:
        actualizar_mapa()
        time.sleep(2)
except KeyboardInterrupt:
    print("⛔ Programa interrumpido por el usuario.")
finally:
    plt.ioff()
    plt.close()
