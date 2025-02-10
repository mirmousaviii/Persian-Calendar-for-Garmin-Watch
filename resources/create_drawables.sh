#!/bin/bash

# Default sizes for -a (all)
default_sizes=(
  "30x30"
  "35x35"
  "36x36"
  "40x33"
  "40x40"
  "54x54"
  "56x56"
  "60x60"
  "61x61"
  "65x65"
  "70x70"
)

# Source template directory
TEMPLATE_DIR="template"

# Function to display help
show_help() {
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  -s SIZE, --size SIZE   Create only the directory for the specified icon size (e.g., '60x60')"
  echo "  -a, --all              Create all default directories and resize all icons"
  echo "  -h, --help             Show this help message"
  exit 0
}

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

# Check if the template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "Error: Template directory '$TEMPLATE_DIR' not found!"
  exit 1
fi

# Parse command-line arguments
selected_size=""
create_all=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -s|--size)
      selected_size="$2"
      shift 2
      ;;
    -a|--all)
      create_all=true
      shift
      ;;
    -h|--help)
      show_help
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      ;;
  esac
done

# Validate input
if [[ -z "$selected_size" && "$create_all" == false ]]; then
  echo "Error: You must specify either -s SIZE or -a (all)."
  show_help
fi

# If -a is selected, use default_sizes
if [[ "$create_all" == true ]]; then
  sizes=("${default_sizes[@]}")
else
  sizes=("$selected_size")
fi

# Create directories, copy template files, and resize images
for size in "${sizes[@]}"; do
  dir="${size}-icon"

  mkdir -p "$dir"
  cp -r "$TEMPLATE_DIR/"* "$dir/"
  echo "Created directory: $dir and copied template contents."

  width=$(echo "$size" | cut -d'x' -f1)
  height=$(echo "$size" | cut -d'x' -f2)

  # Resize the launcher icon
  image_path="$dir/drawables/launcher_icon.png"
  resize_image "$image_path" "$width" "$height"
done

echo "Operation completed successfully!"
