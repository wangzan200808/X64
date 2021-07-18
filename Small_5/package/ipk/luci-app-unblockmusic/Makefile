include $(TOPDIR)/rules.mk
PKG_NAME:=luci-app-unblockmusic
PKG_VERSION:=2.3.5
PKG_RELEASE:=17
PKG_MAINTAINER:=lean
PKG_LICENSE:=Apache-2.0

PKG_CONFIG_DEPENDS := \
	CONFIG_UnblockNeteaseMusic_Go \
	CONFIG_UnblockNeteaseMusic_NodeJS

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/config
  source "$(SOURCE)/Config.in"
endef

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI support for Unblock NeteaseCloudMusic
  DEPENDS:=+dnsmasq-full +ipset +uclient-fetch +UnblockNeteaseMusic_NodeJS:UnblockNeteaseMusic +UnblockNeteaseMusic_Go:UnblockNeteaseMusicGo
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	Luci Support for Unblock NeteaseCloudMusic
endef

define Build/Prepare
	chmod -R 755 luasrc/* root/*
	find luasrc -type f -exec chmod 644 {} \;
	find root -type f -exec chmod 644 {} \;
	chmod 755 root/etc/hotplug.d/iface/* root/etc/init.d/* root/usr/bin/* root/usr/share/UnblockNeteaseMusic/*
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
/usr/share/UnblockNeteaseMusic/ca.crt
/usr/share/UnblockNeteaseMusic/server.crt
/usr/share/UnblockNeteaseMusic/server.key
/usr/share/UnblockNeteaseMusicGo/ca.crt
/usr/share/UnblockNeteaseMusicGo/server.crt
/usr/share/UnblockNeteaseMusicGo/server.key
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pr luasrc/* $(1)/usr/lib/lua/luci
	cp -pr root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo po/zh-cn/unblockmusic.po $(1)/usr/lib/lua/luci/i18n/unblockmusic.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
