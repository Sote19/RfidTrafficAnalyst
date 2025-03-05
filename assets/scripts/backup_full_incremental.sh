#!/bin/bash

# Rutas locales
DIRECTORIO_ESCRITORIO="/home/usuario/Escritorio"
CARPETA_TEMPORAL="/tmp/backup_temp"
LOG_FILE="/var/log/backup.log"
ULTIMO_BACKUP="/tmp/ultimo_backup"
ARCHIVO_LISTA_BACKUP="$ULTIMO_BACKUP/lista_backup.txt"

# Datos del servidor de respaldo
SERVIDOR_RESPALDO="xconde@10.20.30.10"
RUTA_RESPALDO="/ruta/remota/de/respaldo"
PUERTO_SCP=22  # Si es necesario, puedes cambiar el puerto del SCP

# Crear la carpeta temporal si no existe
mkdir -p "$CARPETA_TEMPORAL"

# Función para registrar mensajes en el log
log_message() {
    FECHA=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$FECHA - $1" >> "$LOG_FILE"
}

# Si no existe un archivo de backup anterior, hacer un backup completo
if [ ! -f "$ARCHIVO_LISTA_BACKUP" ]; then
    log_message "No hay backup previo. Se hará un backup completo."

    # Copiar los archivos del escritorio a la carpeta temporal
    cp -r "$DIRECTORIO_ESCRITORIO/"* "$CARPETA_TEMPORAL"

    # Crear el archivo zip con los archivos actuales
    ZIP_NAME="backup_completo_$(date +%Y%m%d).zip"
    zip -r "$CARPETA_TEMPORAL/$ZIP_NAME" "$CARPETA_TEMPORAL/"*

    # Transferir el backup completo al servidor de respaldo
    scp -P "$PUERTO_SCP" "$CARPETA_TEMPORAL/$ZIP_NAME" "$SERVIDOR_RESPALDO:$RUTA_RESPALDO"

    # Guardar la lista de archivos respaldados con su fecha de modificación
    find "$DIRECTORIO_ESCRITORIO" -type f -exec stat --format="%n %Y" {} \; > "$ARCHIVO_LISTA_BACKUP"

    # Limpiar la carpeta temporal
    rm -r "$CARPETA_TEMPORAL/*"

else
    # Si hay un backup previo, se hace un backup incremental
    log_message "Iniciando backup incremental."

    # Crear una lista de archivos modificados
    archivos_modificados=()

    # Leer la lista de archivos respaldados en el último backup
    while IFS= read -r line; do
        # Obtener archivo y fecha del último backup
        archivo=$(echo "$line" | cut -d ' ' -f 1)
        fecha_backup=$(echo "$line" | cut -d ' ' -f 2)

        # Verificar si el archivo ha sido modificado comparando la fecha de modificación
        if [ -f "$DIRECTORIO_ESCRITORIO/$archivo" ]; then
            fecha_actual=$(stat --format="%Y" "$DIRECTORIO_ESCRITORIO/$archivo")

            # Si la fecha de modificación es diferente, agregar a la lista de archivos modificados
            if [ "$fecha_actual" -gt "$fecha_backup" ]; then
                archivos_modificados+=("$archivo")
            fi
        fi
    done < "$ARCHIVO_LISTA_BACKUP"

    if [ ${#archivos_modificados[@]} -gt 0 ]; then
        # Si hay archivos modificados, hacer el backup
        log_message "Se encontraron archivos modificados. Realizando backup."

        # Copiar los archivos modificados a la carpeta temporal
        for archivo in "${archivos_modificados[@]}"; do
            cp "$DIRECTORIO_ESCRITORIO/$archivo" "$CARPETA_TEMPORAL"
        done

        # Crear el archivo zip con los archivos modificados
        ZIP_NAME="backup_incremental_$(date +%Y%m%d).zip"
        zip -r "$CARPETA_TEMPORAL/$ZIP_NAME" "$CARPETA_TEMPORAL/"*

        # Transferir el backup incremental al servidor de respaldo
        scp -P "$PUERTO_SCP" "$CARPETA_TEMPORAL/$ZIP_NAME" "$SERVIDOR_RESPALDO:$RUTA_RESPALDO"

        # Guardar la nueva lista de archivos respaldados con su fecha de modificación
        find "$DIRECTORIO_ESCRITORIO" -type f -exec stat --format="%n %Y" {} \; > "$ARCHIVO_LISTA_BACKUP"

        # Limpiar la carpeta temporal
        rm -r "$CARPETA_TEMPORAL/*"
    else
        # Si no hubo archivos modificados
        log_message "No se encontraron archivos modificados. No se realizó ningún backup."
    fi
fi