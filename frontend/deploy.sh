#!/bin/bash
set +e
docker network create -d bridge sausage_network || true
docker pull gitlab.praktikum-services.ru:5050/std-016-032/sausage-store/sausage-frontend:latest
docker stop frontend || true
docker rm frontend || true
set -e
docker run -d --name frontend \
    --network=sausage_network \
    --restart always \
    --pull always \
    -p 80:80 \
    gitlab.praktikum-services.ru:5050/std-016-032/sausage-store/sausage-frontend:latest