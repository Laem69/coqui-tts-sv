# ---------- Dockerfile ----------
FROM arm64v8/ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 1) Installera systemberoenden
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      python3-venv \
      libsndfile1 \
      ffmpeg \
      git \
      wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2) Uppgradera pip, setuptools och wheel
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# 3) Installera en ARM64-kompatibel Torch (CPU-only)
RUN pip3 install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/torch_stable.html

# 4) Installera Coqui TTS + Flask + Flask-CORS
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors

# 5) Kopiera in startskript och gör det exekverbart
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 6) Exponera port 5002 för tts-servern
EXPOSE 5002

# 7) Kör start.sh när containern startar
CMD ["/app/start.sh"]
# ---------- Slut på Dockerfile ----------
