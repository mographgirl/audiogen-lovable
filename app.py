from flask import Flask, request, send_file, jsonify
from flask_cors import CORS
from audiocraft.models import AudioGen
import torchaudio, os, uuid, logging

app = Flask(__name__)
CORS(app, origins=["*"])
logging.basicConfig(level=logging.INFO)

model = AudioGen.get_pretrained('facebook/audiogen-medium')

@app.route('/generate-sfx', methods=['POST'])
def generate_sfx():
    data = request.json
    app.logger.info(f"Received payload: {data}")

    label = data.get('label', '').strip()
    duration = data.get('duration', None)

    if not label:
        return jsonify({"error": "No label"}), 400

    try:
        duration = float(duration)
        duration = max(1, min(duration, 20))
    except:
        duration = 5

    model.set_generation_params(duration=duration)
    app.logger.info(f"Generating '{label}' for {duration}s")

    try:
        audio = model.generate([label])[0]
        filename = f"sfx_{uuid.uuid4().hex}.wav"
        os.makedirs("sfx_outputs", exist_ok=True)
        filepath = os.path.join("sfx_outputs", filename)
        torchaudio.save(filepath, audio.cpu(), 16000)
        app.logger.info(f"Saved WAV to {filepath}")
        return send_file(filepath, mimetype="audio/wav")
    except Exception as e:
        app.logger.error(f"Generation error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/')
def home():
    return jsonify({"status": "AudioGen SFX server live"}), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=10000)