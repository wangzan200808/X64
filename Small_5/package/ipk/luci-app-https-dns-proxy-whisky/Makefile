include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-https-dns-proxy-whisky
PKG_VERSION:=1.0
PKG_RELEASE:=6

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI support for Https-Dns-Proxy.
  DEPENDS:=+https-dns-proxy +luci-compat
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI support for Https-Dns-Proxy.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/po/zh-cn/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.zh-cn.lmo,$(notdir $(po)));)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./root/etc/config/https-dns-proxy $(1)/etc/config/https-dns-proxy
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/https-dns-proxy $(1)/etc/init.d/https-dns-proxy
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/* $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/https-dns-proxy.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/model/cbi/*.lua $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/https-dns-proxy
	$(INSTALL_DATA) ./luasrc/view/https-dns-proxy/*.htm $(1)/usr/lib/lua/luci/view/https-dns-proxy/
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/acl.d/* $(1)/usr/share/rpcd/acl.d/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
