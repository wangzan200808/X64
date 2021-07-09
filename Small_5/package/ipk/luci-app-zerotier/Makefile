include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-zerotier
PKG_VERSION:=1.0
PKG_RELEASE:=4

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI for Zerotier
  DEPENDS:=+zerotier +luci-compat
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI for Zerotier.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/luasrc/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/zerotier
	$(INSTALL_DATA) ./luasrc/model/cbi/zerotier/*.lua $(1)/usr/lib/lua/luci/model/cbi/zerotier/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/zerotier
	$(INSTALL_DATA) ./luasrc/view/zerotier/*.htm $(1)/usr/lib/lua/luci/view/zerotier/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/zerotier.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/acl.d/* $(1)/usr/share/rpcd/acl.d/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
