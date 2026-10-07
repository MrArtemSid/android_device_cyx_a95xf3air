#
# Copyright (C) 2021-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

## Bluetooth
# Read by the g12-common vendor makefile to skip the DroidLogic HIDL HAL.
TARGET_USE_AIDL_BLUETOOTH_HAL := true

PRODUCT_PACKAGES += \
    A95xf3airBluetoothOverlay \
    android.hardware.bluetooth-service.default

## Factory
PRODUCT_HOST_PACKAGES += \
    aml_image_packer

## Graphics (Mali)
PRODUCT_PACKAGES += \
    libGLES_mali \
    vendor_lib_hw_vulkan_amlogic_so

## Wi-Fi HAL (stock Amlogic multi-wifi, from the A95X F3 Air Android 9 vendor)
PRODUCT_PACKAGES += \
    libwifi-hal-amlogic \
    libwifi-hal-common-ext \
    wifi_vendor_hal.xml

## Init-Files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init-files/init.amlogic.wifi_buildin.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi_buildin.rc

## Wi-Fi / Bluetooth (MT7668)
# Firmware comes with the driver in kernel/.../vendor/mediatek/mt7668. The
# driver reads its settings from wifi.cfg; use the stock tuning of this box
# (BT coexistence, efuse calibration) instead of the generic one.
MT7668_FIRMWARE_PATH := kernel/platform/kernel-5.15/vendor/mediatek/mt7668/firmware

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/proprietary/vendor/firmware/wifi_mt7668.cfg:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/wifi.cfg \
    $(filter-out %/lib/firmware/wifi.cfg,$(call find-copy-subdir-files,*,$(MT7668_FIRMWARE_PATH),$(TARGET_COPY_OUT_VENDOR)/lib/firmware))

## Keylayout (IR)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl


## OpenVFD
PRODUCT_PACKAGES += \
    init.openvfd.rc \
    openvfd_clock.sh

## TEE
TARGET_HAS_TEE := false

## Soong Namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

## Inherit from the common tree product makefile
$(call inherit-product, device/amlogic/g12-common/g12.mk)
