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

# 2) Uppgradera pip så att vi kan hämta hjul
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel :contentReference[oaicite:3]{index=3}

# 3) Installera en Torch-wheel byggd för ARM64 (CPU-only)
RUN pip3 install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/torch_stable.html :contentReference[oaicite:4]{index=4}

# 4) Installera Coqui TTS + Flask + Flask-CORS
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors :contentReference[oaicite:5]{index=5}

# 5) Kopiera och gör 'start.sh' exekverbar
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 6) Utgå från port 5002 (tts-server)
EXPOSE 5002

# 7) När containern körs, starta start.sh
CMD ["/app/start.sh"]
# ---------- Slut på Dockerfile ----------
