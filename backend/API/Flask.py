from flask import Flask, request
# , jsonify, send_from_directory, send_file, make_response
import werkzeug
# import jsonpickle
from moviepy.editor import *
import base64
# import json

app = Flask(__name__)

@app.get("/")
async def root():
    return {"FLASK": "Upload to Local Server"}

@app.route('/upload', methods = ['POST'])
def uplaod():
    if(request.method == 'POST'):
        speech = request.files['speech']
        filename = werkzeug.utils.secure_filename(speech.filename)
        print(speech.filename)
        speech.save('D:/FYP APP/STSL - APP/stsl/backend/API/audio/'+filename)
        # return jsonify(messgage = speech)
        # return send_file('D:/FYP APP/STSL - APP/stsl/backend/API/audio/audio.wav')
        with open( r"D:\UNIVERSITY Stuff\FYP - Work\Dataset\500.mp4", "rb") as videoFile:
            text_base64 = base64.b64encode(videoFile.read())
            # text_base64 = stringToBase64(speech.filename)
            print(text_base64)
            file = open("D:/FYP APP/STSL - APP/stsl/backend/API/audio/textTest.txt", "wb") 
            file.write(text_base64)
            file.close()

            # fh = open("video.mp4", "wb")
            # fh.write(base64.b64decode(text_base64))
            # fh.close()

    #     clip0 = VideoFileClip(
    # r"D:\UNIVERSITY Stuff\FYP - Work\Dataset\40.mp4")
    # text = base64.b64encode(clip0)
        # return jsonpickle.encode(clip0)
        text_base64_string = str(text_base64)
        print("----------------------------------------")
        l = list(text_base64_string)
        del(l[0])
        del(l[0])
        del(l[-1])
        text_base64_string = "".join(l)
        print(text_base64_string)
        text_base64_string.replace("b'", "")
        print("----------------------------------------")
        # raw_data = {'message': text_base64}
        # json_data = json.dumps(raw_data, indent=2)
        # return json_data
        return ({"message": text_base64_string})

def stringToBase64(s):
    return base64.b64encode(s.encode('utf-8'))

def base64ToString(b):
    return base64.b64decode(b).decode('utf-8')
if __name__ == "__main__":
    # werkzeug.serving.WSGIRequestHandler.protocol_version = "HTTP/1.1"
    app.run(debug = True, port = 4000)

# from fastapi import FastAPI, requests
# import werkzeug
# import jsonpickle
# from moviepy.editor import *

# app = FastAPI()
# @app.get("/")
# async def root():
#     return {"FLASK": "Upload to Local Server"}

# @app.post('/upload')
# def uplaod():
#     # if(requests.method == 'POST'):
#     speech = requests.files['speech']
#     filename = werkzeug.utils.secure_filename(speech.filename)
#     print(speech.filename)
#     speech.save('D:/FYP APP/STSL - APP/stsl/backend/API/audio/'+filename)
#     #     clip0 = VideoFileClip(
#     # r"D:\UNIVERSITY Stuff\FYP - Work\Dataset\40.mp4")
#     #     return jsonpickle.encode(clip0)
#     return ({"message": "File uploaded successfully"})

# # if __name__ == "__main__":
# #     app.run(debug = True, port = 4000)


# import Rest
# import werkzeug
# import jsonpickle
# from moviepy.editor import *

# app = Flask(__name__)

# @app.get("/")
# async def root():
#     return {"FLASK": "Upload to Local Server"}

# @app.route('/upload', methods = ['POST'])
# def uplaod():
#     if(request.method == 'POST'):
#         speech = request.files['speech']
#         filename = werkzeug.utils.secure_filename(speech.filename)
#         print(speech.filename)
#         speech.save('D:/FYP APP/STSL - APP/stsl/backend/API/audio/'+filename)
#         clip0 = VideoFileClip(
#     r"D:\UNIVERSITY Stuff\FYP - Work\Dataset\40.mp4")
#         return jsonpickle.encode(clip0)
#         # return jsonify({"message": "File uploaded successfully"})

# if __name__ == "__main__":
#     app.run(debug = True, port = 4000)
