from datetime import datetime
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from PIL import Image
import pytesseract
import io
import os

app = Flask(__name__)
CORS(app)

# Chemin absolu du dossier 'uploads' où seront stockées les images
UPLOAD_FOLDER = r'C:\Users\baigl\Videos\Parking\img'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/ocr', methods=['POST'])
def ocr():
    try:
        if 'file' not in request.files:
            return "No file part", 400
        file = request.files['file']
        if file.filename == '':
            return "No selected file", 400
        
        # Lire l'image à partir de la requête
        image = Image.open(io.BytesIO(file.read()))
        
        # Utiliser Tesseract pour OCR
        #pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
        pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
        text = pytesseract.image_to_string(image)
        
        # Sauvegarder l'image dans le dossier uploads avec un nom unique
        filename = datetime.now().strftime("%Y%m%d%H%M%S") + '.jpg'
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        image.save(filepath)
        
        return jsonify({"text": text, "image_filename": filename})
    
    except Exception as e:
        return str(e), 500

@app.route('/images', methods=['GET'])
def get_images():
    image_files = []
    for filename in os.listdir(app.config['UPLOAD_FOLDER']):
        if filename.endswith('.jpg') or filename.endswith('.jpeg') or filename.endswith('.png'):
            image_files.append(filename)
    
    return jsonify({"images": image_files})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
