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

# ---- System + Python dependencies ----
RUN pip install --upgrade pip
RUN pip install torch==2.1.0 torchaudio==2.1.0
RUN pip install flask flask-cors
RUN pip install av julius omegaconf
RUN pip install git+https://github.com/facebookresearch/audiocraft.git#egg=audiocraft --no-deps
RUN pip install xformers==0.0.23.post1


# ---- Start the Flask app ----
CMD ["python", "app.py"]
