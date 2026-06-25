#!/bin/bash

# DEPENDENCIES TO INSTALL VIA PACMAN:
# sudo pacman -S playerctl libnotify curl glib-networking gvfs
#
# DESCRIPTION:
# This script monitors Spotify track and playback status changes via MPRIS/D-Bus,
# handles play/pause triggers cleanly, downloads album art locally, 
# and pushes immediate notifications to SwayNC using body-image hints to avoid round clipping.

# Wait 2 seconds to let the graphical system and SwayNC fully load on boot
sleep 2

# Target folder for saving the current album art image
CACHE_DIR="/tmp/spotify_meta"
mkdir -p "$CACHE_DIR"

# Memory tracking to ensure we drop duplicate notification blocks
LAST_COMBINED_STATE=""

# Listen dynamically to BOTH status changes and URL changes simultaneously
playerctl --player=spotify metadata --format '{{status}}//{{xesam:url}}' --follow 2>/dev/null | while read -r line; do
    
    # Tiny pause to let Spotify fully stabilize its internal D-Bus properties
    sleep 0.05

    # Capture a completely settled snapshot of the player state
    CURRENT_STATUS=$(playerctl --player=spotify status 2>/dev/null)
    CURRENT_URL=$(playerctl --player=spotify metadata xesam:url 2>/dev/null)
    TITLE=$(playerctl --player=spotify metadata title 2>/dev/null)
    ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)
    ART_URL=$(playerctl --player=spotify metadata mpris:artUrl 2>/dev/null)

    # Break loop if critical song information is blank
    if [ -z "$TITLE" ] || [ -z "$CURRENT_URL" ] || [ -z "$CURRENT_STATUS" ]; then
        continue
    fi

    # Unique fingerprint pairing the URL ID and the Playback state
    COMBINED_STATE="${CURRENT_URL}_${CURRENT_STATUS}"

    # Drop the update if this exact combination was handled a millisecond ago
    if [ "$COMBINED_STATE" = "$LAST_COMBINED_STATE" ]; then
        continue
    fi
    LAST_COMBINED_STATE="$COMBINED_STATE"

    # Fallback default strings if Spotify variables report blank values
    [ -z "$ARTIST" ] && ARTIST="Unknown Artist"
    COVER_IMG="$CACHE_DIR/current_cover.png"

    # Fetch fresh artwork only if moving onto a completely new track URL
    if [ ! -f "$COVER_IMG" ] || [ "$(cat "$CACHE_DIR/last_url" 2>/dev/null)" != "$CURRENT_URL" ]; then
        rm -f "$COVER_IMG"
        if [ -n "$ART_URL" ]; then
            curl -s -L -A "Mozilla/5.0 (X11; Linux x86_64)" "$ART_URL" -o "$COVER_IMG"
        fi
        echo "$CURRENT_URL" > "$CACHE_DIR/last_url"
    fi

    # Set up text lines based on playback changes
    if [ "$CURRENT_STATUS" = "Paused" ]; then
        HEADER_TXT="Playback Paused"
        BODY_TXT="$TITLE\nby $ARTIST, paused"
    elif [ "$CURRENT_STATUS" = "Playing" ]; then
        HEADER_TXT="Now Playing"
        BODY_TXT="$TITLE\nby $ARTIST"
    else
        continue
    fi

    # Send notification using our replacement ID (9999) and non-rounded image path hint
    if [ -f "$COVER_IMG" ] && [ -s "$COVER_IMG" ]; then
        notify-send -a "Spotify" -r 9999 --hint=string:image-path:"$COVER_IMG" "$HEADER_TXT" "$BODY_TXT"
    else
        notify-send -a "Spotify" -r 9999 -i spotify "$HEADER_TXT" "$BODY_TXT"
    fi

done

