FROM python:3.10-slim

# Install system dependencies
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

# Set working directory
WORKDIR /app

# Copy code
COPY . .

# Install Python packages manually to avoid broken builds
RUN pip install --upgrade pip
RUN pip install torch==2.1.0 torchaudio==2.1.0
RUN pip install flask flask-cors
RUN pip install git+https://github.com/facebookresearch/audiocraft.git#egg=audiocraft --no-deps
RUN pip install numpy scipy soundfile einops

# Run app
CMD ["python", "app.py"]
