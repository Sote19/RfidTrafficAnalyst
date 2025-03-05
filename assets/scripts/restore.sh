#!/bin/bash
# Script de recuperación de backups - Creado por Xavi y Gerard

# Asignamos variables
dest_dir="backup" # Directorio donde se encuentran los bkp
local_restore_dir="$HOME/Escritorio/restore" # Directorio donde restaurar los bkp
dest_server="xconde@100.77.20.40" # Dirección del servidor que contiene los bkp
log_file="$HOME/Escritorio/bkplog/restore.log" # Archivo log

# Si no existen, creamos los directorios
mkdir -p "$(dirname "$log_file")"
mkdir -p "$local_restore_dir"

# Listamos los ultimos 5 bkp's disponibles en el servidor
echo "[$(date)] Obteniendo lista de backups disponibles..." | tee -a "$log_file"
backups=($(ssh "$dest_server" "ls -t $dest_dir/backup_*.zip 2>/dev/null"))

#Output de errores
if [ ${#backups[@]} -eq 0 ]; then
  echo "[$(date)] ERROR: No se encontraron backups disponibles en el servidor." | tee -a "$log_file"
  exit 1
fi

# Mostrar los últimos 5 backups disponibles
echo "Los últimos backups disponibles son:" | tee -a "$log_file"
for i in ${!backups[@]}; do
  echo "$((i + 1)). ${backups[$i]}" | tee -a "$log_file"
  if [ $i -eq 4 ]; then
    break
  fi
done

# Solicitar al usuario que elija un backup
echo -n "Introduce el número del backup que deseas restaurar (1-5): "
read backup_choice

#Output de errores
if ! [[ "$backup_choice" =~ ^[1-5]$ ]] || [ "$backup_choice" -gt ${#backups[@]} ]; then
  echo "[$(date)] ERROR: Elección no válida." | tee -a "$log_file"
  exit 1
fi

# Comprobar el bkp seleccionado
selected_backup=${backups[$((backup_choice - 1))]}
echo "[$(date)] Has seleccionado restaurar: $selected_backup" | tee -a "$log_file"

# Descargar el bkp seleccionado
local_zip="$local_restore_dir/$(basename "$selected_backup")"
echo "[$(date)] Descargando el backup desde el servidor: $selected_backup" | tee -a "$log_file"
scp "$dest_server:$selected_backup" "$local_zip" >> "$log_file" 2>&1

#Output de errores
if [ ! -f "$local_zip" ]; then
  echo "[$(date)] ERROR: El archivo no se descargó correctamente." | tee -a "$log_file"
  exit 1
fi

# Imprimimos el resultado
echo "[$(date)] El backup $local_zip, ha sido restaurado exitosamente." | tee -a "$log_file"
echo "Podras encontrar el backup comprimido en: $local_restore_dir." | tee -a "$log_file"

