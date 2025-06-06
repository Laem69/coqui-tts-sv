# ---------- Dockerfile ----------
FROM arm64v8/ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 1) Installera systemberoenden: verktyg för att kompilera, ljudbibliotek, headers etc.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      git \
      wget \
      python3 \
      python3-pip \
      python3-venv \
      python3-dev \
      libsndfile1 \
      libsndfile1-dev \
      ffmpeg \
      libffi-dev \
      libssl-dev \
      libblas-dev \
      liblapack-dev \
      libatlas-base-dev \
      libportaudio2 \
      portaudio19-dev \
      libjpeg-dev \
      libpng-dev \
      libfreetype6-dev \
      libpulse-dev \
      libpq-dev \
      libxml2-dev \
      libxslt1-dev \
      zlib1g-dev \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      libncursesw5-dev \
      xz-utils \
      tk-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2) Uppgradera pip, setuptools och wheel
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# 3) Installera Torch för ARM64 (CPU-only) via PyTorchs aarch64-index
RUN pip3 install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/torch_stable.html

# 4) Installera Coqui TTS 0.12.3 + Flask + Flask-CORS
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors

# 5) Kopiera in ditt startskript och gör det körbart
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 6) Exponera port 5002 (för tts-server)
EXPOSE 5002

# 7) Starta tts-server via start.sh
CMD ["/app/start.sh"]
# ---------- Slut på Dockerfile ----------
