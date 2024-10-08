FROM rocm/rocm-terminal:6.1.2

USER root
WORKDIR /
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y --no-install-recommends \
    python3.11 \
    python3-pip \
    python3.11-dev \
    python3.11-venv \
    python3.11-distutils \
    libgl1 \
    git \
    rocm

RUN git clone https://github.com/HPPinata/horde-worker-reGen.git && \
    cd /horde-worker-reGen && \
    python3.11 -m venv venv && \
    . venv/bin/activate && \
    python -m pip install --upgrade pip && \
    python -m pip install -r /horde-worker-reGen/requirements.txt -U --extra-index-url https://download.pytorch.org/whl/rocm6.1 && \
    python -m pip install opencv-python-headless -U && \
    python -m pip uninstall -y pynvml nvidia-ml-py && \
    python -m pip cache purge

CMD cd /horde-worker-reGen && \
    git pull && \
    . venv/bin/activate && \
    python -m pip install -r requirements.txt -U && \
    python -m pip uninstall -y pynvml nvidia-ml-py && \
    ./horde_worker_regen/amd_go_fast/install_amd_go_fast.sh && \
    python download_models.py $(if [ ! -e bridgeData.yaml ]; then echo -e; fi) && \
    python run_worker.py $(if [ ! -e bridgeData.yaml ]; then echo -e; fi)
