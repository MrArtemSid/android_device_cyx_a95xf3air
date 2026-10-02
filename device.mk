#
# Copyright (C) 2021-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

## Bluetooth
PRODUCT_PACKAGES += \
    A95xf3airBluetoothOverlay \
    libbt-vendor

$(call soong_config_set,brcm_libbt,bdroid_buildcfg_include_dir,$(LOCAL_PATH)/bluetooth/include)
$(call soong_config_set,brcm_libbt,custom_bt_config,//$(LOCAL_PATH):vnd_a95xf3air.txt)

## Factory
PRODUCT_HOST_PACKAGES += \
    aml_image_packer

## Graphics (Mali)
PRODUCT_PACKAGES += \
    libGLES_mali \
    vendor_lib_hw_vulkan_amlogic_so

## Init-Files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init-files/init.amlogic.wifi_buildin.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi_buildin.rc

## Keylayout (IR)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl

## Remote (IR mouse mode)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init-files/init.remote.a95xf3air.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.remote.a95xf3air.rc \
    $(foreach f,remote-0xdf00.tab remote-0x4040.tab remote-0x7f80.tab, \
        $(LOCAL_PATH)/remote/$(f):$(TARGET_COPY_OUT_VENDOR)/etc/$(f))


## OpenVFD
# Lineage keeps Soong out of kernel/platform; OpenVFDService lives next to the
# driver there, as on other OpenVFD boxes.
PRODUCT_SOURCE_ROOT_DIRS += kernel/platform/kernel-5.15/vendor/amlogic/openvfd

PRODUCT_PACKAGES += \
    init.openvfd.rc \
    OpenVFDService

## TEE
TARGET_HAS_TEE := false

## Soong Namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/broadcom/libbt

## Inherit from the common tree product makefile
$(call inherit-product, device/amlogic/g12-common/g12.mk)
