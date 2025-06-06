# ---------- Dockerfile ----------
#
# 1) Välj Ubuntu 22.04 ARM64 (Raspberry Pi 5-kompatibel)
FROM arm64v8/ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 2) Installera alla system- och utvecklingspaket som TTS kan behöva
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      # Grundläggande byggverktyg och Python-dev
      build-essential \
      cmake \
      python3 \
      python3-pip \
      python3-venv \
      python3-dev \
      git \
      wget \
      # Ljudbibliotek (libsndfile, PortAudio, ALSA, JACK, PulseAudio)
      libsndfile1 \
      libsndfile1-dev \
      ffmpeg \
      libasound2 \
      libasound2-dev \
      libjack-jackd2-0 \
      libjack-jackd2-dev \
      portaudio19-dev \
      libportaudio2 \
      libpulse-dev \
      # Matematisk acceleration (BLAS/LAPACK) 
      libblas-dev \
      liblapack-dev \
      libatlas-base-dev \
      # SSL/FFI för vissa Python-paket
      libssl-dev \
      libffi-dev \
      # Bildbibliotek (i fall TTS eller dess beroenden behöver dem)
      libjpeg-dev \
      libpng-dev \
      libfreetype6-dev \
      # XML/kompression/SQLite etc. för bredast Python-stöd
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

# 3) Uppgradera pip, setuptools och wheel
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# 4) För-installera NumPy och Cython, så att TTS:s C-extensioner kan kompileras
RUN pip3 install --no-cache-dir numpy Cython

# 5) Installera PyTorch (CPU-only) för ARM64 via PyTorchs officiella index
RUN pip3 install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/torch_stable.html

# 6) Slutligen: Installera Coqui TTS 0.12.3 + Flask + Flask-CORS 
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors

# 7) Kopiera in startskriptet och gör det körbart
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 8) Exponera TTS-serverns port
EXPOSE 5002

# 9) Kör start.sh när containern startar
CMD ["/app/start.sh"]
# ---------- Slut på Dockerfile ----------
