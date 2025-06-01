# 使用指定的 rocm/pytorch 镜像，包含 ROCm 6.4.1、Python 3.12 和 PyTorch 2.6.0
FROM rocm/pytorch:rocm6.4.1_ubuntu24.04_py3.12_pytorch_release_2.6.0

# 设置工作目录
WORKDIR /dockerx/stable-diffusion-webui

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    libgl1 \
    libglib2.0-0 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 克隆 AUTOMATIC1111 的 Stable Diffusion WebUI 仓库
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git . \
    && git submodule init \
    && git submodule update

# 可选：更新仓库（默认注释掉）
# RUN git pull

# 安装 WebUI 依赖
ENV REQS_FILE="requirements.txt"
RUN pip install -r $REQS_FILE --prefer-binary

# 设置优化的命令行参数，适配 RX 6750 XT
ENV COMMANDLINE_ARGS="--upcast-sampling --opt-channelslast --opt-split-attention --listen --port 7860"

# 暴露 WebUI 的默认端口
EXPOSE 7860

# 启动 WebUI
CMD python launch.py $COMMANDLINE_ARGS
