# Requisitos para instalar estão logo abaixo

* apt install sshpass curl -y

Agora é só criar o script usando o nano ou vi e alterar as variaveis dentro dele, salvar e aplicar as permissões.

* chmod +x "/CAMINHO/SCRIPT"

Agora é só executar o script

* /CAMINHO/SCRIPT ou ./CAMINHO/SCRIPT

# Caso queira automatizar, vou deixar abaixo um exemplo que roda esse script todos os dias as 20 horas

* crontab -e
* 00 20 * * *     /CAMINHO/SCRIPT &>/dev/null

Agora é só esperar o horário e ser feliz com os backups diarios chegando.
