"""
Created on Sat Oct 22 15:52:00 2022

@author: ahmed
"""
from googletrans import Translator
from moviepy.editor import *
from nltk.tokenize import word_tokenize
import speech_recognition as sr
import time
from translate import Translator as tTranslator
import re
import sys
sys.path.append(r'D:\FYP APP\STSL - APP\stsl\backend')
sys.path.append(r'D:\FYP APP\STSL - APP\stsl\backend\API')
sys.path.append(r'D:\FYP APP\STSL - APP\stsl\backend\Processing')
import Pose

def takecommand(text, isAudio, isText):

    r = sr.Recognizer()
    print("\n-----------------------------------------")
    try:
        if isText:
            print("Recognizing the text speech input.....")
            translator = tTranslator(to_lang = 'ur-PK')
            temp = translator.translate(text)
        
        elif isAudio:
            print("Recognizing the audio speech input.....")
            hello = sr.AudioFile(r'D:\FYP APP\STSL - APP\stsl\backend\Data\audio.wav')
            with hello as source:
                audio1 = r.record(source)
            temp = r.recognize_google(audio1, language = 'ur-PK')

        print("\n-----------------------------------------")
        print(f"The translated sentence is: {temp}.")
        print("-----------------------------------------")
    except Exception:
        return "None"
    return temp

def videoFormation(sentence):
    clip0 = VideoFileClip(
        r"D:\UNIVERSITY Stuff\FYP\FYP - Work\DATASET USABLE\40.mp4")
    final = clip0.subclip(0, 0)
    words_found = ""
    words_not_found = []
    isEmpty = True
    l  = len(sentence)
    skip = 0
    print("\n-----------------------------------------")
    for i in range(l, 0, -1): 
        for j in range(len(sentence)):
            start_index = l - i
            end_index = l - j
            if skip > 0:
                skip = skip - 1
                break
            if(start_index < end_index):
                file_name = " ".join(sentence[start_index : end_index])
                print(f"Searching for: {file_name}")
                if os.path.isfile(fr"D:\UNIVERSITY Stuff\FYP\FYP - Work\DATASET USABLE\{file_name + '.mp4'}"):
                    skip = (end_index) - (start_index) - 1                     
                    clip = VideoFileClip(fr"D:\UNIVERSITY Stuff\FYP\FYP - Work\DATASET USABLE\{file_name + '.mp4'}")
                    final = concatenate_videoclips([final, clip])
                    print(f"Sign found")
                    words_found += f"{file_name} "
                    isEmpty = False
                    break
    print("-----------------------------------------")
    
    
    for x in sentence:
        if x not in list(words_found.split(" ")):
            words_not_found.append(x)
    if len(words_not_found) == 0:
        print("\nSign found for all words")
    else:
        print(f"\nNo sign found for: {' '.join(words_not_found)}")
    print("\n-----------------------------------------\n")
    if(isEmpty == False):
        final.write_videofile(r"D:\FYP APP\STSL - APP\stsl\backend\Data\Sign.mp4")
    print(f"\nOutput video file created with the following words: {words_found}\n")
    print("-----------------------------------------")
    print()
    return[" ".join(list(words_found.split(" "))), " ".join(words_not_found)]


def processing(text, isAudio, isText, isPose):
    start_time = time.time()

    translator = Translator()

    print("The text is being translated into 'Urdu' Language.")
    to_lang = 'ur'

    text_to_translate = translator.translate(takecommand(text, isAudio, isText), dest=to_lang)

    text = text_to_translate.text
    text = re.sub(r'[^\w\s]', '', text)

    print("The user said: ", text)

    TEST_SENTENCE = text
    filtered_sentence = ""

    filtered_sentence = word_tokenize(TEST_SENTENCE)
    
    print("----------------------------------------")    
    print("After tokenizing, the sentence is: ", filtered_sentence)
    print("----------------------------------------")

    words_found, words_not_found = videoFormation(filtered_sentence)
    elapsed_time = time.time() - start_time
    print(f"Time Taken to Generate Human Sign Language is: {elapsed_time}\n")
    print("----------------------------------------\n")

    if isPose:
        Pose.plot(r"D:\FYP APP\STSL - APP\stsl\backend\Data\Sign.mp4")
        print("\n----------------------------------------\n")
    
    return[words_found, words_not_found]
