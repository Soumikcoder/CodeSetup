#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="/home/soumik/Pictures/active_wallpaer"

# Log file for debugging
LOG_FILE="$HOME/wallpaper_script.log"

# Function to log messages
log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Start script logging
log "Starting wallpaper script."

# Check if the directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    log "Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# Find all image files in the directory
shopt -s nullglob
images=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,bmp})
shopt -u nullglob

# Check if there are any images in the directory
if [ ${#images[@]} -eq 0 ]; then
    log "No images found in $WALLPAPER_DIR."
    exit 1
fi

# Filter out non-existing files due to shell globbing
valid_images=()
for img in "${images[@]}"; do
    [ -f "$img" ] && valid_images+=("$img")
done

# Check if there are valid images after filtering
if [ ${#valid_images[@]} -eq 0 ]; then
    log "No valid images found in $WALLPAPER_DIR."
    exit 1
fi

# Select a random image
RANDOM_IMAGE=$(printf "%s\n" "${valid_images[RANDOM % ${#valid_images[@]}]}")

# Set the selected image as the wallpaper
if gsettings set org.cinnamon.desktop.background picture-uri "file://$RANDOM_IMAGE"; then
    log "Wallpaper set to $RANDOM_IMAGE"
    echo "Wallpaper set to $RANDOM_IMAGE"
else
    log "Failed to set wallpaper to $RANDOM_IMAGE"
    echo "Failed to set wallpaper to $RANDOM_IMAGE"
    exit 1
fi
