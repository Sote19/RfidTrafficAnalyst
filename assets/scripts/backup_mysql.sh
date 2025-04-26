#!/bin/bash
# Script by RFIDTrafficAnalyst
# Backup de MySQL

# ------------------ Configuración ------------------
container_name="MySQL"
database_name="rfid"
backup_date=$(date +%Y-%m-%d_%H%M)
local_tmp="/tmp/mysql_backup"
log_file="$HOME/bkplog/backup.log"

# Remoto (LXC)
remote_user="rfidbackup"
remote_host="10.20.30.16"
remote_dir="/mnt/backups/mysql"

# ------------------ Preparativos ------------------
mkdir -p "$local_tmp"
mkdir -p "$(dirname "$log_file")"

backup_sql="$local_tmp/backup_${database_name}_${backup_date}.sql"
backup_tar="${backup_sql}.tar.gz"

# ------------------ Backup ------------------
echo "[$(date)] Iniciando backup..." >> "$log_file"

docker exec "$container_name" mysqldump -u root --password=Mangorfid "$database_name" > "$backup_sql"
if [[ $? -ne 0 ]]; then
	echo "[$(date)] Error al hacer mysqldump" >> "$log_file"
	exit 1
fi

# Crear archivo tar.gz
tar -czf "$backup_tar" -C "$local_tmp" "$(basename "$backup_sql")" >> "$log_file" 2>&1
backup_size=$(du -h "$backup_tar" | cut -f1)

echo "[$(date)] Backup generado: $backup_tar ($backup_size)" >> "$log_file"

# ------------------ Transferencia ------------------
ssh "${remote_user}@${remote_host}" "mkdir -p ${remote_dir}"
scp "$backup_tar" "${remote_user}@${remote_host}:${remote_dir}/" >> "$log_file" 2>&1

# ------------------ Mantener solo los 4 últimos ------------------
ssh "${remote_user}@${remote_host}" "ls -tp ${remote_dir}/backup_*.tar.gz | grep -v '/$' | tail -n +5 | xargs -r rm --"

echo "[$(date)] Backup transferido y backups antiguos limpiados" >> "$log_file"

# ------------------ Limpieza local ------------------
rm -f "$backup_sql" "$backup_tar"

echo "[$(date)] Limpieza completada. Backup terminado correctamente." >> "$log_file"
