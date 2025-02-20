################################################################################
#
# xdriver_xf86-video-armsoc
#
################################################################################

XDRIVER_XF86_VIDEO_ARMSOC_VERSION = 8bbdb2ae3bb8ef649999a8da33ddbe11a04763b8
XDRIVER_XF86_VIDEO_ARMSOC_SITE = https://gitlab.freedesktop.org/xorg/driver/xf86-video-armsoc.git
XDRIVER_XF86_VIDEO_ARMSOC_SITE_METHOD = git
XDRIVER_XF86_VIDEO_ARMSOC_LICENSE = MIT
XDRIVER_XF86_VIDEO_ARMSOC_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_ARMSOC_AUTORECONF = YES
XDRIVER_XF86_VIDEO_ARMSOC_DEPENDENCIES = mali-userspace-binaries \
                                         xserver_xorg-server \
                                         xorgproto

define XDRIVER_XF86_VIDEO_ARMSOC_LIBEXA_SYMLINK
	cd ${STAGING_DIR}/usr/lib && ln -snf xorg/modules/libexa.so libexa.so
	cd ${TARGET_DIR}/usr/lib && ln -snf xorg/modules/libexa.so libexa.so
endef

define XDRIVER_XF86_VIDEO_ARMSOC_XORG_CONF
	$(INSTALL) -m 0644 -D $(XDRIVER_XF86_VIDEO_ARMSOC_PKGDIR)/src/xorg.conf $(TARGET_DIR)/etc/X11/xorg.conf
endef

XDRIVER_XF86_VIDEO_ARMSOC_PRE_PATCH_HOOKS += XDRIVER_XF86_VIDEO_ARMSOC_LIBEXA_SYMLINK
XDRIVER_XF86_VIDEO_ARMSOC_POST_INSTALL_TARGET_HOOKS += XDRIVER_XF86_VIDEO_ARMSOC_XORG_CONF

$(eval $(autotools-package))
