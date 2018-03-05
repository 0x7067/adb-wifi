#!/bin/sh

# Exit the script on errors:
set -e

# Restarting ADB
echo Restarting ADB
adb kill-server >/dev/null
adb start-server >/dev/null

android_api_level=$(adb shell getprop ro.build.version.sdk)

if [ "$android_api_level" -ge 23 ]; then
       device_internal_ip=$(adb shell ip address show | grep wlan0 | sed -n 2p | awk '{print $2}' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
else
       device_internal_ip=$(adb shell netcfg | grep wlan0 | awk '{print $3}' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
fi

echo Connecting to device: $device_internal_ip
port=5555

adb tcpip $port
adb connect $device_internal_ip