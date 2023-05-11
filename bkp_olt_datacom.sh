#!/bin/bash

# Define as variáveis necessárias
OLT_IP="IP"
OLT_USER="USERDAOLT"
OLT_PASSWORD="SENHADAOLT"
BACKUP_FILE="backup_$(date +%Y-%m-%d_%H-%M-%S).txt"
LOCAL_PATH="/tmp"
CHATID="CHATIDTELEGRAM"
TOKEN="TOKEMTELEGRAM"

# Conecta na OLT via SSH e cria o arquivo de backup
sshpass -p "$OLT_PASSWORD" ssh "$OLT_USER@$OLT_IP" "save $BACKUP_FILE"

# Salva a configuração atual no arquivo de backup
sshpass -p "$OLT_PASSWORD" ssh "$OLT_USER@$OLT_IP" "show running-config | save $BACKUP_FILE"

# Exibe o conteúdo do arquivo de backup e salva o retorno em um arquivo de texto
sshpass -p "$OLT_PASSWORD" ssh "$OLT_USER@$OLT_IP" "file show $BACKUP_FILE" > "$LOCAL_PATH/$BACKUP_FILE"

# Apaga o arquivo de backup dentro da olt para evitar consumo de espaço
sshpass -p "$OLT_PASSWORD" ssh "$OLT_USER@$OLT_IP" "file delete $BACKUP_FILE"
# Exibe uma mensagem de que o arquivo foi apagado
echo "Arquivo $BACKUP_FILE foi apagado da olt"

# Compacta o arquivo de backup e armazena na variável ARQ_BKP
if [ "$COMPAC" = "zip" ]; then
  zip -r "$LOCAL_PATH/$BACKUP_FILE.zip" "$LOCAL_PATH/$BACKUP_FILE"
  ARQ_BKP="$BACKUP_FILE.zip"
else
  tar -zcvf "$LOCAL_PATH/$BACKUP_FILE.tar.gz" "$LOCAL_PATH/$BACKUP_FILE"
  ARQ_BKP="$BACKUP_FILE.tar.gz"
fi
# Exibe uma mensagem de que o arquivo foi compactado
echo "Arquivo $ARQ_BKP compactado"

# Envia o backup baixado para o Telegram
curl -F document=@"$LOCAL_PATH/$ARQ_BKP" -F caption="$MSG" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHATID" &>/dev/null
echo "Arquivo enviado para o Telegram"

# Remove os arquivos temporarios

sleep 02
rm -rf "$LOCAL_PATH/$ARQ_BKP"
rm -rf "$LOCAL_PATH/$BACKUP_FILE"

echo "Arquivos temporarios removidos"
