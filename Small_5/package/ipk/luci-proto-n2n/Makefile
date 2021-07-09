include $(TOPDIR)/rules.mk

PKG_NAME:=luci-proto-n2n
PKG_VERSION:=1.0
PKG_RELEASE:=7

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=5. Protocols
  TITLE:=LuCI support for N2N VPN.
  DEPENDS:=+n2n-edge
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI support for N2N VPN.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/po/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Compile
endef

define JsMin
	$(FIND) $(1) -type f -name '*.js' | while read src; do \
		if jsmin < "$$$$src" > "$$$$src.o"; \
		then mv "$$$$src.o" "$$$$src"; fi; \
	done
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/n2n.sh $(1)/lib/netifd/proto/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/n2n.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/www/luci-static/resources/protocol
	$(INSTALL_DATA) ./files/n2n.js $(1)/www/luci-static/resources/protocol/
	$(if $(CONFIG_LUCI_JSMIN),$(call JsMin,$(1)/www/luci-static/resources/protocol/),true)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
