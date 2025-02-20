################################################################################
#
# mali-userspace-binaries
#
################################################################################

MALI_USERSPACE_BINARIES_VERSION = da73805e3e011382c4d014ac10037cd193aaa9a0
MALI_USERSPACE_BINARIES_SITE = https://github.com/Xilinx/mali-userspace-binaries.git
MALI_USERSPACE_BINARIES_SITE_METHOD = git
MALI_USERSPACE_BINARIES_INSTALL_STAGING = YES
MALI_USERSPACE_BINARIES_LICENSE = ARM EULA
MALI_USERSPACE_BINARIES_LICENSE_FILES = EULA
ARCH_PLATFORM_DIR = aarch64-linux-gnu
MONOLITIC_LIBMALI = libMali.so.9.0
SHORT_MONOLITIC_LIBMALI = libMali.so.9
MALI_BACKEND_DEFAULT = "x11"
LOCAL_PKGCONFIG_DIR = ${BR2_EXTERNAL_IMPL_PATH}/package/mali-userspace-binaries/files

ifneq ($(BR2_PACKAGE_LIBGLVND),y)
  MALI_USERSPACE_BINARIES_PROVIDES += libegl
  MALI_USERSPACE_BINARIES_PROVIDES += libgles
  MALI_USERSPACE_BINARIES_PROVIDES += libgbm
endif

define MALI_USERSPACE_BINARIES_INSTALL_STAGING_CMDS
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/include
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/lib
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/lib/pkgconfig
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/include/EGL
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/include/GLES
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/include/GLES2
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/include/KHR
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/include/GBM
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/lib/x11
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/lib/fbdev
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/lib/wayland
  $(INSTALL) -d -m0755 $(STAGING_DIR)/usr/lib/headless
	$(INSTALL) -m0644 $(@D)/r9p0-01rel0/glesHeaders/EGL/*.h ${STAGING_DIR}/usr/include/EGL/
	$(INSTALL) -m0644 $(@D)/r9p0-01rel0/glesHeaders/GLES/*.h ${STAGING_DIR}/usr/include/GLES/
	$(INSTALL) -m0644 $(@D)/r9p0-01rel0/glesHeaders/GLES2/*.h ${STAGING_DIR}/usr/include/GLES2/
	$(INSTALL) -m0644 $(@D)/r9p0-01rel0/glesHeaders/KHR/*.h ${STAGING_DIR}/usr/include/KHR/
	$(INSTALL) -m0644 $(@D)/r9p0-01rel0/glesHeaders/GBM/*.h ${STAGING_DIR}/usr/include/GBM/
	$(INSTALL) -m0644 ${LOCAL_PKGCONFIG_DIR}/egl.pc ${STAGING_DIR}/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -m0644 ${LOCAL_PKGCONFIG_DIR}/glesv1.pc ${STAGING_DIR}/usr/lib/pkgconfig/glesv1.pc
	$(INSTALL) -m0644 ${LOCAL_PKGCONFIG_DIR}/glesv1_cm.pc ${STAGING_DIR}/usr/lib/pkgconfig/glesv1_cm.pc
	$(INSTALL) -m0644 ${LOCAL_PKGCONFIG_DIR}/glesv2.pc ${STAGING_DIR}/usr/lib/pkgconfig/glesv2.pc
	$(INSTALL) -m0644 ${LOCAL_PKGCONFIG_DIR}/gbm.pc ${STAGING_DIR}/usr/lib/pkgconfig/gbm.pc
  cp -a --no-preserve=ownership $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/common/*.so ${STAGING_DIR}/usr/lib/
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/x11/${MONOLITIC_LIBMALI} ${STAGING_DIR}/usr/lib/x11/${MONOLITIC_LIBMALI}
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/fbdev/${MONOLITIC_LIBMALI} ${STAGING_DIR}/usr/lib/fbdev/${MONOLITIC_LIBMALI}
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/wayland/${MONOLITIC_LIBMALI} ${STAGING_DIR}/usr/lib/wayland/${MONOLITIC_LIBMALI}
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/headless/${MONOLITIC_LIBMALI} ${STAGING_DIR}/usr/lib/wayland/${MONOLITIC_LIBMALI}
	cd ${STAGING_DIR}/usr/lib/ && ln -snf x11/${MONOLITIC_LIBMALI}
	cd ${STAGING_DIR}/usr/lib/ && ln -snf ${MONOLITIC_LIBMALI} ${SHORT_MONOLITIC_LIBMALI}
	cd ${STAGING_DIR}/usr/lib/ && ln -snf ${SHORT_MONOLITIC_LIBMALI} libMali.so
endef

define MALI_USERSPACE_BINARIES_INSTALL_TARGET_CMDS
  $(INSTALL) -d -m0755 $(TARGET_DIR)/usr/include
  $(INSTALL) -d -m0755 $(TARGET_DIR)/usr/lib
  $(INSTALL) -d -m0755 $(TARGET_DIR)/usr/lib/x11
  $(INSTALL) -d -m0755 $(TARGET_DIR)/usr/lib/fbdev
  $(INSTALL) -d -m0755 $(TARGET_DIR)/usr/lib/wayland
  $(INSTALL) -d -m0755 $(TARGET_DIR)/usr/lib/headless
  cp -a --no-preserve=ownership $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/common/*.so ${TARGET_DIR}/usr/lib/
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/x11/${MONOLITIC_LIBMALI} ${TARGET_DIR}/usr/lib/x11/${MONOLITIC_LIBMALI}
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/fbdev/${MONOLITIC_LIBMALI} ${TARGET_DIR}/usr/lib/fbdev/${MONOLITIC_LIBMALI}
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/wayland/${MONOLITIC_LIBMALI} ${TARGET_DIR}/usr/lib/wayland/${MONOLITIC_LIBMALI}
  $(INSTALL) -D -m0755 $(@D)/r9p0-01rel0/${ARCH_PLATFORM_DIR}/headless/${MONOLITIC_LIBMALI} ${TARGET_DIR}/usr/lib/wayland/${MONOLITIC_LIBMALI}
	cd ${TARGET_DIR}/usr/lib/ && ln -snf x11/${MONOLITIC_LIBMALI} ${TARGET_DIR}/usr/lib/${MONOLITIC_LIBMALI}
	cd ${TARGET_DIR}/usr/lib/ && ln -snf ${MONOLITIC_LIBMALI} ${SHORT_MONOLITIC_LIBMALI}
	cd ${TARGET_DIR}/usr/lib/ && ln -snf ${SHORT_MONOLITIC_LIBMALI} libMali.so
	$(INSTALL) -d -m0755 $(TARGET_DIR)/etc/libmali.d
endef

$(eval $(generic-package))
