#!/bin/bash
#curl http://localhost:8080
# Название контейнера
CONTAINER_NAME="nginx_container"
#CONTAINER_NAME2="lab2"
#export DOCKER_HOST="tcp://127.0.0.1:2376"
#docker logs -f nginx_container
# Запуск контейнера в фоновом режиме с bash и дополнительными привязками для тестирования
#docker run -d --name $CONTAINER_NAME --rm --hostname test-container ubuntu sleep 600
#docker run -d --name nginx_container -p 8080:80 nginx
#docker run --name nginx_container nginx /bin/sh
#docker exec -it nginx_container /bin/sh
# Проверка PID изоляции
echo "=== PID Namespace Isolation ==="
docker exec $CONTAINER_NAME ps aux

# Проверка изоляции сети
echo "=== Network Namespace Isolation ==="
docker exec $CONTAINER_NAME ip addr show

# Проверка изоляции IPC
echo "=== IPC Namespace Isolation ==="
docker exec $CONTAINER_NAME ipcs -q
docker exec $CONTAINER_NAME ipcs -s
docker exec $CONTAINER_NAME ipcs -m

# Проверка файловой системы (Mount namespace)
echo "=== Mount Namespace Isolation ==="
docker exec $CONTAINER_NAME2 ls /

# Проверка UTS изоляции (hostname)
echo "=== UTS Namespace Isolation (Hostname) ==="
docker exec $CONTAINER_NAME hostname
#docker exec $CONTAINER_NAME hostname new-container
#docker exec $CONTAINER_NAME hostname

# Проверка изоляции пользователей (User namespace)
echo "=== User Namespace Isolation ==="
docker exec $CONTAINER_NAME id
docker exec $CONTAINER_NAME whoami

# Остановка контейнера
#docker stop $CONTAINER_NAME
