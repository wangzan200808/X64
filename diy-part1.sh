#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#overwall测试版
sed -i '$a src-git overwall https://github.com/wangzan200808/overwall' feeds.conf.default
sed -i '$a src-git wx https://github.com/tty228/luci-app-wechatpush' feeds.conf.default
sed -i '$a src-git wz https://github.com/kenzok8/small-package' feeds.conf.default
#正常编译bypass
#sed -i '$a src-git wz https://github.com/wangzan200808/bypackage' feeds.conf.default
#sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
