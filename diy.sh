#!/bin/bash
VERSION="V3.3.0-12"
A=0
[ -n "$OP_TARGET" ] || OP_TARGET="X64"
case "$OP_TARGET" in
	X64)path="X64";;
	*)echo "No adaptation target!";exit 1;;
esac
cp -r target/$path/. Small_5

if [ $A = 1 ];then
	rm -rf openwrt/target/linux/ramips
	cp -r target/target/ramips/. Small_5
	chmod 0775 Small_5/target/linux/ramips/mt76x8/base-files/etc/init.d/* Small_5/target/linux/ramips/mt76x8/base-files/lib/upgrade/*
	chmod 0775 Small_5/target/linux/ramips/mt7620/base-files/etc/init.d/* Small_5/target/linux/ramips/mt7620/base-files/lib/upgrade/*
	chmod 0775 Small_5/target/linux/ramips/mt7621/base-files/etc/init.d/* Small_5/target/linux/ramips/mt7621/base-files/lib/upgrade/platform.sh Small_5/target/linux/ramips/mt7621/base-files/sbin/*
	chmod 0755 Small_5/target/linux/ramips/rt288x/base-files/lib/upgrade/*
	chmod 0755 Small_5/target/linux/ramips/rt305x/base-files/lib/upgrade/*
	chmod 0755 Small_5/target/linux/ramips/rt3883/base-files/lib/upgrade/*
	[ "$B" = 1 ] && rm -f Small_5/Patch-K2P-32M.patch
elif [ $A = 2 ];then
	rm -rf openwrt/package/boot/uboot-rockchip openwrt/package/kernel/linux/modules/video.mk openwrt/target/linux/rockchip
	cp -r target/target/rockchip/. Small_5
	chmod 0775 Small_5/package/boot/arm-trusted-firmware-rockchip-vendor/*.sh
elif [ $A = 3 ];then
	rm -rf openwrt/package/boot/uboot-envtools openwrt/package/boot/uboot-fritz4040 openwrt/package/firmware/ipq-wifi openwrt/target/linux/ipq40xx
	cp -r target/target/ipq40xx/. Small_5
	chmod 0775 Small_5/target/linux/ipq40xx/base-files/etc/init.d/* Small_5/target/linux/ipq40xx/base-files/lib/upgrade/*
fi

cp -r Small_5/. openwrt
rm -rf Openwrt_Custom Small_5 target README.md
cd openwrt

cat > version.patch  <<EOF
--- a/package/base-files/files/etc/banner
+++ b/package/base-files/files/etc/banner
@@ -4,5 +4,5 @@
  |_______||   __|_____|__|__||________||__|  |____|
           |__| W I R E L E S S   F R E E D O M
  -----------------------------------------------------
- %D %V, %C
+ %D $VERSION By Small_5, %C
  -----------------------------------------------------

--- a/package/base-files/files/etc/openwrt_release
+++ b/package/base-files/files/etc/openwrt_release
@@ -1,7 +1,7 @@
 DISTRIB_ID='%D'
-DISTRIB_RELEASE='%V'
+DISTRIB_RELEASE='$VERSION By Small_5'
 DISTRIB_REVISION='%R'
 DISTRIB_TARGET='%S'
 DISTRIB_ARCH='%A'
-DISTRIB_DESCRIPTION='%D %V %C'
+DISTRIB_DESCRIPTION='%D $VERSION By Small_5 %C'
 DISTRIB_TAINTS='%t'

--- a/package/base-files/files/usr/lib/os-release
+++ b/package/base-files/files/usr/lib/os-release
@@ -1,8 +1,8 @@
 NAME="%D"
-VERSION="%V"
+VERSION="$VERSION By Small_5"
 ID="%d"
 ID_LIKE="lede openwrt"
-PRETTY_NAME="%D %V"
+PRETTY_NAME="%D $VERSION By Small_5"
 VERSION_ID="%v"
 HOME_URL="%u"
 BUG_URL="%b"
@@ -15,4 +15,4 @@
 OPENWRT_DEVICE_MANUFACTURER_URL="%m"
 OPENWRT_DEVICE_PRODUCT="%P"
 OPENWRT_DEVICE_REVISION="%h"
-OPENWRT_RELEASE="%D %V %C"
+OPENWRT_RELEASE="%D $VERSION By Small_5 %C"
EOF

patch -p1 -E < default.patch && patch -p1 -E < feeds.patch && patch -p1 -E < version.patch && rm -f default.patch feeds.patch version.patch
for i in $(find -maxdepth 1 -name 'Patch-*.patch' | sed 's#.*/##');do
	patch -p1 -E < $i
done
rm -f Patch-*.patch
echo "Model:$OP_TARGET"
