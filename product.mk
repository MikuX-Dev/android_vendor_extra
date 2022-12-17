#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit Android Go Makefile
$(call inherit-product, vendor/extra/config/go.mk)

# Inherit Rootdir Makefile
$(call inherit-product, vendor/extra/rootdir/rootdir.mk)

# Inherit ih8sn Makefile
$(call inherit-product, vendor/extra/external/ih8sn/ih8sn.mk)

# Inherit Proprietaty Makefile
$(call inherit-product, vendor/extra/proprietary/extra-vendor.mk)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Apps
ifeq ($(PRODUCT_VERSION_MAJOR), 19)
PRODUCT_PACKAGES += \
    GrapheneCamera
endif

# Overlays
PRODUCT_PACKAGES += \
    BromiteWebViewOverlay \
    LineageUpdaterOverlay$(PRODUCT_VERSION_MAJOR)

# LDAC
PRODUCT_PACKAGES += \
    libldacBT_enc \
    libldacBT_abr
