include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cpufreq
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_LICENSE:=GPLv2
PKG_MAINTAINER:=Small_5

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=CPU Freq Setting
  DEPENDS:=@(arm||aarch64) +luci-compat
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI for CPU Freq Setting.
endef

define Build/Prepare
	chmod -R 755 luasrc/* root/*
	find luasrc -type f -exec chmod 644 {} \;
	find root -type f -exec chmod 644 {} \;
	chmod 755 root/etc/init.d/*
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pr luasrc/* $(1)/usr/lib/lua/luci
	cp -pr root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo po/zh-cn/cpufreq.po $(1)/usr/lib/lua/luci/i18n/cpufreq.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
