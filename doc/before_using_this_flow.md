# Before using this flow

Minicom configuration
----
To control the terminal of buildroot from Minicom, we need to disable the hardware flow control.
This can be done in Minicom by using CTRL+o to open the configuration menu then select "serial port configuration" then disable "Hardware flow control" option.
Then select "Save config to dfl" to save configuration for future use.

Allowing current user in host machine to access to serial ports without sudo
----
First add current user to dialout and tty:
```shell
sudo usermod -a -G tty ${USER}
sudo usermod -a -G dialout ${USER}
```
Then you have to reboot

Xilinx JTAG drivers install
----
If your board isn't detected, it can be because the required driver is not installed. You can install it as following:
```bash
sudo bash <xilinx_install>/Vivado/<version>/data/xicom/cable_drivers/install_drivers
```

gmake vs make
----
GNU Make is not the only one make executable. To handle this problem, some  rename the make executable to gmake.
Xilinx software tools are using the gmake command instead of make.
If gmake is not present in /bin, you can create a symbolic link yourself:
```bash
sudo ln -s /bin/make /bin/gmake
```

Before initial manipulation:
----
Vivado works far better with `en_US.UTF-8` locale than others.
```bash
export LANG=en_US.UTF-8
```
We need Xilinx tools in our path. To add then, the best way is to source the `settings64.sh` present in the Vivado installation folder.
```bash
source <XILINX_INSTALL>/Vivado/<vivado version>/settings64.sh
```

Installing board definition files (Zedboard only)
----
By default, the Zedboard board definition files are not installed in 2022.2, to install them:
```bash
source <XILINX_INSTALL>/Vivado/<vivado version>/settings64.sh
vivado -mode tcl
```
Then, in the openned shell:
```tcl
xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]
xhub::install [xhub::get_xitems *zedboard*]
exit
```

