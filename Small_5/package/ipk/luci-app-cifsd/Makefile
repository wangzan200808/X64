include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cifsd
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=LuCI
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for CIFSD CIFS/SMB kernel fileserver
	DEPENDS:=+ksmbd-server +ksmbd-utils
	PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI support for CIFSD CIFS/SMB kernel fileserver
endef

define Build/Prepare
	chmod -R 755 htdocs/* root/*
	find htdocs -type f -exec chmod 644 {} \;
	find root -type f -exec chmod 644 {} \;
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
	$(INSTALL_DIR) $(1)/www
	cp -pr htdocs/* $(1)/www
	$(if $(CONFIG_LUCI_JSMIN),$(call JsMin,$(1)/www/luci-static/resources/view/),true)
	cp -pr root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo po/zh-cn/cifsd.po $(1)/usr/lib/lua/luci/i18n/cifsd.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
