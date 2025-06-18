FROM python:3.10-slim

# ---- System dependencies (confirmed compatible) ----
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libavfilter-dev \
    libswscale-dev \
    libswresample-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# ---- Working directory ----
WORKDIR /app

# ---- Copy your app code ----
COPY . .

# ---- Install Python packages ----
RUN pip install torch==2.1.0 torchaudio==2.1.0
RUN pip install flask flask-cors
RUN pip install av==11.0.0
RUN pip install git+https://github.com/facebookresearch/audiocraft.git#egg=audiocraft --no-deps
RUN pip install numpy scipy soundfile einops
RUN pip install Julius
RUN pip install av julius omegaconf


# ---- Start the Flask app ----
CMD ["python", "app.py"]
