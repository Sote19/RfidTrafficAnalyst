#!/bin/bash
# Script de backup de MySQL con compresión ZIP y transferencia remota

# Configuración de variables
dest_dir="backup"  # Directorio de destino en la máquina remota
dest_server="xconde@100.77.20.40"  # Servidor de respaldo
backup_date=$(date +%Y-%m-%d_%H%M)  # Fecha del backup
log_file="$HOME/bkplog/bkp.log"  # Archivo log

# Credenciales de MySQL (el usuario y contraseña están en ~/.my.cnf)
database_name="testdb"

# Comprobaciones
if [[ -z "$dest_dir" || -z "$dest_server" ]]; then
  echo "[$(date)] ERROR: Faltan datos en la configuración." | tee -a "$log_file"
  exit 1
fi

mkdir -p "$(dirname "$log_file")"  # Crear carpeta de logs si no existe
mkdir -p "/tmp/backup_temp"

# Backup de la base de datos
mysql_backup="/tmp/backup_mysql_${backup_date}.sql"
echo "[$(date)] Realizando backup de la base de datos MySQL..." | tee -a "$log_file"
mysqldump --defaults-extra-file=~/.my.cnf --databases "$database_name" > "$mysql_backup"

if [ $? -eq 0 ]; then
  echo "[$(date)] Backup de MySQL completado." | tee -a "$log_file"
else
  echo "[$(date)] ERROR al hacer backup de MySQL." | tee -a "$log_file"
  exit 1
fi

# Comprimir en ZIP
zip_file="/tmp/backup_${backup_date}.zip"
echo "[$(date)] Creando archivo ZIP: $zip_file" | tee -a "$log_file"
zip -r "$zip_file" "$mysql_backup" >> "$log_file" 2>&1

# Transferir al servidor
ssh "$dest_server" "mkdir -p $dest_dir"
scp "$zip_file" "$dest_server:$dest_dir/backup_${backup_date}.zip" >> "$log_file" 2>&1
ssh "$dest_server" "ls -t $dest_dir/backup_*.zip | tail -n +6 | xargs rm -f"

# Generar hash SHA-256
echo "[$(date)] Generando hash SHA-256 del backup" | tee -a "$log_file"
sha256sum "$zip_file" | tee -a "$log_file"

# Limpiar archivos temporales
rm -f "$zip_file" "$mysql_backup"

echo "[$(date)] Backup finalizado correctamente." | tee -a "$log_file"
