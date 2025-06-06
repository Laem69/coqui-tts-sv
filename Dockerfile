# ---------- Dockerfile ----------

# 1) Basbild (ARM64 Ubuntu 22.04)
FROM arm64v8/ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 2) Installera systemberoenden inkl. libsndfile1, ffmpeg, git och wget
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

# 3) Uppgradera pip, setuptools och wheel (för att få bästa hjul‐stöd)
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel 

# 4) Installera en Torch‐wheel byggd för ARM64 (CPU‐only)
#    (Använder PyTorchs officiella aarch64‐index)
RUN pip3 install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/torch_stable.html 

# 5) Installera Coqui TTS + Flask + Flask‐CORS
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors :contentReference[oaicite:5]{index=5}

# 6) Kopiera in startskriptet och ge exekveringsrätt
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 7) Exponera den port (5002) som tts‐servern lyssnar på
EXPOSE 5002

# 8) När containern körs, kör start.sh
CMD ["/app/start.sh"]

# ---------- Slut på Dockerfile ----------
