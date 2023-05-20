import base64
from flask import Flask, request
from moviepy.editor import *
import sys
import time
import werkzeug
sys.path.append(r'D:\FYP APP\STSL - APP\stsl\backend\Processing')
import Processing

app = Flask(__name__)


@app.get("/")
async def root():
    return {"FLASK": "Upload to Local Server"}


@app.route('/uploadSpeech', methods=['POST'])
def uplaodSpeech():
    if(request.method == 'POST'):
        start_time = time.time()
        skeletonPose_string = "No Skeleton"
        isAudio = request.form.get('isAudio') == 'true'
        isText = request.form.get('isText') == 'true'
        isPose = request.form.get('isPose') == 'true'
        text = request.form.get('text')
        audio = request.files.get('audio')
        if audio:
            filename = werkzeug.utils.secure_filename(audio.filename)
            audio.save(rf"D:\FYP APP\STSL - APP\stsl\backend\Data\{filename}")
        print(f"isAudio = {isAudio}, isText = {isText}, isPose = {isPose}, Text = {text}")
        sentence, words_not_found = Processing.processing(text, isAudio, isText, isPose)
        try:
            with open(r"D:\FYP APP\STSL - APP\stsl\backend\Data\Sign.mp4", "rb") as videoFile:
                humanPose = base64.b64encode(videoFile.read())
            humanPose_string = str(humanPose)
            l = list(humanPose_string)
            del(l[0], l[0], l[-1])
            humanPose_string = "".join(l)
        except OSError:
            humanPose_string = "No Pose Could be made"

        if isPose:
            try:
                with open(r"D:\FYP APP\STSL - APP\stsl\backend\Data\Pose.mp4", "rb") as videoFile:
                    skeletonPose = base64.b64encode(videoFile.read())
                skeletonPose_string = str(skeletonPose)
                l = list(skeletonPose_string)
                del(l[0], l[0], l[-1])
                skeletonPose_string = "".join(l)
            except OSError:
                skeletonPose_string = "No Skeleton"
        try:
            os.remove(r"D:\FYP APP\STSL - APP\stsl\backend\Data\audio.wav")
        except OSError:
            print("File Not Found")
        try:
            os.remove(r"D:\FYP APP\STSL - APP\stsl\backend\Data\Sign.mp4")
        except OSError:
            print("File Not Found")
        try:
            os.remove(r"D:\FYP APP\STSL - APP\stsl\backend\Data\Pose.mp4")
        except OSError:
            print("File Not Found")
        
        print("\n ---------------------------\nAll Done, Returning\n ---------------------------\n")
        elapsed_time = time.time() - start_time
        print(f"Total Response Time is: {elapsed_time}\n")
        return ({"humanPose" : humanPose_string, 
                 "skeletonPose" : skeletonPose_string, 
                 "sentence": sentence, 
                 "words_not_found": words_not_found})

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug = True, port=4000)
