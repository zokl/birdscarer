include $(TOPDIR)/rules.mk

PKG_NAME:=birdscarer
PKG_VERSION:=20190408
PKG_RELEASE:=$(PKG_SOURCE_VERSION)
PKG_REV:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utilities
	CATEGORY:=Utilities
	TITLE:=Bird Scarer
	URL:=https://github.com/zokl/birdscarer
	DEPENDS:=+openssh-sftp-server +tmux +kmod-leds-gpio +kmod-ledtrig-heartbeat +kmod-ledtrig-timer +kmod-ledtrig-netdev +kmod-dma-ralink +madplay-alsa +alsa-utils +kmod-sound-core +kmod-usb-audio
endef

define Package/$(PKG_NAME)/description
Bird scarer system for OpenWRT and Olimex RT5350f EVB.
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	[ -d ./system/etc ] && $(CP) ./system/etc/* $(1)/

	$(CP) ./sources/voices $(1)/usr/share/birdscarer/

	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) ./soures/birdscarer.sh $(1)/usr/sbin/birdscarer

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./system/init/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
