#!/usr/bin/env bash
# Notification count for Waybar using mako

COUNT=$(makoctl list 2>/dev/null | jq -r '.data[0] | length' 2>/dev/null)

if [ "$COUNT" = "null" ] || [ -z "$COUNT" ]; then
    COUNT=0
fi

if [ "$COUNT" -gt 0 ]; then
    echo "{\"text\": \" $COUNT\", \"tooltip\": \"$COUNT unread notifications\", \"class\": \"has-notifications\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"No unread notifications\", \"class\": \"no-notifications\"}"
fi
