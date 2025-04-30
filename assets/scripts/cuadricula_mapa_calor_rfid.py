import matplotlib.pyplot as plt
import numpy as np

# Simulamos una feria de 2x2 antenas
# Cada número representa la cantidad de señales detectadas
cantidad_senales = np.array([
    [0, 3],
    [7, 15]
])

# Función para asignar color según cantidad de señales
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

# Pintamos la cuadrícula
fig, ax = plt.subplots()
ax.imshow(colores, extent=[0,2,0,2])

# Dibujamos cuadrícula encima
ax.set_xticks(np.arange(0, 2, 1))
ax.set_yticks(np.arange(0, 2, 1))
ax.grid(color='black', linestyle='-', linewidth=2)

# Añadimos los valores de las señales
for i in range(cantidad_senales.shape[0]):
    for j in range(cantidad_senales.shape[1]):
        ax.text(j + 0.5, 1.5 - i, str(cantidad_senales[i,j]),
                ha='center', va='center', fontsize=12, color='black')

ax.set_title('Mapa de calor - Antenas RFID')
plt.show()
