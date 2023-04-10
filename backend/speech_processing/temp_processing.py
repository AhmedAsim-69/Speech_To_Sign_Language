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

def takecommand(*args):
    r = sr.Recognizer()
    try:
        print("Recognizing the speech input.....")
        if args:
            translator = tTranslator(to_lang = 'en-US')
            temp = translator.translate(args[0])
        else:
            hello = sr.AudioFile(r'D:\FYP APP\STSL - APP\stsl\backend\API\audio.wav')
            with hello as source:
                audio1 = r.record(source)
            temp = r.recognize_google(audio1, language = 'ur-IN')
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
    words_found = ""
    words_not_found = ""
    c0 = 0
    c1 = 0
    isEmpty = True
    for x in sentence:
        try:
            clip = VideoFileClip(
                fr"D:\UNIVERSITY Stuff\FYP - Work\Dataset Lemmatized\{x}.mp4")
            final = concatenate_videoclips([final, clip])
            if c0 == 0:
                words_found += x
                c0 = 1
            else:
                words_found += " , " + x
            isEmpty = False
        except OSError:
            if c1 == 0:
                words_not_found += x
                c1 = 1
            else:
                words_not_found += " , " + x 
            continue
    if(words_found == "" and words_not_found == ""):
        words_found = " No Words Found "
        words_not_found = "No Words Found  "

    if(isEmpty == False):
        final.write_videofile(r"D:\FYP APP\STSL - APP\stsl\backend\API\merged.mp4")
    return[words_found, words_not_found]



def processing(*args):
    text_to_translate = ""
    
    translator = Translator()
    print("The text is being translated into 'Urdu' Language.\n")
    to_lang = 'ur'
    if args:
        print(f"args = {args}")
        text_to_translate = translator.translate(takecommand(args[0]), src = 'en', dest=to_lang)
    else:
        text_to_translate = translator.translate(takecommand(), src = 'en', dest=to_lang)
        print("NOT ARGS")

    text = text_to_translate.text
    print("Urdu Translated sentence is: ", text)

    urdu_stopwords = ['آئی', 'آئے', 'آخر', 'آش', 'آًب', 'آٹھ', 'آیب', 'اخبزت', 'اختتبم', 'ادھر', 'ارد', 'اردگرد', 'ارکبى', 'اش', 'اضتعوبل', 'اضتعوبلات', 'اضطرذ', 'اضکب', 'اضکی', 'اضکے', 'اطراف', 'اغیب', 'افراد', 'الگ', 'اور', 'اوًچب', 'اوًچبئی', 'اوًچی', 'اوًچے', 'اى', 'اًذر', 'اٹھبًب', 'اپٌب', 'اپٌے', 'اچھب', 'اچھی', 'اچھے', 'اکثر', 'اکٹھب', 'اکٹھی', 'اکٹھے', 'اکیلا', 'اکیلی', 'اکیلے', 'اگرچہ', 'اہن', 'ایطے', 'تب', 'تبزٍ', 'تت', 'تر', 'ترتیت', 'تریي', 'تعذاد', 'تن', 'تو', 'توبم', 'توہیں', 'تٌہب', 'تک', 'تھب', 'تھوڑا', 'تھوڑی', 'تھوڑے', 'تھی', 'تھے', 'تیي', 'ثب', 'ثبری', 'ثبرے', 'ثبعث', 'ثبلا', 'ثبلترتیت', 'ثبہر', 'ثدبئے', 'ثرآں', 'ثراں', 'ثرش', 'ثعذ', 'ثغیر', 'ثلٌذ', 'ثلکہ', 'ثٌب', 'ثٌبرہب', 'ثٌبرہی', 'ثٌبرہے', 'ثٌبًب', 'ثٌذ', 'ثٌذکرو', 'ثٌذکرًب', 'ثٌذی', 'ثڑا', 'ثڑی', 'ثڑے', 'ثھر', 'ثھرا', 'ثھرپور', 'ثھی', 'ثہت', 'ثہتر', 'ثہتری', 'ثہتریي', 'ثیچ', 'خب', 'خبر', 'خبهوظ', 'خبًب', 'خبًتب', 'خبًتی', 'خبًتے', 'خبًٌب', 'ختن', 'خجکہ', 'خص', 'خططرذ', 'خلذی', 'خو', 'خواى', 'خوًہی', 'خوکہ', 'خٌبة', 'خگہ', 'خگہوں', 'خگہیں', 'خیطب', 'خیطبکہ', 'در', 'درخبت', 'درخہ', 'درخے', 'درزقیقت', 'درضت', 'دش', 'دفعہ', 'دلچطپ', 'دلچطپی', 'دلچطپیبں', 'دو', 'دور', 'دورى', 'دوضرا', 'دوضروں', 'دوضری', 'دوضرے', 'دوًوں', 'دکھبئیں', 'دکھبتب', 'دکھبتی', 'دکھبتے', 'دکھبو', 'دکھبًب', 'دی', 'دیب', 'دیتب', 'دیتی', 'دیتے', 'دیر', 'دیٌب', 'دیکھو', 'دیکھٌب', 'دیکھی', 'دیکھیں', 'دے', 'راضتوں', 'راضتہ', 'راضتے', 'رریعہ', 'رریعے', 'رکي', 'رکھ', 'رکھب', 'رکھتی', 'رکھتے', 'رکھی', 'رکھے', 'رہب', 'رہی', 'رہے', 'زبصل', 'زبضر', 'زبل', 'زبلات', 'زبلیہ', 'زصوں', 'زصہ', 'زصے', 'زقبئق', 'زقیتیں', 'زقیقت', 'زکن', 'زکویہ', 'زیبدٍ', 'صبف', 'صسیر', 'صفر', 'صورت', 'صورتسبل', 'صورتوں', 'صورتیں', 'ضبت', 'ضبدٍ', 'ضبرا', 'ضبرے', 'ضبل', 'ضبلوں', 'ضت', 'ضرور', 'ضرورت', 'ضروری', 'ضلطلہ', 'ضوچ', 'ضوچب', 'ضوچتب', 'ضوچتی', 'ضوچتے', 'ضوچو', 'ضوچٌب', 'ضوچی', 'ضوچیں', 'ضکب', 'ضکتب', 'ضکتی', 'ضکتے', 'ضکٌب', 'ضکی', 'ضکے', 'ضیذھب', 'ضیذھی',
                    "ہوں", "ہی", "ہیں", 'نے', 'کا', 'کی', 'ک', 'ہونا', 'ہوں', 'ضیذھے', 'ضیکٌڈ', 'ضے', 'طب', 'طرف', 'طریق', 'طریقوں', 'طریقہ', 'طریقے', 'طور', 'طورپر', 'ظبہر', 'عذد', 'عظین', 'علاقوں', 'علاقہ', 'علاقے', 'علاوٍ', 'عووهی', 'غبیذ', 'غخص', 'غذ', 'غروع', 'غروعبت', 'غے', 'فرد', 'فی', 'قجل', 'قجیلہ', 'قطن', 'لئے', 'لازهی', 'لو', 'لوجب', 'لوجی', 'لوجے', 'لوسبت', 'لوسہ', 'لوگ', 'لوگوں', 'لڑکپي', 'لگتب', 'لگتی', 'لگتے', 'لگی', 'لگیں', 'لگے', 'لی', 'لیب', 'لیٌب', 'لیں', 'لے', 'هتعلق', 'هختلف', 'هسترم', 'هسترهہ', 'هسطوش', 'هسیذ', 'هطئلہ', 'هطئلے', 'هطبئل', 'هطتعول', 'هطلق', 'هعلوم', 'هػتول', 'هلا', 'هوکي', 'هوکٌبت', 'هوکٌہ', 'هٌبضت', 'هڑا', 'هڑًب', 'هڑے', 'هکول', 'هگر', 'هہرثبى', 'هیرا', 'هیری', 'هیرے', 'هیں', 'وار', 'والے', 'ًئی', 'ًئے', 'ًبپطٌذ', 'ًبگسیر', 'ًطجت', 'ًقطہ', 'ًوخواى', 'ًکبلٌب', 'ًکتہ', 'ًہیں', 'ًیب', 'ٹھیک', 'پبئے', 'پبش', 'پبًب', 'پبًچ', 'پر', 'پراًب', 'پل', 'پورا', 'پوچھب', 'پوچھتب', 'پوچھتی', 'پوچھتے', 'پوچھو', 'پوچھوں', 'پوچھٌب', 'پوچھیں', 'پچھلا', 'پھر', 'پہلا', 'پہلی', 'پہلے', 'پہلےضی', 'پیع', 'چبر', 'چبہب', 'چبہٌب', 'چبہے', 'چلا', 'چلو', 'چلیں', 'چلے', 'چکب', 'چکی', 'چکیں', 'چکے', 'چھوٹب', 'چھوٹوں', 'چھوٹی', 'چھوٹے', 'چھہ', 'چیسیں', 'ڈھوًڈا', 'ڈھوًڈلیب', 'ڈھوًڈو', 'ڈھوًڈًب', 'ڈھوًڈی', 'ڈھوًڈیں', 'کئی', 'کئے', 'کب', 'کبفی', 'کبم', 'کت', 'کجھی', 'کر', 'کرا', 'کرتب', 'کرتبہوں', 'کرتی', 'کرتے', 'کررہی', 'کرو', 'کرًب', 'کریں', 'کرے', 'کل', 'کن', 'کوئی', 'کوتر', 'کورا', 'کوروں', 'کورٍ', 'کورے', 'کوطي', 'کوى', 'کوًطب', 'کوًطی', 'کوًطے', 'کھولا', 'کھولو', 'کھولٌب', 'کھولیں', 'کھولے', 'کہ', 'کہب', 'کہتب', 'کہتی', 'کہتے', 'کہو', 'کہوں', 'کہٌب', 'کہی', 'کہیں', 'کہے', 'کی', 'کیب', 'کیطے', 'کیوًکہ', 'کیوں', 'کیے', 'کے', 'گئی', 'گئے', 'گب', 'گرد', 'گروٍ', 'گروپ', 'گروہوں', 'گٌتی', 'گی', 'گیب', 'گے', 'ہر', 'ہن', 'ہو', 'ہوئی', 'ہوئے', 'ہوا', 'ہوبرا', 'ہوبری', 'ہوبرے', 'ہوتی', 'ہوتے', 'ہورہب', 'ہورہی', 'ہورہے', 'ہوضکتب', 'ہوضکتی', 'ہوضکتے', 'ہوًب', 'ہوًی', 'ہوًے', 'ہوچکب', 'ہوچکی', 'ہوچکے', 'ہوگئی', 'ہوگیب', 'ہوں', 'ہی', 'ہے', "ہے؟", 'ہیں', 'ہیں؟', 'یقیٌی', 'یہ', 'یہبں']
    
    TEST_SENTENCE = text
    filtered_sentence = ""

    LEMM_TEST_SENTENCE = lemitize_str(TEST_SENTENCE)
    word_tokens = word_tokenize(LEMM_TEST_SENTENCE)

    for w in word_tokens:
        if w not in urdu_stopwords:
            filtered_sentence += w + " "
    
    print("----------------------------------------")
    print("Lemmatized Sentence is: ", LEMM_TEST_SENTENCE)
    print("----------------------------------------")

    filtered_sentence = word_tokenize(filtered_sentence)
    
    print("After removing stopwords, Sentence is: ", filtered_sentence)
    print("----------------------------------------")

    words_found, words_not_found = videoFormation(filtered_sentence)
    
    return[words_found, words_not_found]
