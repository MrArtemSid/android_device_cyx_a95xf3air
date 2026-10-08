#
# Copyright (C) 2021-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/cyx/a95xf3air

## Bluetooth
BOARD_HAVE_BLUETOOTH := true

## Bootloader
TARGET_BOOTLOADER_BOARD_NAME := a95xf3air

## DTB
TARGET_DTB_NAME := sm1_s905x3_a95xf3air
TARGET_DTBO_NAME := android_overlay_dt
BOARD_KERNEL_SEPARATED_DTBO := true

## Kernel
TARGET_KERNEL_PLATFORM_TARGET := a95xf3air
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/vendor_dlkm.modules.load))
BOOT_KERNEL_MODULES := $(strip $(shell cat $(DEVICE_PATH)/vendor_boot.modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(BOOT_KERNEL_MODULES)
RECOVERY_KERNEL_MODULES := $(BOOT_KERNEL_MODULES)
BOARD_RECOVERY_KERNEL_MODULES_LOAD := $(BOOT_KERNEL_MODULES)

## Partitions
# Dynamic partitions are retrofitted onto the stock Android 9 layout.
# The super metadata lives on system.
BOARD_SUPER_PARTITION_BLOCK_DEVICES := vendor odm system product
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 268435456
BOARD_SUPER_PARTITION_ODM_DEVICE_SIZE := 134217728
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 1610612736
BOARD_SUPER_PARTITION_PRODUCT_DEVICE_SIZE := 134217728
BOARD_SUPER_PARTITION_SIZE := $(shell echo $$(( \
    $(BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE) + \
    $(BOARD_SUPER_PARTITION_ODM_DEVICE_SIZE) + \
    $(BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE) + \
    $(BOARD_SUPER_PARTITION_PRODUCT_DEVICE_SIZE))))

## Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

## Recovery
# Define the custom recovery UI static library
TARGET_RECOVERY_UI_LIB := librecovery_ui_a95xf3air

# Ensure the module is built alongside recovery
TARGET_RECOVERY_DEVICE_MODULES += librecovery_ui_a95xf3air

## SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

## Wi-Fi
# MT7668 over SDIO uses the standard cfg80211/nl80211 interface. The AOSP
# libwifi-hal is the fallback stub; the stock Amlogic multi-wifi HAL is loaded
# dynamically through wifi/wifi_vendor_hal.xml.
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_0_8_X

## Include the common tree BoardConfig makefile
include device/amlogic/g12-common/BoardConfigCommon.mk

## Kernel
# g12-common points TARGET_KERNEL_SOURCE at its 4.9 kernel, so set the
# 5.15 platform build only after including it.
TARGET_KERNEL_VERSION := 5.15
TARGET_KERNEL_SOURCE := vendor/cyx/a95xf3air-build
