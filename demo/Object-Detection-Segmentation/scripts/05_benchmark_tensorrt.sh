#!/usr/bin/env bash
set -e

export PATH=/usr/src/tensorrt/bin:$PATH

mkdir -p logs results

run_benchmark () {
    NAME=$1
    ENGINE=$2
    LOG=$3

    if [ ! -f "$ENGINE" ]; then
        echo "Skipping $NAME because engine not found: $ENGINE"
        return
    fi

    echo "===== Benchmarking $NAME ====="

    trtexec \
      --loadEngine="$ENGINE" \
      --warmUp=500 \
      --duration=30 \
      --iterations=1000 \
      --useCudaGraph \
      2>&1 | tee "$LOG"
}

run_benchmark "Detection FP32" \
  "engines/fp32/yolov8n_fp32.engine" \
  "logs/trtexec_detection_fp32.log"

run_benchmark "Detection FP16" \
  "engines/fp16/yolov8n_fp16.engine" \
  "logs/trtexec_detection_fp16.log"

run_benchmark "Detection INT8" \
  "engines/int8/yolov8n_int8.engine" \
  "logs/trtexec_detection_int8.log"

run_benchmark "Segmentation FP32" \
  "engines/fp32/yolov8n_seg_fp32.engine" \
  "logs/trtexec_segmentation_fp32.log"

run_benchmark "Segmentation FP16" \
  "engines/fp16/yolov8n_seg_fp16.engine" \
  "logs/trtexec_segmentation_fp16.log"

run_benchmark "Segmentation INT8" \
  "engines/int8/yolov8n_seg_int8.engine" \
  "logs/trtexec_segmentation_int8.log"

echo "Benchmarking complete."