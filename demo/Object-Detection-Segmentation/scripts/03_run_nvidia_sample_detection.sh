#!/usr/bin/env bash
set -e

INPUT_DIR=${1:-assets/nvidia_samples/images}
OUTPUT_DIR=${2:-results/nvidia_samples/detection}
LOG_FILE=${3:-logs/nvidia_samples_detection.log}

mkdir -p "$OUTPUT_DIR" logs
: > "$LOG_FILE"

for img in "$INPUT_DIR"/*.jpg "$INPUT_DIR"/*.png; do
    [ -f "$img" ] || continue

    name=$(basename "$img")
    echo "Processing detection: $name" | tee -a "$LOG_FILE"

    detectnet \
      --network=ssd-mobilenet-v2 \
      --headless \
      "file://$(realpath "$img")" \
      "file://$(realpath -m "$OUTPUT_DIR/$name")" \
      2>&1 | tee -a "$LOG_FILE"
done

echo "NVIDIA sample detection complete."