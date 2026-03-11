#!/bin/bash

# Check the current status of the service
if systemctl is-active --quiet tailscaled; then
    echo "Tailscale is running. Stopping..."
    sudo systemctl stop tailscaled
    echo "Tailscale stopped."
else
    echo "Tailscale is not running. Starting..."
    sudo systemctl start tailscaled
    echo "Tailscale started."
fi
