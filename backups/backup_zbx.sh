#!/bin/bash

# Variáveis
TELEGRAM_API_KEY="492230424:AAH70Sd-J1trfPiFrUbDrECVOEN-FzhORsY"
TELEGRAM_CHAT_ID="-506621348"
NOME=$(hostname -a)

# Diretórios de backup
SOURCE_DIRS=(
        "/usr/lib/zabbix/"
        "/etc/zabbix/"
)

BACKUP_DIR="/tmp"

# Nome do arquivo de backup
BACKUP_FILE="backup_${NOME}_$(date +"%Y%m%d%H%M%S").tar.gz"
PERMISSIONS_FILE="permissions_${NOME}_$(date +"%Y%m%d%H%M%S").txt"

# Cria um diretório temporário para armazenar os arquivos e permissões
TEMP_DIR=$(mktemp -d)

# Copia os arquivos para o diretório temporário, mantendo a estrutura de diretórios
for SOURCE_DIR in "${SOURCE_DIRS[@]}"; do
    DEST_DIR="$TEMP_DIR$(dirname "$SOURCE_DIR")"
    mkdir -p "$DEST_DIR"
    cp -a "$SOURCE_DIR" "$DEST_DIR"
done

# Coleta as permissões dos arquivos e salva em um arquivo de texto
find "$TEMP_DIR" -type f -exec stat -c "chmod %a %n" {} \; > "$TEMP_DIR/$PERMISSIONS_FILE"
sed -i "s|$TEMP_DIR||" "$TEMP_DIR/$PERMISSIONS_FILE"

# Compacta os arquivos e o arquivo de permissões
tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$TEMP_DIR" .

# Envia o arquivo para o Telegram
curl -F "chat_id=$TELEGRAM_CHAT_ID" \
     -F "document=@$BACKUP_DIR/$BACKUP_FILE" \
     "https://api.telegram.org/bot$TELEGRAM_API_KEY/sendDocument"

# Verifica se o envio foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Backup realizado e enviado para o Telegram com sucesso."
else
    echo "Erro ao enviar o backup para o Telegram."
fi

# Remove o diretório temporário
rm -rf "$TEMP_DIR"
rm -rf "$BACKUP_DIR/$BACKUP_FILE"
