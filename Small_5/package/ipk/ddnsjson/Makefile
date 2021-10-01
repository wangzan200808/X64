include $(TOPDIR)/rules.mk

PKG_NAME:=ddnsjson
PKG_RELEASE:=1

PKG_SOURCE_DATE:=2021-09-30
CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/ddnsjson
  SECTION:=base
  CATEGORY:=Base system
  DEPENDS:=+libubox +libjson-c
  TITLE:=DDNS JSON filter
endef

define Package/ddnsjson/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/jsonpath $(1)/usr/bin/ddnsjson
endef

$(eval $(call BuildPackage,ddnsjson))
