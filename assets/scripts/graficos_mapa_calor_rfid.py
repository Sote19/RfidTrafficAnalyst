import matplotlib.pyplot as plt
import pandas as pd

# Simulamos datos de antenas
datos = {
    'Antena': ['A1', 'A2', 'A3', 'A4'],
    'Cantidad_Senales': [0, 3, 7, 15]
}

df = pd.DataFrame(datos)

# Función para asignar color según cantidad
def color_segun_afluencia(cantidad):
    if cantidad == 0:
        return '#FFFFFF'  # Blanco
    elif 1 <= cantidad <= 5:
        return '#00FF00'  # Verde
    elif 6 <= cantidad <= 10:
        return '#FFA500'  # Naranja
    else:
        return '#FF0000'  # Rojo

# Asignar colores
df['Color'] = df['Cantidad_Senales'].apply(color_segun_afluencia)

# Crear un gráfico de barras colorido para simular el mapa de calor
plt.figure(figsize=(8,4))
bars = plt.bar(df['Antena'], df['Cantidad_Senales'], color=df['Color'])

plt.title('Mapa de calor de Antenas - Afluencia de personas')
plt.xlabel('Antenas')
plt.ylabel('Cantidad de Señales')
plt.grid(axis='y')

plt.show()
