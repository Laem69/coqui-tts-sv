# ---------- Dockerfile ----------

# 1) Basbild: Ubuntu 22.04 ARM64 (aarch64) för Raspberry Pi 5
FROM arm64v8/ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 2) Installera systemberoenden
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

# 3) Uppgradera pip, setuptools och wheel
#    (för att kunna hantera moderna hjulformat)
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel 

# 4) Installera en ARM64-kompatibel Torch (CPU-only) från PyTorchs index
RUN pip3 install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/torch_stable.html 

# 5) Installera Coqui TTS (0.12.3) samt Flask och Flask-CORS
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors :contentReference[oaicite:12]{index=12}

# 6) Kopiera in startskript och gör det körbart
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 7) Exponera port 5002 (tts-servern kommer lyssna här)
EXPOSE 5002

# 8) Kör start.sh vid container-start
CMD ["/app/start.sh"]

# ---------- Slut på Dockerfile ----------
