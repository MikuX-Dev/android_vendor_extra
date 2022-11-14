#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_lineageGlobalVars += \
    disable_postrender_cleanups

SOONG_CONFIG_lineageQcomVars += \
    qcom_no_fm_firmware

# Soong value variables
SOONG_CONFIG_lineageGlobalVars_disable_postrender_cleanups := $(TARGET_DISABLE_POSTRENDER_CLEANUPS)
SOONG_CONFIG_lineageQcomVars_qcom_no_fm_firmware := $(TARGET_QCOM_NO_FM_FIRMWARE)
