# Ethernet Gadget (RNDIS Net Adapter)
Ethernet gadget emulates the board as a net adapter and network can thereby be shared between host and this board.
## Recompile Kernel and Modules with Gadget Support
USB gadgets need specific options enabled in kernel thus a simple defconfig won't work. The required options are already configured in the `.config` file provided by this repository. Copy it to your kernel source directory and we are ready to compile. If you want the detailed configurations in menuconfig, please refer to [USB Gadget/Ethernet](https://linux-sunxi.org/USB_Gadget/Ethernet#Mainline_kernel_.28via_configfs.29).

Make sure the directory of your cross-compiler is in PATH before compilation.
Run 
```
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make -j$(nproc) zImage
```
and the kernel image would be at `arch/arm/boot`
### Compiling Modules
```
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make -j$(nproc) modules
```
### Module Installation
It is assumed that you are cross-compiling kernel for your board, thus where the modules generated is not important as long as you can find them and copy them to your borad's storage. Here we will generate modules under `modules` directory under kernel sources tree as an example:
```
mkdir modules
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=modules make modules modules_install
```
## User-space Configuration

### Loading Modules
First we need to copy the generated modules to your borad's storage. Copy the directory under `lib/modules/` in where the module is generated (`modules` in example above) to `/lib/modules/` in the storage on the board.

Then run
```
modprobe sunxi
modprobe configfs
modprobe libcomposite
modprobe u_ether
modprobe usb_f_rndis
```
to load modules.
### Configfs Initialization

```
cd /sys/kernel/config/usb_gadget
mkdir g1
cd g1
echo "0x0502" > idVendor
echo "0x3235" > idProduct
mkdir functions/rndis.rn0
mkdir configs/c1.1
ln -s functions/rndis.rn0 configs/c1.1/
echo "musb-hdrc.1.auto" > UDC
```
Note the udc name echoed to `UDC` in the last line may change on your platform. You should substitute it with the one found in `/sys/class/udc/`

### Bring Up The Interface
Append lines below to `/etc/network/interfaces`
```
iface usb0 inet static
        address 192.168.137.2
        netmask 255.255.255.0
        network 192.168.137.0
        broadcast 192.168.137.255
        gateway 192.168.137.1
```
The addresses should be edited accordingly to connect to the host. Here network `192.168.137.x` is set since it is the default network for sharing among adapters on Windows.
Then run
```
ifconfig usb0 up
```
Now if you check `ifconfig usb0` the configured IP address should be shown.
## Driver under Windows
The gadget may not be recognized by Windows right after configuration. In this case, you have to install the driver manually in the Device Manager.

First, download RNDIS driver [here](https://www.catalog.update.microsoft.com/Search.aspx?q=32589075-1506-4042-9bc4-a3009153023b).

Right click "This Computer" and select "management". Switch to "Device Manager" at the left side of the window popped up.

![](https://filestore.community.support.microsoft.com/api/images/e7b71a01-756c-41fd-9e15-f36bc90615ae)

Right click the device with name "RNDIS" and select "Update Driver Software".

![](https://www.factoryforward.com/wp-content/uploads/2018/01/11.pi-zero-w-with-laptop-factoryforward.png)

Specify the path to the folder where you have extracted the driver files.

After installation, the name of the device should become "Acer USB Ethernet/RNDIS Gadget".
## Boot-time Initialization
Repeating process above every time after boot is annoying. It is viable to initialize the initialize process automatically at boot time.
### Boot-time Module Loading
Add these lines to `/etc/modules`
```
sunxi
configfs
libcomposite
u_ether
usb_f_rndis
```
For details please refer to [Linux: How to load a kernel module automatically at boot time](https://www.cyberciti.biz/faq/linux-how-to-load-a-kernel-module-automatically-at-boot-time/).
### Boot-time configfs Setting
Save these line to a script file and make it executable with `chmod 755`
```
cd /sys/kernel/config/usb_gadget
mkdir g1
cd g1
echo "0x0502" > idVendor
echo "0x3235" > idProduct
mkdir functions/rndis.rn0
mkdir configs/c1.1
ln -s functions/rndis.rn0 configs/c1.1/
echo "musb-hdrc.1.auto" > UDC
```
Add the file name of the script above to `.bashrc`

If you want the initialization be performed before login, you have to register the script above as a service. See [this answer](https://unix.stackexchange.com/a/529183/445747) for details.

## Establishing Network Connection to Host
There are various schemes to connect the board to host's network. The details of accomplishing this are beyond the scope of this document. For static IP configuration under Windows, you can refer to [Ethernet Gadget](https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget).