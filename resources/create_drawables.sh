#!/bin/bash

# List of directories to create along with their icon sizes
directories=(
  "30x30-icon"
  "35x35-icon"
  "36x36-icon"
  "40x33-icon"
  "40x40-icon"
  "56x56-icon"
  "60x60-icon"
  "61x61-icon"
  "65x65-icon"
  "70x70-icon"
)

# Source template directory
TEMPLATE_DIR="template"

# Check if the template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "Error: Template directory '$TEMPLATE_DIR' not found!"
  exit 1
fi

# Function to resize image using ImageMagick 7
resize_image() {
  local image_path="$1"
  local width="$2"
  local height="$3"

  # Check if the image file exists
  if [ -f "$image_path" ]; then
    echo "Resizing $image_path to ${width}x${height}..."
    magick "$image_path" -resize "${width}x${height}" "$image_path"
  else
    echo "Warning: Image $image_path not found!"
  fi
}

# Create directories, copy template files, and resize images
for dir in "${directories[@]}"; do
  mkdir -p "$dir"
  cp -r "$TEMPLATE_DIR/"* "$dir/"
  echo "Created directory: $dir and copied template contents."

  # Extract icon size from directory name
  size=$(echo "$dir" | grep -oP '\d+x\d+')
  width=$(echo "$size" | cut -d'x' -f1)
  height=$(echo "$size" | cut -d'x' -f2)

  # Resize the launcher icon
  image_path="$dir/drawables/launcher_icon.png"
  resize_image "$image_path" "$width" "$height"
done

echo "All directories created and images resized successfully!"

