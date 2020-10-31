setenv bootargs console=ttyS0,115200 console=ttyS7,115200n8 root=/dev/mmcblk0p2 rootwait panic=10
load mmc 0:1 0x43000000 sun7i-a20-std-dvr.dtb || load mmc 0:1 0x43000000 boot/sun7i-a20-std-dvr.dtb
load mmc 0:1 0x42000000 zImage || load mmc 0:1 0x42000000 boot/zImage
bootz 0x42000000 - 0x43000000