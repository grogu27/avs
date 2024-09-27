#!/bin/bash

cpu_name=$(lscpu | grep 'Model name')
cpu_clk_max=$(lscpu | grep 'CPU max MHz')
cpu_clk_min=$(lscpu | grep 'CPU min MHz')
Core=$(lscpu | grep 'Core(s) per socket')
Thread=$(lscpu | grep 'Thread(s) per core')
#cache=$(cat /proc/cpuinfo | grep -i 'cache')
Cache=$(lscpu | grep -E 'L1d|L1i|L2|L3')
Sockets=$(lscpu | grep 'Socket(s)')
mem=$(free -h)
hdd=$(df -h)
linux=$(uname -a)
#eth_details=$(ip addr show)
#eth=$(ip -o addr show | awk '{print $2, $4, $6}' | sort | uniq)
speed_eth=$(ethtool eth1 | grep -i speed)
#eth_details=$(ip addr show)


# Получение информации о сетевых интерфейсах, IP и MAC адресах
eth_info=""
eth_info=""
for interface in $(ip -o link show | awk -F': ' '{print $2}'); do
    # Получение MAC адреса
    mac=$(ip link show $interface | awk '/ether|link\/ieee802/ {print $2}')
    
    # Получение всех IP адресов
    ip_list=$(ip -o addr show $interface | awk '{print $4}' | tr '\n' ', ')
    
    # Убираем последний символ ", " если он есть
    ip_list=${ip_list%, }
    
    # Проверяем, есть ли MAC адрес
    if [[ -n $mac ]]; then
        eth_info+="Интерфейс: $interface, IP: $ip_list, MAC: $mac\n"
    else
        eth_info+="Интерфейс: $interface, IP: $ip_list, MAC: Неизвестно\n"
    fi
done


speed_info=""
for interface in $(ip link show | grep 'state UP' | awk '{print $2}' | sed 's/://g'); do
    echo "Интерфейс: $interface"
    speed=$(ethtool $interface 2>/dev/null | grep -i speed)
    if [[ -n $speed ]]; then
        speed_info+="$interface: $speed\n"
    else
        speed_info+="$interface: Не удалось получить данные о скорости\n"
    fi
done

echo -e "Информация  о системе: \n$linux"
echo "--------------------------------------------------------"
echo -e "Информация  о процессоре: \n$cpu_name\n$cpu_clk_max\n$cpu_clk_min\n$Sockets\n$Core\n$Thread\n$Cache"
echo "--------------------------------------------------------"
echo -e "Информация  о оперативной памяти: \n$mem"
echo "--------------------------------------------------------"
echo -e "Информация  о сетевых интерфейсах: \n$eth_info"
echo "--------------------------------------------------------"
echo -e "ИнфИнформация а о скорости сетевого интерфейса eth0: \n$speed_info"
echo "--------------------------------------------------------"
echo -e "Информация  о дисках: \n$hdd"
echo "--------------------------------------------------------"



