#!/usr/bin/env python3
#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Generates factory/bootfiles/{misc,rsv}.img for the Amlogic burning packages.
#
# The stock U-Boot is signed and cannot boot the LineageOS images, so the box
# boots through a mainline U-Boot kept in the rsv partition:
#
#   rsv.img   mainline U-Boot (u-boot.bin of its a95xf3air chainload config)
#             at +1 MiB, where the bootcmd below loads it from.
#   misc.img  one-shot installer for the stock U-Boot. Its preboot runs
#             "bcb uboot-command": a BCB whose command is "uboot-command" has
#             its recovery field run as U-Boot commands and the BCB cleared.
#             The burning tool resets the environment to the stock default
#             (bootcmd=run storeboot), so this puts the rsv chainload back
#             into bootcmd and saves it on the first boot after burning.
#
# Usage: mkbootfiles.py <mainline u-boot.bin> <output dir>

import os
import sys

RSV_UBOOT_OFFSET = 0x100000
RSV_UBOOT_MAX = 0x200000

BOOTCMD = (
    'ddr_auto_fast_boot_check 6 0 0 50; '
    'if usb start 0; then run recovery_from_udisk; fi; '
    'if store read rsv 0x1000000 0x100000 0x200000 && '
    'itest.l *0x1000000 == 0x1400000a; then '
    'echo "chainloading u-boot from rsv"; go 0x1000000; fi; '
    'run storeboot'
)

# Stock update without the SD card: the upgrade key goes to the USB burning
# tool, then a USB stick, as before.
UPDATE = (
    'run usb_burning; run sdc_burning; '
    'if usb start 0; then run recovery_from_udisk;fi;'
    'run recovery_from_flash;'
)

# struct bootloader_message: command[32], status[32], recovery[768]
MISC_SIZE = 2048


def make_misc():
    cmd = f"setenv bootcmd '{BOOTCMD}'; setenv update '{UPDATE}'; saveenv"
    assert "'" not in BOOTCMD + UPDATE
    raw = cmd.encode()
    if len(raw) >= 768:
        sys.exit(f'installer command too long: {len(raw)} >= 768')
    misc = bytearray(MISC_SIZE)
    misc[0:13] = b'uboot-command'
    misc[64:64 + len(raw)] = raw
    return bytes(misc)


def make_rsv(uboot):
    if uboot[:4] != bytes.fromhex('0a000014'):
        sys.exit('u-boot.bin does not start with the expected branch')
    if len(uboot) > RSV_UBOOT_MAX:
        sys.exit(f'u-boot.bin too large: {len(uboot)} > {RSV_UBOOT_MAX}')
    rsv = bytes(RSV_UBOOT_OFFSET) + uboot
    return rsv + bytes(-len(rsv) % 512)


def main():
    if len(sys.argv) != 3:
        sys.exit(f'usage: {sys.argv[0]} <u-boot.bin> <output dir>')
    with open(sys.argv[1], 'rb') as f:
        uboot = f.read()
    out = sys.argv[2]
    with open(os.path.join(out, 'misc.img'), 'wb') as f:
        f.write(make_misc())
    with open(os.path.join(out, 'rsv.img'), 'wb') as f:
        f.write(make_rsv(uboot))


if __name__ == '__main__':
    main()
