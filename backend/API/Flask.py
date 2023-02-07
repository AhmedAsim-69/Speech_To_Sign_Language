from flask import Flask, request, jsonify
import werkzeug

app = Flask(__name__)

@app.get("/")
async def root():
    return {"FLASK": "Upload to Local Server"}

@app.route('/upload', methods = ['POST'])
def uplaod():
    if(request.method == 'POST'):
        speech = request.files['speech']
        filename = werkzeug.utils.secure_filename(speech.filename)
        speech.save('./audio/'+filename)
        return jsonify({"message": "File uploaded successfully"})

if __name__ == "__main__":
    app.run(debug = True, port = 4000)
