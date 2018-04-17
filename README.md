# rpi-hostspot
raspberry pi (3 B+) wlan hostspot with docker containers

This will transform your Raspberry Pi (tested with model 3 B+) into an hotspot wlan access point.\
This was tested with:
* an Raspberry Pi 3 B+
* an USB UMTS modem (Huawei K3765)

### remark
right now it may be necessary to set the ip address of the interface once according to the subnet specified in hostapd.conf to do this run:\
`sudo ip addr add 192.168.9.1/24 dev wlan0`

### setup docker & docker-compose
You need to have docker and docker-compose installed.\
You can install it via a Webscript\
`curl -fsSL get.docker.com -o- | sudo -E bash`\
`sudo pip install docker-compose`

If you don't have pip installed install it via\
`sudo apt-get install pip`

### start docker containers
Now you need to change to the rpi-hotspot folder and from here you can start the docker containers via\
`docker-compose up`

The images get pulled and the containers start up...\
Ups this wont work because the docker-compose.yml contains the following line which needs to be adjusted:
```
# values in <> are just examples the correct values have to be filled in
entrypoint: /opt/umtskeeper/umtskeeper --sakisoperators 'OTHER="USBMODEM" USBMODEM="<12d1:1465>" USBINTERFACE="<0>" SIM_PIN="<1234>" APN="<internet.eplus.de>"' --sakisswitches "--sudo --console" --devicename 'Huawei' --log --nat 'no'
# a good way to get the values is to run ./sakis3g and follow the error messages one at a time
```

### adjust umtskeeper commandline according to your setup
The comments alreasy lead you into the right direction. Start a container manually with:\
`docker run -it --rm trasba/rpi-umts /bin/bash`

In the following console make sure you are in the folder /opt/umtskeeper. Then run:\
`./sakis3g connect`

You will get an error message telling you what to do. The first step ist to add OTHER="USBMODEM". Then you run accordingly:\
`./sakis3g connect OTHER="USBMODEM"`

You will get another error message. You will continue until you have the cmoplete command. Something like:\
`./sakis3g OTHER="USBMODEM" USBMODEM="12d1:1465" USBINTERFACE="0" SIM_PIN="1234" APN="internet.eplus.de"`\

Now you exchange the exchange line in the docker-compose.yml file it could look like this:\
`entrypoint: /opt/umtskeeper/umtskeeper --sakisoperators 'OTHER="USBMODEM" USBMODEM="12d1:1465" USBINTERFACE="0" SIM_PIN="1234" APN="internet.eplus.de"' --sakisswitches "--sudo --console" --devicename 'Huawei' --log --nat 'no'`

### final startup
now run:\
`docker-compose up -d`
first you should notice that the wlan is up and you can login according to the settings in hostapd.conf
second the usb modem led should change the pattern from two blinks to one blink per period. When the connection is established the led should be lit continuously.

### enable the routing and NAT
What needs to be done is
* the activation of ipv4 forwarding\
add/uncomment the line:\
`net.ipv4.ip_forward = 1`\
to the file /etc/sysctl.conf
* setting up iptables\
I prefer to set this up in crontab. To do this run:
`sudo crontab -e`\
and add the line:
`@reboot /sbin/iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE`
now when the raspberry reboots the command: `iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE` is executed.

To make it work instantly you need to run the command once manually:\
`sudo iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE`

Now you should be able to go online with devices connected to the Hotspot Wlan.

### automatic startup on restart
to automatically start this wifi ap on startup add the folling line to your crontab:\
`@reboot (sleep 30s ; cd /home/pi/code/docker/compose-wifiap ; /usr/local/bin/docker-compose up -d )&`\
where "/home/pi/code/docker/rpi-hotspot" needs to be adjusted to where the files are in your setup

Leave a comment with regard to your experience
Cheers Tobias
