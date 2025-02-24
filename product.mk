#
# Copyright (C) 2022 Giovanni Ricca
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit Android Go Makefile
$(call inherit-product, vendor/extra/config/go.mk)

# Inherit ih8sn Makefile
$(call inherit-product, vendor/extra/external/ih8sn/product.mk)

# Boot animation
TARGET_BOOTANIMATION_HALF_RES := true

# LDAC
PRODUCT_PACKAGES += \
    libldacBT_enc \
    libldacBT_abr

# Overlays
PRODUCT_PACKAGES += \
    WebViewOverlay \
    LineageUpdaterOverlay$(PRODUCT_VERSION_MAJOR) \
    RippleSystemUIOverlay

# Rootdir
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/bin/neofetch:$(TARGET_COPY_OUT_SYSTEM)/bin/neofetch

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
