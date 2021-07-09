include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-vsftpd
PKG_VERSION:=1.0
PKG_RELEASE:=4

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI support for VSFTPD
  DEPENDS:=+vsftpd-alt +luci-compat
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI support for VSFTPD
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/usr/lib/lua/luci/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/* $(1)/etc/uci-defaults/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/vsftpd.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/vsftpd
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/vsftpd/*.lua $(1)/usr/lib/lua/luci/model/cbi/vsftpd
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/vsftpd.lua $(1)/usr/lib/lua/luci/controller/vsftpd.lua
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./files/acl.d/* $(1)/usr/share/rpcd/acl.d/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
