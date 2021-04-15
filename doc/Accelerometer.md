# Accelerometer
There is a [lis3dh](https://www.st.com/en/mems-and-sensors/lis3dh.html?icmp=pf250725_pron_pr_feb2014&sc=lis3dh-pr) accelerometer from STMicroelectronics on board, connected to `i2c1` bus at address `0x19`. The corresponding driver is available in mainline kernel and is configured as module in the `.config` file provided by this repository already. If you want to configure it manually, the path in `mennuconfig` is
```
    Device Drivers  --->
        Industrial I/O support  ---> 
            Accelerometers  --->
                < > STMicroelectronics accelerometers 3-Axis Driver
```

## Configuration
Compile modules with `.config` file provided by this repository, and the resultant drivers would be at `lib/modules/$(uname -r)/kernel/drivers/iio` in where the module is generated. Copy that directory to the corresponding place in your board's storage.

Compile device-trees in this repository which have already included configurations for the accelerometer. Copy the resultant `dtb` file to the boot partition in your board's storage.

Boot up the system on board, and load the driver with 
```
modprobe st_accel_i2c
```
Upon success, a message should be printed to the ring buffer:
```
dmesg | tail -n 1
[   81.290746] iio iio:device1: registered accelerometer lis3dh
```

## Usage
Whilst details of the usage is beyond the scope of this document, here is an instruction for a minimum test to verify the sensor worked functionally:

`cd` to the corresponding directory in `iio/devices` under `sysfs`, typically `iio:device1` :
```
/sys/bus/iio/devices/iio:device1
```
Here you could find a range of interfaces available:
```
current_timestamp_clock       in_accel_x_scale              in_accel_z_scale              power/                        uevent
dev                           in_accel_y_raw                label                         sampling_frequency
in_accel_scale_available      in_accel_y_scale              name                          sampling_frequency_available
in_accel_x_raw                in_accel_z_raw                of_node/                      subsystem/
```
Shake the board gently and see whether the ripple is captured:
```
cat in_accel_x_raw
-1248
```