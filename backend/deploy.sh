#!/bin/bash
set +e
cat > .env-backend <<EOF
PSQL_DATASOURCE=${PSQL_DATASOURCE}
PSQL_USER=${PSQL_USER}
PSQL_PASSWORD=${PSQL_PASSWORD}
EOF
# начальные данные
blueContainerName="backend-blue"
greenContainerName="backend-green"
remoteContextName="remote"
# Проверьте, какой контейнер запущен сейчас (blue или green?). Допустим, запущен blue.
workingContainer=''
containerToUpdate=''
if docker ps | grep $blueContainerName
then
    workingContainer=$blueContainerName
    containerToUpdate=$greenContainerName
else
    workingContainer=$greenContainerName
    containerToUpdate=$blueContainerName
fi

if [ "$workingContainer" = "" ]
then
    echo "working container not set"
    exit 1
fi

# Если есть запущенные green контейнеры, остановите их.
echo "container to update: $containerToUpdate"
docker compose stop $containerToUpdate
# Скачайте новую версию образа бэкенда и запустите обновлённый green контейнер.
docker compose --env-file ./.env-backend up $containerToUpdate -d --pull "always" --force-recreate

# Дождитесь статуса healthy у нового контейнера.
if [[ $(docker inspect -f '{{.State.Running}}' $containerToUpdate) = false ]]
then
    # Остановите blue контейнер.
    docker compose stop $workingContainer
    docker compose stop up $workingContainer --pull "always"
fi

