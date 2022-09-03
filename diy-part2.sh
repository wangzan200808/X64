#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

VERSION="V3.3.0-12"

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
