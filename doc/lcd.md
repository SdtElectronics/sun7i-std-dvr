# LCD
This document introduces how to use the 40pin panel controller output (lcd0) on board to drive a parallel RGB LCD.
![lcd480272](../img/lcd480272.png)

## NOTICES
### Enabling LCD Power
The power of lcd is controlled by PH08 (active low). Thus, PH08 must be pulled low to enable the lcd. This can be accomplished in u-boot either manually or by adding these lines to boot.cmd:
```
gpio set 232
gpio clear 232
```
These lines are added to [src/boot.cmd](https://github.com/SdtElectronics/sun7i-std-dvr/blob/master/src/boot.cmd) in this repository already.

### Backlight
Backlight of some panels consumes significant amount of power. Insufficient power supply to board could cause hang during boot with LCD connected. It is highly recommend that powering the board with 9V or above power supply via DC connector when a LCD is connected.

Backlight can be controlled by /sys/class/backlight/backlight/brightness :
```
echo 9 > /sys/class/backlight/backlight/brightness
```
Valid range is [0, 9]. Default brightness level is 6 with the configurations provided by this repository.

### Turn On/Off LCD

To turn off lcd:
```
echo 1 > /sys/class/graphics/fb0/blank
```
To turn on lcd:
```
echo 0 > /sys/class/graphics/fb0/blank
```
## Build Instructions
### RGB888, 480x272 panels
Copy [src/sun7i-a20-std-dvr_lcd480272.dts](https://github.com/SdtElectronics/sun7i-std-dvr/blob/master/src/sun7i-a20-std-dvr_lcd480272.dts) to $U-BOOT_SRC_DIR/arch/arm/dts/sun7i-a20-std-dvr.dts
```
cp src/sun7i-a20-std-dvr_lcd480272.dts $U-BOOT_SRC_DIR/arch/arm/dts/sun7i-a20-std-dvr.dts
```
Copy [src/A20_std_dvr_lcd480272_defconfig](https://github.com/SdtElectronics/sun7i-std-dvr/blob/master/src/A20_std_dvr_lcd480272_defconfig) to $U-BOOT_SRC_DIR/configs/ and build a config with it:
```
cp src/A20_std_dvr_lcd480272_defconfig $U-BOOT_SRC_DIR/configs/
make CROSS_COMPILE=arm-linux-gnueabihf- A20_std_dvr_lcd480272_defconfig
```
*NOTE:* You may want to edit `CONFIG_VIDEO_LCD_MODE` in [A20_std_dvr_lcd480272_defconfig](https://github.com/SdtElectronics/sun7i-std-dvr/blob/master/src/A20_std_dvr_lcd480272_defconfig) according to the manual of your lcd. See [LCD](https://linux-sunxi.org/LCD) for details.

Build u-boot and the resultant bootloader and dtb binaries support driving a lcd.

### RGB888, 800x480 panels
Copy [src/sun7i-a20-std-dvr_lcd800480.dts](https://github.com/SdtElectronics/sun7i-std-dvr/blob/master/src/sun7i-a20-std-dvr_lcd800480.dts) to $U-BOOT_SRC_DIR/arch/arm/dts/sun7i-a20-std-dvr.dts
```
cp src/sun7i-a20-std-dvr_lcd800480.dts $U-BOOT_SRC_DIR/arch/arm/dts/sun7i-a20-std-dvr.dts
```
Copy [src/A20_std_dvr_lcd800480_defconfig](https://github.com/SdtElectronics/sun7i-std-dvr/blob/master/src/A20_std_dvr_lcd800480_defconfig) to $U-BOOT_SRC_DIR/configs/ and build a config with it:
```
cp src/A20_std_dvr_lcd800480_defconfig $U-BOOT_SRC_DIR/configs/
make CROSS_COMPILE=arm-linux-gnueabihf- A20_std_dvr_lcd800480_defconfig
```
*NOTE:* You may want to edit `CONFIG_VIDEO_LCD_MODE` in [A20_std_dvr_lcd800480_defconfig](https://github.com/SdtElectronics/sun7i-std-dvr/blob/master/src/A20_std_dvr_lcd800480_defconfig) according to the manual of your lcd. See [LCD](https://linux-sunxi.org/LCD) for details.

Build u-boot and the resultant bootloader and dtb binaries support driving a lcd.

## [Go Back to main page](../README.md)
