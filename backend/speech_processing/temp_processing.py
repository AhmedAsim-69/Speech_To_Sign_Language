"""
Created on Sat Oct 22 15:52:00 2022

@author: ahmed
"""

from moviepy.editor import *
from urduhack.models.lemmatizer import lemmatizer
from nltk.tokenize import word_tokenize
import speech_recognition as sr
from googletrans import Translator
from translate import Translator as tTranslator
from pydub import AudioSegment

def takecommand(*args):
    r = sr.Recognizer()
    # read the input file
    AudioSegment.converter = r'D:\UNIVERSITY Stuff\FYP - Work\ffmpeg\bin\ffmpeg.exe'
    sound = AudioSegment.from_file(r'D:\FYP APP\STSL - APP\stsl\backend\API\audio.m4a', format='m4a')

    # export the output file
    sound.export(r'D:\FYP APP\STSL - APP\stsl\backend\API\audio.wav', format='wav')
    try:
        print("Recognizing the speech input.....")
        if args:
            # translator = tTranslator(to_lang = 'en-US')
            translator = tTranslator(to_lang = 'ur-PK')
            temp = translator.translate(args[0])
        else:
            hello = sr.AudioFile(r'D:\FYP APP\STSL - APP\stsl\backend\API\audio.wav')
            with hello as source:
                audio1 = r.record(source)
            temp = r.recognize_google(audio1, language = 'ur-PK')
        print("\n-----------------------------------------")
        print(f"The User said: {temp}.")
        print("-----------------------------------------\n")
    except Exception as e:
        print("\nPlease repeat the sentence \n", e)
        return "None"
    return temp

def lemitize_str(STRING):
    """Function printing python version."""

    lemme_str = ""
    temp = lemmatizer.lemma_lookup(STRING)
    for t in temp:
        lemme_str += t[1] + " "
    return lemme_str

def videoFormation(sentence):
    clip0 = VideoFileClip(
        r"D:\UNIVERSITY Stuff\FYP - Work\Dataset Lemmatized\40.mp4")
    final = clip0.subclip(0, 0)
    words_found = []
    words_not_found = []
    isEmpty = True
    file_found = False
    l  = len(sentence)
    skip = 0
    for i in range(l, 0, -1): #9
        for j in range(len(sentence)):
            start_index = l - i
            end_index = l - j
            if skip > 0:
                skip = skip - 1
                break
            if(start_index < end_index):
                file_name = " ".join(sentence[start_index : end_index])
                if os.path.isfile(fr"D:\UNIVERSITY Stuff\FYP - Work\Dataset Not Lemmatized\{file_name + '.mp4'}"):
                    skip = (end_index) - (start_index) - 1                     
                    clip = VideoFileClip(fr"D:\UNIVERSITY Stuff\FYP - Work\Dataset Not Lemmatized\{file_name + '.mp4'}")
                    final = concatenate_videoclips([final, clip])
                    words_found.append(file_name)
                    isEmpty = False
                    file_found = True
                    break

    if not file_found:
        print("No matching file found.")
    else:
        print("Output video file created with the following words: ", words_found)
   
    for x in sentence:
        if x not in words_found:
            words_not_found.append(x)

    if(isEmpty == False):
        final.write_videofile(r"D:\FYP APP\STSL - APP\stsl\backend\API\merged.mp4")
    return[", ".join(words_found), ", ".join(words_not_found)]


def processing(*args):
    translator = Translator()

    print("The text is being translated into 'Urdu' Language.\n")
    to_lang = 'ur'

    if args:
        print(f"args = {args}")
        text_to_translate = translator.translate(takecommand(args[0]), dest=to_lang)
    else:
        text_to_translate = translator.translate(takecommand(), dest=to_lang)
        print("NOT ARGS")

    text = text_to_translate.text
    print("Urdu Translated sentence is: ", text)

    urdu_stopwords = ['آئی', 'آئے', 'آخر', 'آش', 'آًب', 'آٹھ', 'آیب', 'اخبزت', 'اختتبم', 'ادھر', 'ارد', 'اردگرد', 'ارکبى', 'اش', 'اضتعوبل', 'اضتعوبلات', 'اضطرذ', 'اضکب', 'اضکی', 'اضکے', 'اطراف', 'اغیب', 'افراد', 'الگ', 'اور', 'اوًچب', 'اوًچبئی', 'اوًچی', 'اوًچے', 'اى', 'اًذر', 'اٹھبًب', 'اپٌب', 'اپٌے', 'اچھب', 'اچھی', 'اچھے', 'اکثر', 'اکٹھب', 'اکٹھی', 'اکٹھے', 'اکیلا', 'اکیلی', 'اکیلے', 'اگرچہ', 'اہن', 'ایطے', 'تب', 'تبزٍ', 'تت', 'تر', 'ترتیت', 'تریي', 'تعذاد', 'تن', 'تو', 'توبم', 'توہیں', 'تٌہب', 'تک', 'تھب', 'تھوڑا', 'تھوڑی', 'تھوڑے', 'تھی', 'تھے', 'تیي', 'ثب', 'ثبری', 'ثبرے', 'ثبعث', 'ثبلا', 'ثبلترتیت', 'ثبہر', 'ثدبئے', 'ثرآں', 'ثراں', 'ثرش', 'ثعذ', 'ثغیر', 'ثلٌذ', 'ثلکہ', 'ثٌب', 'ثٌبرہب', 'ثٌبرہی', 'ثٌبرہے', 'ثٌبًب', 'ثٌذ', 'ثٌذکرو', 'ثٌذکرًب', 'ثٌذی', 'ثڑا', 'ثڑی', 'ثڑے', 'ثھر', 'ثھرا', 'ثھرپور', 'ثھی', 'ثہت', 'ثہتر', 'ثہتری', 'ثہتریي', 'ثیچ', 'خب', 'خبر', 'خبهوظ', 'خبًب', 'خبًتب', 'خبًتی', 'خبًتے', 'خبًٌب', 'ختن', 'خجکہ', 'خص', 'خططرذ', 'خلذی', 'خو', 'خواى', 'خوًہی', 'خوکہ', 'خٌبة', 'خگہ', 'خگہوں', 'خگہیں', 'خیطب', 'خیطبکہ', 'در', 'درخبت', 'درخہ', 'درخے', 'درزقیقت', 'درضت', 'دش', 'دفعہ', 'دلچطپ', 'دلچطپی', 'دلچطپیبں', 'دو', 'دور', 'دورى', 'دوضرا', 'دوضروں', 'دوضری', 'دوضرے', 'دوًوں', 'دکھبئیں', 'دکھبتب', 'دکھبتی', 'دکھبتے', 'دکھبو', 'دکھبًب', 'دی', 'دیب', 'دیتب', 'دیتی', 'دیتے', 'دیر', 'دیٌب', 'دیکھو', 'دیکھٌب', 'دیکھی', 'دیکھیں', 'دے', 'راضتوں', 'راضتہ', 'راضتے', 'رریعہ', 'رریعے', 'رکي', 'رکھ', 'رکھب', 'رکھتی', 'رکھتے', 'رکھی', 'رکھے', 'رہب', 'رہی', 'رہے', 'زبصل', 'زبضر', 'زبل', 'زبلات', 'زبلیہ', 'زصوں', 'زصہ', 'زصے', 'زقبئق', 'زقیتیں', 'زقیقت', 'زکن', 'زکویہ', 'زیبدٍ', 'صبف', 'صسیر', 'صفر', 'صورت', 'صورتسبل', 'صورتوں', 'صورتیں', 'ضبت', 'ضبدٍ', 'ضبرا', 'ضبرے', 'ضبل', 'ضبلوں', 'ضت', 'ضرور', 'ضرورت', 'ضروری', 'ضلطلہ', 'ضوچ', 'ضوچب', 'ضوچتب', 'ضوچتی', 'ضوچتے', 'ضوچو', 'ضوچٌب', 'ضوچی', 'ضوچیں', 'ضکب', 'ضکتب', 'ضکتی', 'ضکتے', 'ضکٌب', 'ضکی', 'ضکے', 'ضیذھب', 'ضیذھی',
                    "ہوں", "ہی", "ہیں", 'نے', 'کا', 'کی', 'ک', 'ہونا', 'ہوں', 'ضیذھے', 'ضیکٌڈ', 'ضے', 'طب', 'طرف', 'طریق', 'طریقوں', 'طریقہ', 'طریقے', 'طور', 'طورپر', 'ظبہر', 'عذد', 'عظین', 'علاقوں', 'علاقہ', 'علاقے', 'علاوٍ', 'عووهی', 'غبیذ', 'غخص', 'غذ', 'غروع', 'غروعبت', 'غے', 'فرد', 'فی', 'قجل', 'قجیلہ', 'قطن', 'لئے', 'لازهی', 'لو', 'لوجب', 'لوجی', 'لوجے', 'لوسبت', 'لوسہ', 'لوگ', 'لوگوں', 'لڑکپي', 'لگتب', 'لگتی', 'لگتے', 'لگی', 'لگیں', 'لگے', 'لی', 'لیب', 'لیٌب', 'لیں', 'لے', 'هتعلق', 'هختلف', 'هسترم', 'هسترهہ', 'هسطوش', 'هسیذ', 'هطئلہ', 'هطئلے', 'هطبئل', 'هطتعول', 'هطلق', 'هعلوم', 'هػتول', 'هلا', 'هوکي', 'هوکٌبت', 'هوکٌہ', 'هٌبضت', 'هڑا', 'هڑًب', 'هڑے', 'هکول', 'هگر', 'هہرثبى', 'هیرا', 'هیری', 'هیرے', 'هیں', 'وار', 'والے', 'ًئی', 'ًئے', 'ًبپطٌذ', 'ًبگسیر', 'ًطجت', 'ًقطہ', 'ًوخواى', 'ًکبلٌب', 'ًکتہ', 'ًہیں', 'ًیب', 'ٹھیک', 'پبئے', 'پبش', 'پبًب', 'پبًچ', 'پر', 'پراًب', 'پل', 'پورا', 'پوچھب', 'پوچھتب', 'پوچھتی', 'پوچھتے', 'پوچھو', 'پوچھوں', 'پوچھٌب', 'پوچھیں', 'پچھلا', 'پھر', 'پہلا', 'پہلی', 'پہلے', 'پہلےضی', 'پیع', 'چبر', 'چبہب', 'چبہٌب', 'چبہے', 'چلا', 'چلو', 'چلیں', 'چلے', 'چکب', 'چکی', 'چکیں', 'چکے', 'چھوٹب', 'چھوٹوں', 'چھوٹی', 'چھوٹے', 'چھہ', 'چیسیں', 'ڈھوًڈا', 'ڈھوًڈلیب', 'ڈھوًڈو', 'ڈھوًڈًب', 'ڈھوًڈی', 'ڈھوًڈیں', 'کئی', 'کئے', 'کب', 'کبفی', 'کبم', 'کت', 'کجھی', 'کر', 'کرا', 'کرتب', 'کرتبہوں', 'کرتی', 'کرتے', 'کررہی', 'کرو', 'کرًب', 'کریں', 'کرے', 'کل', 'کن', 'کوئی', 'کوتر', 'کورا', 'کوروں', 'کورٍ', 'کورے', 'کوطي', 'کوى', 'کوًطب', 'کوًطی', 'کوًطے', 'کھولا', 'کھولو', 'کھولٌب', 'کھولیں', 'کھولے', 'کہ', 'کہب', 'کہتب', 'کہتی', 'کہتے', 'کہو', 'کہوں', 'کہٌب', 'کہی', 'کہیں', 'کہے', 'کی', 'کیب', 'کیطے', 'کیوًکہ', 'کیوں', 'کیے', 'کے', 'گئی', 'گئے', 'گب', 'گرد', 'گروٍ', 'گروپ', 'گروہوں', 'گٌتی', 'گی', 'گیب', 'گے', 'ہر', 'ہن', 'ہو', 'ہوئی', 'ہوئے', 'ہوا', 'ہوبرا', 'ہوبری', 'ہوبرے', 'ہوتی', 'ہوتے', 'ہورہب', 'ہورہی', 'ہورہے', 'ہوضکتب', 'ہوضکتی', 'ہوضکتے', 'ہوًب', 'ہوًی', 'ہوًے', 'ہوچکب', 'ہوچکی', 'ہوچکے', 'ہوگئی', 'ہوگیب', 'ہوں', 'ہی', 'ہے', "ہے؟", 'ہیں', 'ہیں؟', 'یقیٌی', 'یہ', 'یہبں']
    
    TEST_SENTENCE = text
    filtered_sentence = ""

    LEMM_TEST_SENTENCE = (TEST_SENTENCE)
    # word_tokens = word_tokenize(LEMM_TEST_SENTENCE)

    # for w in word_tokens:
    #     if w not in urdu_stopwords:
    #         filtered_sentence += w + " "
    
    print("----------------------------------------")
    print("Lemmatized Sentence is: ", LEMM_TEST_SENTENCE)
    print("----------------------------------------")

    filtered_sentence = word_tokenize(LEMM_TEST_SENTENCE)
    # filtered_sentence = word_tokenize(LEMM_TEST_SENTENCE)
    # filtered_sentence1 = " ".join(filtered_sentence)
    
    print("After removing stopwords, Sentence is: ", filtered_sentence)
    print("----------------------------------------")

    words_found, words_not_found = videoFormation(filtered_sentence)
    
    return[words_found, words_not_found]
