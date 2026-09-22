#!/bin/bash
echo "$(date): click received" >> /tmp/wifi-click-debug.log
$HOME/.local/bin/networkmanager_dmenu >> /tmp/wifi-click-debug.log 2>&1
