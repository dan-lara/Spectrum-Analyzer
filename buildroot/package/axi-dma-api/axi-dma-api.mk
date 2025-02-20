################################################################################
#
# axi-dma-api
#
################################################################################

AXI_DMA_API_VERSION = 1.0
AXI_DMA_API_SITE = $(BR2_EXTERNAL_IMPL_PATH)/package/axi-dma-api/axi-dma-api
AXI_DMA_API_SITE_METHOD = local
AXI_DMA_API_INSTALL_STAGING = YES

define AXI_DMA_API_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define AXI_DMA_API_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m0755 $(@D)/libaxidma.so    $(STAGING_DIR)/usr/lib/libaxidma.so
	$(INSTALL) -D -m0644 $(@D)/axi_dma_api.h   $(STAGING_DIR)/usr/include/axi_dma_dev.h
	$(INSTALL) -D -m0644 $(@D)/axi_dma_ioctl.h $(STAGING_DIR)/usr/include/axi_dma_ioctl.h
endef

define AXI_DMA_API_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m0755 $(@D)/libaxidma.so      $(TARGET_DIR)/usr/lib/libaxidma.so
	$(INSTALL) -d -m0755 $(TARGET_DIR)/etc/axidma.d
endef

$(eval $(generic-package))
