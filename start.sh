#!/bin/bash
# Vänta 1 sekund så att volymer mappas ordentligt
sleep 1

# Starta Coqui TTS-http-servern med rätt modell
exec tts-server \
  --model_name "${MODEL_NAME}" \
  --host "0.0.0.0" \
  --port "5002"
