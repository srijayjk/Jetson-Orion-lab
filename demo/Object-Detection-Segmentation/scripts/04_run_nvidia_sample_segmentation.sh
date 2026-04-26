#!/usr/bin/env bash
set -e

INPUT_DIR=${1:-assets/nvidia_samples/images}
OUTPUT_DIR=${2:-results/nvidia_samples/segmentation}
LOG_FILE=${3:-logs/nvidia_samples_segmentation.log}

NETWORK=${4:-fcn-resnet18-voc-512x320}

mkdir -p "$OUTPUT_DIR" logs
: > "$LOG_FILE"

for img in "$INPUT_DIR"/*.jpg "$INPUT_DIR"/*.png; do
    [ -f "$img" ] || continue

    name=$(basename "$img")
    echo "Processing segmentation: $name" | tee -a "$LOG_FILE"

    segnet \
      --network="$NETWORK" \
      --headless \
      "file://$(realpath "$img")" \
      "file://$(realpath -m "$OUTPUT_DIR/$name")" \
      2>&1 | tee -a "$LOG_FILE"
done

echo "NVIDIA sample segmentation complete."
