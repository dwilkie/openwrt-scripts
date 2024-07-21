#!/bin/ash

# Turn an OpenWrt router with factory settings into a dumb access point
# as outlined in https://openwrt.org/docs/guide-user/network/wifi/dumbap

# use at your own risk !!!!
# backup your router first !!!!
# script expects factory settings !!!!

# After running this script you can optionally manually add the WAN port to act as a LAN port
# Under Network -> Interfaces, click the Devices Tab, configure the br-lan device and add the WAN port
# to the Bridge ports.

HOSTNAME="change-me"

# these services do not run on dumb APs
for i in firewall dnsmasq odhcpd; do
  if /etc/init.d/"$i" enabled; then
    /etc/init.d/"$i" disable
    /etc/init.d/"$i" stop
  fi
done


# Now switch the lan interface to DHCP client

uci set network.lan.proto='dhcp'
uci delete network.wan
uci delete network.wan6
uci delete network.lan.ipaddr
uci delete network.lan.netmask

# change the host name to "WifiAP"

uci set system.@system[0].hostname="$HOSTNAME"


echo '#####################################################################'
echo 'the script has disabled firewall, dns and dhcp server on this device'
echo 'and switched the protocol of the lan interface to dhcp client'
echo 'you can now connect the LAN port of this device to the LAN port'
echo 'of your main Router. Check the IP address of the WifiAP system'
echo 'and connect to that new IP address in order to run the'
echo 'second script. This device is now rebooting'
echo 'the host name of the device is now WifiAP, so you might also'
echo 'try ping WifiAP or ssh WifiAP or the like'
echo '#####################################################################'

# commit all changes

uci commit

# remove the firewall config

mv /etc/config/firewall /etc/config/firewall.unused

# reboot the device

reboot
