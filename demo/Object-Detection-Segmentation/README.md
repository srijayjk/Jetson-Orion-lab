# Object Detection and Segmentation on Jetson Orin Nano

This project demonstrates video-based AI inference on NVIDIA Jetson Orin Nano using object detection, semantic segmentation, TensorRT benchmarking, and model optimization techniques.

## Goals

- Run object detection inference on a video file
- Run semantic segmentation inference on a video file
- Benchmark models using TensorRT `trtexec`
- Compare FP32, FP16, and INT8 inference performance
- Explore quantization and pruning/sparsity for edge AI deployment
- Document results in a GitHub portfolio format

## Hardware

- NVIDIA Jetson Orin Nano
- SSH-based development
- No camera required
- Video-file inference only

## Software

- JetPack
- CUDA
- TensorRT
- jetson-inference
- Python
- Docker
- Git

## Demo Pipeline

Input video  
→ Object detection  
→ Segmentation  
→ TensorRT engine generation  
→ FP32 / FP16 / INT8 benchmarking  
→ Benchmark comparison  
→ Optimization analysis

## Results

| Model        | Precision | Latency | FPS | Notes                |
|---           |---:       |---:     |---: |---                   |
| Detection    | FP32      | TBD     | TBD | Baseline             |
| Detection    | FP16      | TBD     | TBD | Faster GPU inference |
| Detection    | INT8      | TBD     | TBD | Quantized            |  
| Segmentation | FP32      | TBD     | TBD | Baseline             |
| Segmentation | FP16      | TBD     | TBD | Faster GPU inference |
| Segmentation | INT8      | TBD     | TBD | Quantized            |

```bash
demo/Object-Detection-Segmentation/
├── README.md
├── assets/
│   ├── videos/
│   │   └── input_video.mp4
│   └── images/
├── models/
│   ├── detection/
│   └── segmentation/
├── engines/
│   ├── fp32/
│   ├── fp16/
│   └── int8/
├── results/
│   ├── detection_output.mp4
│   ├── segmentation_output.mp4
│   ├── benchmark_summary.csv
│   └── benchmark_summary.md
├── logs/
│   ├── detection_video.log
│   ├── segmentation_video.log
│   ├── trtexec_fp32.log
│   ├── trtexec_fp16.log
│   └── trtexec_int8.log
├── scripts/
│   ├── 00_check_jetson.sh
│   ├── 01_run_detection_video.sh
│   ├── 02_run_segmentation_video.sh
│   ├── 03_export_or_prepare_onnx.md
│   ├── 04_build_tensorrt_engines.sh
│   ├── 05_benchmark_tensorrt.sh
│   ├── 06_parse_trtexec_logs.py
│   └── 07_compare_benchmarks.py
└── docs/
    ├── optimization_notes.md
    ├── quantization_notes.md
    ├── pruning_sparsity_notes.md
    └── final_report.md
```