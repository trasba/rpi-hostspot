#!/bin/bash
PATH=/bin:/usr/local/sbin:/usr/sbin:/usr/bin
function service-cmd {
  service=$1
  command=$2
  case $command in
    start)
      if [ $(ps aux | grep -v grep | grep $service | wc -l) -gt 0 ]
      then
        echo "OK $service is running"
      else
        echo "starting $service"
        service $service start
      fi
      ;;

    stop)
      if [ $(ps aux | grep -v grep | grep $service | wc -l) -gt 0 ]
      then
        echo "stopping $service"
        service $service stop
      else
        echo "OK $service is not running"
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
  else
    echo "Interface $interface is up"
  fi
}

while [ 1 ]
do
  interface-up "wlan0"
  #dnsmasq
  service-cmd "dnsmasq" start
  service-cmd "hostapd" start
  sleep 3s
done
