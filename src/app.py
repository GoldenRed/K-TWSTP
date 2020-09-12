from flask import Flask, request, jsonify
import json
app = Flask(__name__)

translations = {} # Will contain nested Python3 dictionaries for each "language"

def checkHeader(headers, headerLabel):
    """
    Checks if a header is correct and that it's value is not empty.
    """
    if headerLabel not in headers:
        return True
    if len(headers[headerLabel]) == 0:
        return True
    return False


@app.route('/')
def index():
    return 'Hello Knightec!'


@app.route('/set', methods = ['POST'])
def setTranslation():
    """
    Function for storing translation.

    Example Use:
    curl -X POST --header 'language:en' --header 'text:Good Morning' --header 'translation:God Morgon'  {INSERT IP}/set
    curl -X POST --header 'language:no' --header 'text:Akkurat' --header 'translation:Precis'  {INSERT IP}/set
    curl -X POST --header 'language:es' --header 'text:Suecia' --header 'translation:Sverige'  {INSERT IP}/set


    The SET method associates a Swedish translation with a specific language->text entry, provided with headers as above.

    """
    headers = request.headers
    if checkHeader(headers, 'Language') or checkHeader(headers, 'Text') or checkHeader(headers, 'Translation'):
        return "Error with API request."
    
    if headers['Language'] in translations:
        translations[headers['Language']][headers['Text']] = headers['Translation']
    else:
        translations[headers['Language']] = {}
        translations[headers['Language']][headers['Text']] = headers['Translation']
    
    return 'Translation set!'




@app.route('/get', methods = ['GET'])
def getTranslation():
    """ Function for retrieving translations.

    Example Use:
    curl -X GET --header 'language:en' --header 'text:Good Morning'  {INSERT IP}/get
    curl -X GET --header 'language:no' --header 'text:Akkurat'  {INSERT IP}/get
    curl -X GET --header 'language:es' --header 'text:Suecia'  {INSERT IP}/get

    The above API calls, provided that translations have been set with the SET 

    """
    headers = request.headers
    if checkHeader(headers, 'Language') or checkHeader(headers, 'Text'):
        return "Error with API request."    

    if headers['Text'] in translations[headers['Language']]:
        return jsonify(translations[headers['Language']][headers['Text']])
    else:
        return 'No such translation stored.'



if __name__ == '__main__':
    app.run(debug=False, port=80, host='0.0.0.0')
