#!/bin/bash

# Название контейнера
CONTAINER_NAME="isolation_test"

# Запуск контейнера в фоновом режиме с bash и дополнительными привязками для тестирования
docker run -d --name $CONTAINER_NAME --rm --hostname test-container ubuntu sleep 600

# Проверка PID изоляции
echo "=== PID Namespace Isolation ==="
docker exec $CONTAINER_NAME ps aux

# Проверка изоляции сети
echo "=== Network Namespace Isolation ==="
docker exec $CONTAINER_NAME ifconfig

# Проверка изоляции IPC
echo "=== IPC Namespace Isolation ==="
docker exec $CONTAINER_NAME ipcs -q
docker exec $CONTAINER_NAME ipcs -s
docker exec $CONTAINER_NAME ipcs -m

# Проверка файловой системы (Mount namespace)
echo "=== Mount Namespace Isolation ==="
docker exec $CONTAINER_NAME ls /

# Проверка UTS изоляции (hostname)
echo "=== UTS Namespace Isolation (Hostname) ==="
docker exec $CONTAINER_NAME hostname
docker exec $CONTAINER_NAME hostname new-container
docker exec $CONTAINER_NAME hostname

# Проверка изоляции пользователей (User namespace)
echo "=== User Namespace Isolation ==="
docker exec $CONTAINER_NAME id

# Остановка контейнера
docker stop $CONTAINER_NAME

echo "Isolation checks completed!"
#!/bin/bash

# Название контейнера и образа
CONTAINER_NAME="isolation_test"
IMAGE_NAME="isolation_image"

# Шаг 1: Создание Dockerfile
# Вы можете создать Dockerfile через скрипт, если его нет в каталоге
cat <<EOF > Dockerfile
FROM ubuntu

# Установить net-tools для доступа к ifconfig
RUN apt update && apt install -y net-tools iproute2

CMD ["sleep", "600"]
EOF

# Шаг 2: Сборка Docker-образа из Dockerfile
echo "Building Docker image..."
docker build -t $IMAGE_NAME .

# Шаг 3: Запуск контейнера с именем $CONTAINER_NAME
echo "Running Docker container..."
docker run -d --name $CONTAINER_NAME --rm --hostname test-container $IMAGE_NAME

# Проверка PID изоляции
echo "=== PID Namespace Isolation ==="
docker exec $CONTAINER_NAME ps aux

# Проверка сетевой изоляции (установлен ifconfig)
echo "=== Network Namespace Isolation ==="
docker exec $CONTAINER_NAME ifconfig

# Проверка IPC изоляции
echo "=== IPC Namespace Isolation ==="
docker exec $CONTAINER_NAME ipcs -q
docker exec $CONTAINER_NAME ipcs -s
docker exec $CONTAINER_NAME ipcs -m

# Проверка файловой системы (Mount namespace)
echo "=== Mount Namespace Isolation ==="
docker exec $CONTAINER_NAME ls /

# Проверка UTS изоляции (hostname)
echo "=== UTS Namespace Isolation (Hostname) ==="
docker exec $CONTAINER_NAME hostname
docker exec $CONTAINER_NAME hostname new-container
docker exec $CONTAINER_NAME hostname

# Проверка изоляции пользователей (User namespace)
echo "=== User Namespace Isolation ==="
docker exec $CONTAINER_NAME id

# Остановка контейнера
docker stop $CONTAINER_NAME

echo "Isolation checks completed!"