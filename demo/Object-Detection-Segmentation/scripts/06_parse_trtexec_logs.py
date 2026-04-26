from pathlib import Path
import re
import csv

LOG_DIR = Path("logs")
RESULTS_DIR = Path("results")
RESULTS_DIR.mkdir(exist_ok=True)

logs = [
    ("detection", "fp32", LOG_DIR / "trtexec_detection_fp32.log"),
    ("detection", "fp16", LOG_DIR / "trtexec_detection_fp16.log"),
    ("detection", "int8", LOG_DIR / "trtexec_detection_int8.log"),
    ("segmentation", "fp32", LOG_DIR / "trtexec_segmentation_fp32.log"),
    ("segmentation", "fp16", LOG_DIR / "trtexec_segmentation_fp16.log"),
    ("segmentation", "int8", LOG_DIR / "trtexec_segmentation_int8.log"),
]

def extract_metric(text, patterns):
    for pattern in patterns:
        match = re.search(pattern, text, flags=re.IGNORECASE)
        if match:
            return match.group(1)
    return ""

def parse_log(path):
    if not path.exists():
        return {
            "exists": "no",
            "throughput_qps": "",
            "latency_avg_ms": "",
            "latency_median_ms": "",
            "gpu_compute_time_avg_ms": "",
        }

    text = path.read_text(errors="ignore")

    throughput = extract_metric(text, [
        r"Throughput:\s*([0-9.]+)\s*qps",
        r"Throughput:\s*([0-9.]+)",
    ])

    latency_avg = extract_metric(text, [
        r"Latency:\s*min\s*=\s*[0-9.]+\s*ms,\s*max\s*=\s*[0-9.]+\s*ms,\s*mean\s*=\s*([0-9.]+)\s*ms",
        r"Latency.*?mean\s*=\s*([0-9.]+)\s*ms",
    ])

    latency_median = extract_metric(text, [
        r"Latency:.*?median\s*=\s*([0-9.]+)\s*ms",
    ])

    gpu_avg = extract_metric(text, [
        r"GPU Compute Time:\s*min\s*=\s*[0-9.]+\s*ms,\s*max\s*=\s*[0-9.]+\s*ms,\s*mean\s*=\s*([0-9.]+)\s*ms",
        r"GPU Compute Time.*?mean\s*=\s*([0-9.]+)\s*ms",
    ])

    return {
        "exists": "yes",
        "throughput_qps": throughput,
        "latency_avg_ms": latency_avg,
        "latency_median_ms": latency_median,
        "gpu_compute_time_avg_ms": gpu_avg,
    }

rows = []

for task, precision, path in logs:
    data = parse_log(path)
    row = {
        "task": task,
        "precision": precision,
        "log_file": str(path),
        **data,
    }
    rows.append(row)

csv_path = RESULTS_DIR / "benchmark_summary.csv"

with csv_path.open("w", newline="") as f:
    writer = csv.DictWriter(
        f,
        fieldnames=[
            "task",
            "precision",
            "log_file",
            "exists",
            "throughput_qps",
            "latency_avg_ms",
            "latency_median_ms",
            "gpu_compute_time_avg_ms",
        ]
    )
    writer.writeheader()
    writer.writerows(rows)

md_path = RESULTS_DIR / "benchmark_summary.md"

with md_path.open("w") as f:
    f.write("# TensorRT Benchmark Summary\n\n")
    f.write("| Task | Precision | Throughput QPS | Avg Latency ms | Median Latency ms | GPU Compute Avg ms |\n")
    f.write("|---|---:|---:|---:|---:|---:|\n")

    for row in rows:
        f.write(
            f"| {row['task']} | {row['precision']} | "
            f"{row['throughput_qps']} | {row['latency_avg_ms']} | "
            f"{row['latency_median_ms']} | {row['gpu_compute_time_avg_ms']} |\n"
        )

print(f"Saved {csv_path}")
print(f"Saved {md_path}")