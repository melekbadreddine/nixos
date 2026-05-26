#!/bin/bash
# Toggle script for DualSense Edge touchpad
# Can be used with a keybind in Mango

PIDFILE="/tmp/dualsense-touchpad-disabler.pid"

if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Stopping DualSense touchpad disabler..."
        kill "$PID"
        rm -f "$PIDFILE"
        notify-send "DualSense" "Touchpad mouse enabled" 2>/dev/null || echo "Touchpad mouse enabled"
    else
        rm -f "$PIDFILE"
        echo "Starting DualSense touchpad disabler..."
        ~/.config/mango/bin/disable-dualsense-touchpad.py &
        echo $! > "$PIDFILE"
        notify-send "DualSense" "Touchpad mouse disabled" 2>/dev/null || echo "Touchpad mouse disabled"
    fi
else
    echo "Starting DualSense touchpad disabler..."
    ~/.config/mango/bin/disable-dualsense-touchpad.py &
    echo $! > "$PIDFILE"
    notify-send "DualSense" "Touchpad mouse disabled" 2>/dev/null || echo "Touchpad mouse disabled"
fi
