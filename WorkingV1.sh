#!/bin/bash

#Banner

echo ""
echo -e "\e[33m           _ __           __         ® \e[0m"
echo -e "\e[33m _      __(_) /___ ______/ /____  __\e[0m"
echo -e "\e[33m| | /| / / / / __ \`/___/  //_/ / / /\e[0m"
echo -e "\e[33m| |/ |/ / / / /_/ (__  ) ,< / /_/ / \e[0m"
echo -e "\e[33m|__/|__/_/_/\__,_/____/_/|_|\__, /  \e[0m"
echo -e "\e[33m                           /____/   \e[0m"

echo ""
echo ""
echo ""
# Solicitar dirección IPv4
read -p $'\e[32mSet your IPv4 address:\e[0m' ip
echo " "

# Pedir al usuario el tipo de escaneo
valid_input=0
while [ $valid_input -eq 0 ]
do
    echo -e "\e[32mSelect your scan type:\e[0m"
    echo " "
    echo "1. Estandard scan, all ports and services, agressive" | sed 's/^/    /'
    echo "2. Default Nmap scripts scann  \(More options inside\)" | sed 's/^/    /'
    echo "3. Paranoid TCP port scan with version detection" | sed 's/^/    /'
    echo "4. Very Sneaky scan, firewall evasion, all ports" | sed 's/^/    /'
    echo "5. Sneaky decoy scan, IDS evasion, all ports" | sed 's/^/    /'
    echo "6. CVE Detection script" | sed 's/^/    /'
    echo "7. FTP brute forze script" | sed 's/^/    /'
    echo "8. Safe SMB script" | sed 's/^/    /'
    echo "9. Vulnerability scan using vulscan script" | sed 's/^/    /'
    echo " "
    read -p "Select one please: " scan_type

echo " "

    if [[ $scan_type =~ ^[1-9]$ ]]; then
        valid_input=1
    else
        echo "No no nonon, select a valid answer pls"
echo " "
    fi
done

# -A = deteccion de sistema y servicios
# -T4 = Nivel agresividad escaneo, T1 paranoico, T5 Hardcore
# -p- = escanea todos los puertos
#  | sed 's/^/    /' = Ingresa sangria en el texto, el espacio entre /  / es el espacio de sangria
# Poner verde = \e[32m - \e[0m
# Poner rojo = \e[31m - \e[0m

# Realizar el escaneo
case $scan_type in
    1)
        nmap -T4 -A -p- $ip
        ;;
    2)
        valid_input=0
        while [ $valid_input -eq 0 ]
        do
            echo -e "\e[31mSelect your script type:\e[0m" | sed 's/^/    /'
            echo " "
            echo "1. Default scripts scan by Nmap" | sed 's/^/        /'
            echo "2. Http-Headers Scan" | sed 's/^/        /'
            echo "3. DNS-Brute Scan" | sed 's/^/        /'
            echo " "
            read -p "Select one please: " scan_type_2

            if [[ $scan_type_2 =~ ^[1-3]$ ]]; then
                valid_input=1
            else
                echo "Bad selection"
            fi
        done

        case $scan_type_2 in
            1)
                nmap -sV -sC $ip
                ;;
            2)
                # Agrega aquí el comando para el tipo de escaneo que quieras agregar
                nmap --script http-headers $ip
                ;;
            3)
                # Agrega aquí el comando para el tipo de escaneo que quieras agregar
                nmap --script dns-brute $ip
                ;;
        esac
        ;;
    3)
        nmap -T1 -sS -sV -v $ip
        ;;
    4)
        nmap -p- -sA -Pn -n $ip
        ;;
    5)
        nmap -p- -sS -Pn -n -D RND:5 $ip
        ;;
    6)
        nmap -Pn –script vuln $ip
        ;;
    7)
        nmap --script ftp-brute -p 21 $ip
        ;;
    8)
        nmap -n -Pn -vv -O -sV -script smb-enum*,smb-ls,smb-mbenum,smb-os-discovery,smb-s*,smb-vuln*,smbv2* -vv $ip
        ;;
    9)
        nmap -sV --script=vulscan/vulscan.nse $ip
        ;;
esac