import mysql.connector
import matplotlib.pyplot as plt
import numpy as np

# 📌 1. Conectar a tu base de datos
conexion = mysql.connector.connect(
    host="localhost",
    user="admin",
    password="Mangorfid",
    database="rfid"
)

cursor = conexion.cursor()

# 📌 2. Consultar cantidad de señales por antena
consulta = """
SELECT id_antena, COUNT(*) AS cantidad
FROM rfid_senales
GROUP BY id_antena
"""
cursor.execute(consulta)

# 📌 3. Procesar datos
resultados = cursor.fetchall()

# Convertir resultados a un diccionario {id_antena: cantidad}
datos_antenas = {id_antena: cantidad for id_antena, cantidad in resultados}

# 🧠 Imagina que tienes antenas en una cuadrícula 2x2 (puedes adaptarlo)
# Vamos a mapear las antenas manualmente a posiciones
# Ejemplo: id_antena 1 arriba izquierda, id_antena 2 arriba derecha, etc.
matriz_ids = np.array([
    [1, 2],
    [3, 4]
])

# Crear matriz de cantidades
cantidad_senales = np.zeros(matriz_ids.shape)

for i in range(matriz_ids.shape[0]):
    for j in range(matriz_ids.shape[1]):
        id_antena = matriz_ids[i, j]
        cantidad_senales[i, j] = datos_antenas.get(id_antena, 0)

# 📌 4. Definir función de colores
def color_segun_afluencia(cantidad):
    if cantidad == 0:
        return (1,1,1)  # Blanco
    elif 1 <= cantidad <= 5:
        return (0,1,0)  # Verde
    elif 6 <= cantidad <= 10:
        return (1,0.65,0)  # Naranja
    else:
        return (1,0,0)  # Rojo

# Crear matriz de colores
colores = np.empty(cantidad_senales.shape + (3,))
for i in range(cantidad_senales.shape[0]):
    for j in range(cantidad_senales.shape[1]):
        colores[i,j] = color_segun_afluencia(cantidad_senales[i,j])

# 📌 5. Pintar mapa de calor
fig, ax = plt.subplots()
ax.imshow(colores, extent=[0,2,0,2])

ax.set_xticks(np.arange(0, 2, 1))
ax.set_yticks(np.arange(0, 2, 1))
ax.grid(color='black', linestyle='-', linewidth=2)

# Escribir cantidad de señales en cada celda
for i in range(cantidad_senales.shape[0]):
    for j in range(cantidad_senales.shape[1]):
        ax.text(j + 0.5, 1.5 - i, int(cantidad_senales[i,j]),
                ha='center', va='center', fontsize=12, color='black')

ax.set_title('Mapa de calor de antenas RFID - Señales detectadas')
plt.show()

# 📌 6. Cerrar conexión
cursor.close()
conexion.close()