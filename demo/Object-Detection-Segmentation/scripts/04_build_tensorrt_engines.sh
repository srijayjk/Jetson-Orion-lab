#!/usr/bin/env bash
set -e

export PATH=/usr/src/tensorrt/bin:$PATH

mkdir -p engines/fp32 engines/fp16 engines/int8 logs

DET_ONNX="models/detection/yolov8n.onnx"
SEG_ONNX="models/segmentation/yolov8n-seg.onnx"

if [ ! -f "$DET_ONNX" ]; then
    echo "Missing detection ONNX: $DET_ONNX"
    exit 1
fi

if [ ! -f "$SEG_ONNX" ]; then
    echo "Missing segmentation ONNX: $SEG_ONNX"
    exit 1
fi

echo "===== Building Detection FP32 ====="
trtexec \
  --onnx="$DET_ONNX" \
  --saveEngine=engines/fp32/yolov8n_fp32.engine \
  --memPoolSize=workspace:2048 \
  --skipInference \
  2>&1 | tee logs/build_detection_fp32.log

echo "===== Building Detection FP16 ====="
trtexec \
  --onnx="$DET_ONNX" \
  --saveEngine=engines/fp16/yolov8n_fp16.engine \
  --fp16 \
  --memPoolSize=workspace:2048 \
  --skipInference \
  2>&1 | tee logs/build_detection_fp16.log

echo "===== Building Detection INT8 exploratory ====="
trtexec \
  --onnx="$DET_ONNX" \
  --saveEngine=engines/int8/yolov8n_int8.engine \
  --int8 \
  --memPoolSize=workspace:2048 \
  --skipInference \
  2>&1 | tee logs/build_detection_int8.log || true

echo "===== Building Segmentation FP32 ====="
trtexec \
  --onnx="$SEG_ONNX" \
  --saveEngine=engines/fp32/yolov8n_seg_fp32.engine \
  --memPoolSize=workspace:2048 \
  --skipInference \
  2>&1 | tee logs/build_segmentation_fp32.log

echo "===== Building Segmentation FP16 ====="
trtexec \
  --onnx="$SEG_ONNX" \
  --saveEngine=engines/fp16/yolov8n_seg_fp16.engine \
  --fp16 \
  --memPoolSize=workspace:2048 \
  --skipInference \
  2>&1 | tee logs/build_segmentation_fp16.log

echo "===== Building Segmentation INT8 exploratory ====="
trtexec \
  --onnx="$SEG_ONNX" \
  --saveEngine=engines/int8/yolov8n_seg_int8.engine \
  --int8 \
  --memPoolSize=workspace:2048 \
  --skipInference \
  2>&1 | tee logs/build_segmentation_int8.log || true

echo "Engine build complete."