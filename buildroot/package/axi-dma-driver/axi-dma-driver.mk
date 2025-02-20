################################################################################
#
# axi-dma-driver
#
################################################################################

AXI_DMA_DRIVER_SITE = ${BR2_EXTERNAL_IMPL_PATH}/package/axi-dma-driver/axi-dma-driver
AXI_DMA_DRIVER_SITE_METHOD = local

$(eval $(kernel-module))
$(eval $(generic-package))
