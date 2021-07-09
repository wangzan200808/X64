include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-filetransfer
PKG_VERSION:=1
PKG_RELEASE:=3

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI page for IPK upload
  DEPENDS:=+luci-lib-fs
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	Luci Support for filetransfer.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/po/zh-cn/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./etc/uci-defaults/* $(1)/etc/uci-defaults/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/model/cbi/*.lua $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/cbi
	$(INSTALL_DATA) ./luasrc/view/cbi/*.htm $(1)/usr/lib/lua/luci/view/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/filetransfer.*.lmo $(1)/usr/lib/lua/luci/i18n/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
