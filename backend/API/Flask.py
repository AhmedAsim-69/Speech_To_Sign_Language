from flask import Flask, request
import werkzeug
from moviepy.editor import *
import base64
import sys
sys.path.append(r'D:\FYP APP\STSL - APP\stsl\backend')
sys.path.append(r'D:\FYP APP\STSL - APP\stsl\backend\API')
sys.path.append(r'D:\FYP APP\STSL - APP\stsl\backend\speech_processing')
import temp_processing

app = Flask(__name__)

@app.get("/")
async def root():
    return {"FLASK": "Upload to Local Server"}

@app.route('/upload', methods = ['POST'])
def uplaod():
    if(request.method == 'POST'):
        speech = request.files['speech']
        filename = werkzeug.utils.secure_filename(speech.filename)
        speech.save('D:/FYP APP/STSL - APP/stsl/backend/API/audio/'+filename)
        sentence, words_not_found =  temp_processing.processing() 
        with open( r"D:\FYP APP\STSL - APP\stsl\backend\API\video\merged.mp4", "rb") as videoFile:
            text_base64 = base64.b64encode(videoFile.read())
        text_base64_string = str(text_base64)
        l = list(text_base64_string)
        del(l[0], l[0], l[-1])
        text_base64_string = "".join(l)
        print("\n ---------------------------\nAll Done, Returning\n ---------------------------\n")
        return ({"message": text_base64_string, "sentence": sentence, "words_not_found": words_not_found})

def stringToBase64(s):
    return base64.b64encode(s.encode('utf-8'))

def base64ToString(b):
    return base64.b64decode(b).decode('utf-8')

if __name__ == "__main__":
    app.run(debug = True, port = 4000)
