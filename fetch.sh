#!/bin/bash

# Fetch the details
OS=$(uname -o)
ARCH=$(uname -m)
KERNEL=$(uname -sr)
HOSTNAME=$(hostname)
MACHINE_IP=$(hostname -i)
CLIENT_IP=":0"  # Assuming a placeholder, change as necessary
USER=$(whoami)
PROCESSOR=$(lscpu | grep "Model name:" | sed -e 's/Model name:\s*//' | awk '{print $1 " " $2 " " $3}')
CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
HYPERVISOR=$(lscpu | grep "Hypervisor vendor:" | awk '{print $3}')
LOAD_1M=$(uptime | awk -F'[a-z]:' '{ print $2 }' | awk '{print $1}')
LOAD_5M=$(uptime | awk -F'[a-z]:' '{ print $2 }' | awk '{print $2}')
LOAD_15M=$(uptime | awk -F'[a-z]:' '{ print $2 }' | awk '{print $3}')
VOLUME_USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 " [" $5 "]"}')
MEMORY_USAGE=$(free -h --si | awk '/Mem:/ {print $3 "/" $2}')
LAST_LOGIN=$(last -n 1 $USER | head -n 1 | awk '{print $4, $5, $6, $7}')
UPTIME=$(uptime -p)

# Print the output
cat <<EOF
OS          $OS                            
KERNEL      $KERNEL                         
─────────────────────────────────────────────────
MEMORY      $MEMORY_USAGE         
USAGE       $(free -m | awk '/Mem:/ {printf "%.2f%%", $3/$2 * 100.0}')
─────────────────────────────────────────────────
HOSTNAME    $HOSTNAME                       
MACHINE IP  $MACHINE_IP                     
CLIENT  IP  $CLIENT_IP                      
USER        $USER                           
─────────────────────────────────────────────────
PROCESSOR   $PROCESSOR
CORES       $CORES vCPU(s) / 1 Socket(s)     
HYPERVISOR  ${HYPERVISOR:-Bare Metal}        
LOAD  1m    $LOAD_1M
LOAD  5m    $LOAD_5M
LOAD 15m    $LOAD_15M
─────────────────────────────────────────────────
VOLUME      $VOLUME_USAGE         
DISK USAGE  $(df -h / | awk 'NR==2 {print $5}')
─────────────────────────────────────────────────
LAST LOGIN  $LAST_LOGIN            
UPTIME      $UPTIME
EOF

