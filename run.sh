#!/bin/bash
PATH=/bin:/usr/local/sbin:/usr/sbin:/usr/bin
function service-cmd {
  service=$1
  command=$2
  case $command in
    start)
      if [ $(ps aux | grep -v grep | grep $service | wc -l) -lt 1 ]
      then
        echo "$service not running -> starting..."
        service $service start
      fi
      ;;

    stop)
      if [ $(ps aux | grep -v grep | grep $service | wc -l) -gt 0 ]
      then
        echo "$service is running -> stopping..."
        service $service stop
      fi
      ;;
    restart)
      echo "restarting $service"
      service $service restart
      ;;
  esac
}

function interface-up {
  interface=$1
  if [ $(cat /sys/class/net/$interface/operstate) != "up" ]
  then
    echo "Interface $interface down -> bringing it up..."
    service-cmd "hostapd" restart
    ip link set dev $interface up
  fi
}

function set-ip {
  ipaddr=$(cat /etc/dnsmasq.conf|grep dhcp-range|grep -Eo '([0-9]{1,3}\.){3}'|head -1)1
  case $1 in
    'f')
      # f = force, flush and write address
      echo "Force flushing wlan0 and setting addr..."
      ip addr flush dev wlan0
      ip addr add $ipaddr/24 dev wlan0 
      ;;
    'c')
      # c = check, first check then possibly flush and write address
      if [ $(ip addr|grep -E $ipaddr|wc -l) -lt 1 ]
      then
        echo "Ip address not set correctly -> flushing wlan0 and setting address..."
        ip addr flush dev wlan0
        ip addr add $ipaddr/24 dev wlan0 
      fi
      ;;
  esac
}

set-ip f
while [ 1 ]
do
  interface-up "wlan0"
  service-cmd "dnsmasq" start
  service-cmd "hostapd" start
  set-ip c
  sleep 15s
done
