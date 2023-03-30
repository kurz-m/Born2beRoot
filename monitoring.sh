#!/bin/bash

# Get architecture and kernel version of the system
ARCHITECTURE=$(uname -a)
# Get the number of physical processors
PHYSICAL=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
# Get the number of virtual processors
VIRTUAL=$(grep "^processors" /proc/cpuinfo | wc -l)
# Get available RAM and percentage of utilization
FREERAM=$(free -m | awk '$1 == "Mem:" {print $2}')
USEDRAM=$(free -m | awk '$1 == "Mem:" {print $3}')
PERCRAM=$(free  | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
# Get available memory and percentage of utilization
FREEMEM=$(df --output=source,avail,target -h | grep "^/dev" | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
USEDMEM=$(df --output=source,used,target -h | grep "^/dev" | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
PERCMEM=$(df --output=source,pcent,target -h | grep "^/dev" | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
# Get utilization rate of processors as a percentage
PERCPROS=$(vmstat 1 2 | awk 'NR == 4 {print 100 - $15}')
# Date and time of last reebot
LASTBOOT=$(who -b | awk '$1 == "system" {print $3 " " $4}')
# Check if LVM is active
LVMACTIVE=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo "no"; else echo "yes"; fi)
# Get number of active connections
CONNECTIONS=$(netstat -an | grep ESTABLISHED | wc -l)
# Get numbers of users using the server
USERLOG=$(users | wc -w)
# Get IPv4 and Mac address
IP=$(hostname -I)
MAC=$(ip link | grep ether | awk '{print $2}')
# Get number of commands executed with the sudo program
SCOMMANDS=$(journalctl _COMM=sudo | grep COMMAND | wc -l)


wall "  #Architecture: $ARCHITECTURE
        #Physical CPU: $PHYSICAL
        #Virtual CPU: $VIRTUAL
        #Memory usage: $USEDRAM/${FREERAM}MB ($PERCRAM)
        #CPU load: $PERCPROS%
        #Last boot: $LASTBOOT
        #LVM use: $LVMACTIVE
        #Connections TCP: $CONNECTIONS ESTABLISHED
        #User log: $USERLOG
        #Network: IP $IP (MAC $MAC)
        #SUDO: $SCOMMANDS"
