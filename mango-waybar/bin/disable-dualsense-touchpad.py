#!/usr/bin/env python3
"""
Disable DualSense Edge Controller Touchpad-as-Mouse
This script grabs the DualSense Edge touchpad input device to prevent
it from controlling the mouse cursor while playing games.

The script runs continuously in the background, grabbing the device
so that touchpad events don't reach the window system.
"""

import time
import sys
from evdev import InputDevice, list_devices


def find_dualsense_touchpad():
    """Find the DualSense Edge touchpad device."""
    devices = [InputDevice(path) for path in list_devices()]
    for device in devices:
        if "DualSense" in device.name and "Touchpad" in device.name:
            return device
        # Also check for DualShock 4 touchpad (in case it's a DS4)
        if "Sony" in device.name and "Touchpad" in device.name:
            return device
    return None


def main():
    print("DualSense Touchpad Disabler: Starting...")

    # Find the touchpad device
    touchpad = find_dualsense_touchpad()

    if touchpad is None:
        print("DualSense Touchpad Disabler: No DualSense touchpad found.")
        print("Waiting for device to be connected...")

        # Keep polling until device appears
        while touchpad is None:
            time.sleep(2)
            touchpad = find_dualsense_touchpad()

    print(f"DualSense Touchpad Disabler: Found device at {touchpad.path}")
    print(f"  Name: {touchpad.name}")
    print(f"  Phys: {touchpad.phys}")

    try:
        # Grab the device - this prevents other processes from receiving events
        touchpad.grab()
        print("DualSense Touchpad Disabler: Device grabbed successfully!")
        print("Touchpad mouse functionality is now disabled.")
        print("Press Ctrl+C to exit and re-enable touchpad.")

        # Read and discard events forever
        # The grab() call is what actually prevents mouse movement
        # Reading events just keeps the device from being considered idle
        for event in touchpad.read_loop():
            # Just discard events - we don't want them
            pass

    except KeyboardInterrupt:
        print("\nDualSense Touchpad Disabler: Stopping...")
    except PermissionError:
        print(
            f"DualSense Touchpad Disabler: Permission denied accessing {touchpad.path}"
        )
        print("You may need to add your user to the 'input' group:")
        print("  sudo usermod -a -G input $USER")
        print("Then log out and log back in.")
        sys.exit(1)
    except Exception as e:
        print(f"DualSense Touchpad Disabler: Error: {e}")
        sys.exit(1)
    finally:
        try:
            touchpad.ungrab()
            print(
                "DualSense Touchpad Disabler: Device ungrabbed. Touchpad mouse re-enabled."
            )
        except:
            pass


if __name__ == "__main__":
    main()
