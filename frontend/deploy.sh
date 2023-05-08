#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
sudo rm -f /var/www-data/dist/sausage-store.tar.gz||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.tar.gz ${NEXUS_REPO_ARTIFACT_URL}
sudo cp ./sausage-store.tar.gz /var/www-data/dist/sausage-store.tar.gz #||true
sudo tar -zxvf /var/www-data/dist/sausage-store.tar.gz -C /var/www-data/dist/
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-frontend 