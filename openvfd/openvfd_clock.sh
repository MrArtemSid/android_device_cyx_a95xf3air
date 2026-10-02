#!/vendor/bin/sh
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Shows the time on the FD628 front panel clock display through OpenVFD.
#

vfd=/sys/devices/platform/openvfd/leds/openvfd

echo colon > $vfd/led_on

while true; do
    date +%H%M > $vfd/text
    s=$(date +%S)
    sleep $((60 - ${s#0}))
done
