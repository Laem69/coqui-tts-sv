# ---------- Dockerfile ----------
FROM arm64v8/ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 1) Installera systemberoenden inkl. libsndfile1
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      libsndfile1 \
      ffmpeg \
      git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2) Installera Coqui TTS och tts-server
RUN pip3 install --no-cache-dir TTS==0.12.3 flask flask-cors

# 3) Kopiera in startskriptet och ge exekveringsrätt
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 5002

CMD ["/app/start.sh"]
# ---------- Slut på Dockerfile ----------
