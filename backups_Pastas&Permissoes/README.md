### Criar pasta e baixando arquivo
```
# mkdir /etc/backup
# cd /etc/backup
# wget https://raw.githubusercontent.com/joandson19/Script-Backups/main/backups_Pastas%26Permissoes/backup.sh -O backup.sh
# chmod +x backup.sh
```
### Edite o TOKEN, ID e adicione as pastas que deseja fazer o backup
```
# nano backup.sh
```
![image](https://github.com/joandson19/Script-Backups/assets/36518985/627691c6-9064-494d-9f6d-8e3c3e9f85e8)
### Após, execute!
```
# ./backup.sh
```

### Agora é só altomatizar na cron
```
# crontab -e
00 20  * * *  /etc/backup/backup.sh &>/dev/null
```
