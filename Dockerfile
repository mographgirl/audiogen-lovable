FROM python:3.10-slim

# Install system dependencies first
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libavfilter-dev \
    libswscale-dev \
    libswresample-dev \
    libavformat58 \
    libavcodec58 \
    libavutil56 \
    libavdevice58 \
    libavfilter7 \
    libavresample4 \
    libswscale5 \
    libswresample3 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy code
COPY . .

# Install Python packages
RUN pip install --upgrade pip
RUN pip install torch==2.1.0 torchaudio==2.1.0
RUN pip install flask flask-cors
RUN pip install av==11.0.0
RUN pip install git+https://github.com/facebookresearch/audiocraft.git#egg=audiocraft --no-deps
RUN pip install numpy scipy soundfile einops

# Run app
CMD ["python", "app.py"]
