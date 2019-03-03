# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=Werewolf by USA-RedDragon @ xda-developers
do.devicecheck=0
do.initd=1
do.modules=1
do.cleanup=1
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
device.name6=
device.name7=
device.name8=
device.name9=
device.name10=

# shell variables
block=/dev/block/platform/sdio_emmc/by-name/KERNEL;
is_slot_device=0;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel install
dump_boot;

write_boot;

## end install

