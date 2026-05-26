#!/bin/bash
# Install script for DualSense Edge touchpad disabler udev rules
# This allows the user to access the DualSense touchpad device without root

echo "Installing DualSense Edge touchpad disabler udev rules..."

# Create the udev rule file
RULES_FILE="/etc/udev/rules.d/72-dualsense-touchpad.rules"

cat << 'EOF' | sudo tee "$RULES_FILE"
# DualSense (PS5) Controller Touchpad - Allow user access to disable mouse functionality
# DualSense Edge Wireless Controller (USB)
SUBSYSTEM=="input", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0df2", ATTR{name}=="*Touchpad*", MODE="0660", TAG+="uaccess"
# DualSense Wireless Controller (USB)
SUBSYSTEM=="input", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", ATTR{name}=="*Touchpad*", MODE="0660", TAG+="uaccess"

# DualSense Edge (Bluetooth) - Bluetooth uses different product ID sometimes
SUBSYSTEM=="input", KERNELS=="*054C:0DF2*", ATTR{name}=="*Touchpad*", MODE="0660", TAG+="uaccess"
# DualSense (Bluetooth)
SUBSYSTEM=="input", KERNELS=="*054C:0CE6*", ATTR{name}=="*Touchpad*", MODE="0660", TAG+="uaccess"

# Also add to input group for good measure
SUBSYSTEM=="input", ATTRS{idVendor}=="054c", ATTR{name}=="*Touchpad*", GROUP="input", MODE="0660"
EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Rules installed to $RULES_FILE"
echo ""
echo "Now you need to:"
echo "1. Add your user to the 'input' group:"
echo "   sudo usermod -a -G input $USER"
echo "2. Log out and log back in for group changes to take effect"
echo "3. The touchpad disabler will start automatically on next login"
