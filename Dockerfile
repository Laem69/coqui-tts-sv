# ---------- Dockerfile ----------
FROM arm64v8/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1) Installera systemberoenden inklusive libsndfile1 och verktyg för att hämta Python-hjul
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

# 2) Uppgradera pip (valfritt men rekommenderat för senaste wheel-stöd)
RUN pip3 install --no-cache-dir --upgrade pip setuptools

# 3) Installera en Torch-wheel som är byggd för ARM64 (CPU-only). 
#    Vi använder PyTorch-sajtens aarch64-index för CPU-hjul:
RUN pip3 install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/torch_stable.html

# 4) Installera Coqui TTS + Flask + flask-cors
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors

# 5) Kopiera in startskriptet (start.sh) och gör det exekverbart
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 6) Exponera den port som tts-server kommer att lyssna på
EXPOSE 5002

# 7) Starta start.sh när containern körs
CMD ["/app/start.sh"]
# ---------- Slut på Dockerfile ----------
