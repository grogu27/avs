#!/bin/bash

# Получение информации о системе
linux=$(uname -a)
mem=$(free -h)
hdd=$(df -h)

# Получение информации о процессорах
cpu_info=""
cpu_count=$(lscpu | grep -E '^Socket\(s\):' | awk '{print $2}')
for (( i=0; i<cpu_count; i++ )); do
    cpu_name=$(lscpu | grep 'Model name' | sed -n "$((i + 1))p")
    cpu_clk_max=$(lscpu | grep 'CPU max MHz' | sed -n "$((i + 1))p")
    cpu_clk_min=$(lscpu | grep 'CPU min MHz' | sed -n "$((i + 1))p")
    core_count=$(lscpu | grep 'Core(s) per socket' | awk '{print $4}')
    thread_count=$(lscpu | grep 'Thread(s) per core' | awk '{print $4}')
    cache_info=$(lscpu | grep -E 'L1d|L1i|L2|L3')
    
    cpu_info+="Процессор $((i + 1)):\n"
    cpu_info+="  Имя: $cpu_name\n"
    cpu_info+="  Максимальная частота: $cpu_clk_max MHz\n"
    cpu_info+="  Минимальная частота: $cpu_clk_min MHz\n"
    cpu_info+="  Ядер на сокет: $core_count\n"
    cpu_info+="  Потоков на ядро: $thread_count\n"
    cpu_info+="  Кэш: $cache_info\n"
done

# Получение информации о сетевых интерфейсах, IP и MAC адресах
eth_info=""
for interface in $(ip -o link show | awk -F': ' '{print $2}'); do
    mac=$(ip link show $interface | awk '/ether|link\/ieee802/ {print $2}')
    ip_list=$(ip -o addr show $interface | awk '{print $4}' | tr '\n' ', ')
    ip_list=${ip_list%, }
    
    if [[ -n $mac ]]; then
        eth_info+="Интерфейс: $interface, IP: $ip_list, MAC: $mac\n"
    else
        eth_info+="Интерфейс: $interface, IP: $ip_list, MAC: Неизвестно\n"
    fi
done

# Получение скорости сетевых интерфейсов
speed_info=""
for interface in $(ip link show | grep 'state UP' | awk '{print $2}' | sed 's/://g'); do
    speed=$(ethtool $interface 2>/dev/null | grep -i speed)
    if [[ -n $speed ]]; then
        speed_info+="$interface: $speed\n"
    else
        speed_info+="$interface: Не удалось получить данные о скорости\n"
    fi
done

# Вывод информации
echo -e "Информация о системе: \n$linux"
echo "--------------------------------------------------------"
echo -e "Информация о процессорах:\n$cpu_info"
echo "--------------------------------------------------------"
echo -e "Информация о оперативной памяти: \n$mem"
echo "--------------------------------------------------------"
echo -e "Информация о сетевых интерфейсах: \n$eth_info"
echo "--------------------------------------------------------"
echo -e "Информация о скорости сетевых интерфейсов:\n$speed_info"
echo "--------------------------------------------------------"
echo -e "Информация о дисках: \n$hdd"
echo "--------------------------------------------------------"
