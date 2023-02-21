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

@app.route('/uploadSpeech', methods = ['POST'])
def uplaodSpeech():
    if(request.method == 'POST'):
        speech = request.files['speech']
        filename = werkzeug.utils.secure_filename(speech.filename)
        speech.save('D:/FYP APP/STSL - APP/stsl/backend/API/audio/'+filename)
        sentence, words_not_found =  temp_processing.processing() 
        try:
            with open( r"D:\FYP APP\STSL - APP\stsl\backend\API\video\merged.mp4", "rb") as videoFile:
                text_base64 = base64.b64encode(videoFile.read())
            text_base64_string = str(text_base64)
            l = list(text_base64_string)
            del(l[0], l[0], l[-1])
            text_base64_string = "".join(l)
        except OSError:
            text_base64_string = "No Pose Could be made"
        try:    
            os.remove(r"D:\FYP APP\STSL - APP\stsl\backend\API\audio\audio.wav")
            os.remove(r"D:\FYP APP\STSL - APP\stsl\backend\API\video\merged.mp4")
        except OSError:
            print("File Not Found")
        print("\n ---------------------------\nAll Done, Returning\n ---------------------------\n")
        return ({"message": text_base64_string, "sentence": sentence, "words_not_found": words_not_found})

@app.route('/uploadText', methods = ['POST'])
def uplaodText():
    if(request.method == 'POST'):
        speech = request.files['speech']
        filename = werkzeug.utils.secure_filename(speech.filename)
        speech.save('D:/FYP APP/STSL - APP/stsl/backend/API/audio/'+filename)
        sentence, words_not_found =  temp_processing.processing() 
        try:
            with open( r"D:\FYP APP\STSL - APP\stsl\backend\API\video\merged.mp4", "rb") as videoFile:
                text_base64 = base64.b64encode(videoFile.read())
            text_base64_string = str(text_base64)
            l = list(text_base64_string)
            del(l[0], l[0], l[-1])
            text_base64_string = "".join(l)
        except OSError:
            text_base64_string = "No Pose Could be made"
        try:    
            os.remove(r"D:\FYP APP\STSL - APP\stsl\backend\API\audio\audio.wav")
            os.remove(r"D:\FYP APP\STSL - APP\stsl\backend\API\video\merged.mp4")
        except OSError:
            print("File Not Found")
        print("\n ---------------------------\nAll Done, Returning\n ---------------------------\n")
        return ({"message": text_base64_string, "sentence": sentence, "words_not_found": words_not_found})


if __name__ == "__main__":
    app.run(debug = True, port = 4000)
