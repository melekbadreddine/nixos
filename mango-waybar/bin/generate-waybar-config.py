#!/usr/bin/env python3
"""
Generate waybar config dynamically based on connected displays.
Uses DP-1/DP-2 when available (desktop ultrawide setup), falls back to primary display.
"""

import json
import os
import glob
import sys

def get_connected_outputs():
    """Detect connected DRM outputs."""
    connected = []
    for status_file in glob.glob('/sys/class/drm/card*-*/status'):
        with open(status_file) as f:
            if f.read().strip() == 'connected':
                # Extract output name from path like /sys/class/drm/card1-eDP-1/status
                output = os.path.basename(os.path.dirname(status_file))
                # Remove card prefix (card0-, card1-, etc.)
                for prefix in ['card0-', 'card1-', 'card2-', 'card3-']:
                    if output.startswith(prefix):
                        output = output[len(prefix):]
                        break
                connected.append(output)
    return connected

def generate_config():
    connected = get_connected_outputs()
    
    # Determine main bar outputs
    main_outputs = []
    for out in ['DP-1', 'DP-2']:
        if out in connected:
            main_outputs.append(out)
    
    # Fallback to primary display
    is_fallback = False
    if not main_outputs:
        is_fallback = True
        for out in connected:
            if out not in ['HDMI-A-1']:
                main_outputs.append(out)
                break
        if not main_outputs and connected:
            main_outputs.append(connected[0])
    
    # Use smaller margins for fallback (laptop) displays
    if is_fallback:
        margin_left = 50
        margin_right = 50
    else:
        margin_left = 446
        margin_right = 446
    
    bars = []
    
    # Main bar
    main_bar = {
        "layer": "top",
        "position": "top",
        "height": 36,
        "margin-top": 7,
        "margin-left": margin_left,
        "margin-right": margin_right,
        "spacing": 6,
        "modules-left": [
            "image",
            "dwl/tags",
            "dwl/window"
        ],
        "modules-center": [
            "cpu",
            "temperature",
            "memory",
            "disk",
            "network"
        ],
        "modules-right": [
            "custom/layout",
            "tray",
            "custom/notifications",
            "battery",
            "pulseaudio",
            "clock",
            "custom/power"
        ],
        "image": {
            "exec": os.path.expanduser("~/.config/waybar/scripts/fedora-logo-themed.sh"),
            "size": 18,
            "interval": "once",
            "tooltip": False
        },
        "dwl/tags": {
            "num-tags": 9,
            "tag-labels": ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        },
        "dwl/window": {
            "format": "{title}",
            "max-length": 50,
            "rewrite": {
                "(.*) \u2014 Mozilla Firefox": "\uf279 $1",
                "(.*) - Chromium": "\uf268 $1",
                "(.*) - Visual Studio Code": "\uf121 $1",
                "(.*) - zed": "\uf121 $1",
                "(.*) - Discord": "\uf392 $1",
                "(.*) - Steam": "\uf1b6 $1"
            }
        },
        "cpu": {
            "format": "\uf4bc {usage}%",
            "interval": 2,
            "tooltip": True,
            "tooltip-format": "CPU: {usage}%"
        },
        "temperature": {
            "format": "\uf2c9 {temperatureC}\u00b0",
            "interval": 2,
            "tooltip": True,
            "tooltip-format": "CPU Temp: {temperatureC}\u00b0C"
        },
        "memory": {
            "format": "\uf2db {used:0.1f}G",
            "interval": 2,
            "tooltip": True,
            "tooltip-format": "RAM: {used:0.1f}GB / {total:0.1f}GB ({percentage}%)"
        },
        "disk": {
            "format": "\uf0a0 {used}",
            "interval": 30,
            "path": "/",
            "tooltip": True,
            "tooltip-format": "Disk: {used} / {total} ({percentage_used}%)"
        },
        "network": {
            "format-wifi": "\uf019 {bandwidthDownBytes}  \uf093 {bandwidthUpBytes}",
            "format-ethernet": "\uf019 {bandwidthDownBytes}  \uf093 {bandwidthUpBytes}",
            "format-disconnected": "\uf0ac Offline",
            "interval": 2,
            "tooltip": True,
            "tooltip-format-wifi": "WiFi: {essid} ({signalStrength}%)\nDown: {bandwidthDownBits}\nUp: {bandwidthUpBits}",
            "tooltip-format-ethernet": "Ethernet: {ifname}\nDown: {bandwidthDownBits}\nUp: {bandwidthUpBits}"
        },
        "custom/layout": {
            "exec": os.path.expanduser("~/.config/mango/bin/layout-switcher.sh"),
            "interval": 1,
            "return-type": "json",
            "on-click": f"python3 {os.path.expanduser('~/.config/mango/bin/layout-picker.py')}",
            "tooltip": True
        },
        "tray": {
            "icon-size": 16,
            "spacing": 8,
            "show-passive-items": True
        },
        "custom/notifications": {
            "format": "{}",
            "exec": os.path.expanduser("~/.config/waybar/scripts/notifications.sh"),
            "interval": 2,
            "return-type": "json",
            "on-click": "makoctl dismiss --all",
            "on-click-right": "makoctl restore"
        },
        "battery": {
            "states": {
                "warning": 30,
                "critical": 15
            },
            "format": "{icon} {capacity}%",
            "format-icons": ["\uf244", "\uf243", "\uf242", "\uf241", "\uf240"],
            "format-charging": "\uf0e7 {capacity}%",
            "format-plugged": "\uf1e6 {capacity}%",
            "tooltip": True,
            "tooltip-format": "{timeTo} {capacity}%"
        },
        "pulseaudio": {
            "format": "{icon} {volume}%",
            "format-muted": "\uf2e2 Muted",
            "format-icons": {
                "default": ["\uf026", "\uf027", "\uf028"]
            },
            "on-click": "pavucontrol",
            "on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +5%",
            "on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -5%",
            "tooltip": True,
            "tooltip-format": "{desc}"
        },
        "clock": {
            "format": "{:%I:%M %p %a, %b %d}",
            "tooltip": True,
            "tooltip-format": "<tt>{calendar}</tt>",
            "calendar": {
                "mode": "month",
                "weeks-pos": "right",
                "on-scroll": 1,
                "format": {
                    "months": "<span color='#d79921'><b>{}</b></span>",
                    "weekdays": "<span color='#d79921'><b>{}</b></span>",
                    "today": "<span color='#b8bb26'><b>{}</b></span>"
                }
            }
        },
        "custom/power": {
            "format": "\uf011",
            "tooltip": "Session Menu",
            "on-click": f"python3 {os.path.expanduser('~/.config/waybar/scripts/logout-menu.py')}"
        }
    }
    
    if main_outputs:
        main_bar["output"] = main_outputs
    
    bars.append(main_bar)
    
    # Vertical bar for HDMI-A-1
    if 'HDMI-A-1' in connected:
        bars.append({
            "output": "HDMI-A-1",
            "layer": "top",
            "position": "top",
            "height": 36,
            "margin-top": 7,
            "margin-left": 50,
            "margin-right": 50,
            "spacing": 6,
            "modules-left": [
                "image#fedora",
                "dwl/tags#vertical"
            ],
            "modules-center": [],
            "modules-right": [
                "clock#vertical",
                "custom/power#vertical"
            ],
            "image#fedora": {
                "exec": os.path.expanduser("~/.config/waybar/scripts/fedora-logo-themed.sh"),
                "size": 18,
                "interval": "once",
                "tooltip": False
            },
            "dwl/tags#vertical": {
                "num-tags": 9,
                "tag-labels": ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
            },
            "clock#vertical": {
                "format": "{:%I:%M %p}",
                "tooltip": True,
                "tooltip-format": "<tt>{calendar}</tt>",
                "calendar": {
                    "mode": "month",
                    "weeks-pos": "right",
                    "on-scroll": 1,
                    "format": {
                        "months": "<span color='#d79921'><b>{}</b></span>",
                        "weekdays": "<span color='#d79921'><b>{}</b></span>",
                        "today": "<span color='#b8bb26'><b>{}</b></span>"
                    }
                }
            },
            "custom/power#vertical": {
                "format": "\uf011",
                "tooltip": "Session Menu",
                "on-click": f"python3 {os.path.expanduser('~/.config/waybar/scripts/logout-menu.py')}"
            }
        })
    
    return json.dumps(bars, indent=4)

if __name__ == "__main__":
    config = generate_config()
    print(config)
