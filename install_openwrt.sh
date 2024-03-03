# install_openwrt.sh on Xiaomi ax3200
# From: https://openwrt.org/toh/xiaomi/ax3200

#!/bin/sh

nvram set ssh_en=1
nvram set uart_en=1
nvram set boot_wait=on
nvram set flag_boot_success=1
nvram set flag_try_sys1_failed=0
nvram set flag_try_sys2_failed=0
nvram set flag_ota_reboot=1
nvram set "boot_fw1=run boot_rd_img;bootm"
nvram commit

cd /tmp
wget http://192.168.31.100:8000/factory.bin
mtd -r write factory.bin firmware
