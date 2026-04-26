#!/usr/bin/env bash
set -e

echo "===== Jetson Info ====="
cat /etc/nv_tegra_release || true

echo ""
echo "===== Kernel ====="
uname -a

echo ""
echo "===== CUDA ====="
nvcc --version || true

echo ""
echo "===== TensorRT / trtexec ====="
if command -v trtexec >/dev/null 2>&1; then
    echo "trtexec path: $(which trtexec)"
    trtexec --help | head -n 5 || true
elif [ -x /usr/src/tensorrt/bin/trtexec ]; then
    echo "trtexec found at /usr/src/tensorrt/bin/trtexec"
    /usr/src/tensorrt/bin/trtexec --help | head -n 5 || true
    echo "Add to PATH with:"
    echo "echo 'export PATH=/usr/src/tensorrt/bin:\$PATH' >> ~/.bashrc"
else
    echo "trtexec not found"
fi

echo ""
echo "===== TensorRT packages ====="
dpkg -l | grep -i nvinfer || true

echo ""
echo "===== Python ====="
python3 --version

echo ""
echo "===== Disk ====="
df -h

echo ""
echo "===== Memory ====="
free -h

echo ""
echo "===== Power Mode ====="
sudo nvpmodel -q || true

echo ""
echo "===== Done ====="