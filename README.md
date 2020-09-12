# K-TWSTP - Repo
Intentionally vague name to avoid others from googling this task.
Server running on knightec.yared.se.

## Interpretation
I interpreted this task as a translation service from any language into Swedish. So in your POST you send the API server a language (e.g., 'en' for English), the text in that language (e.g., 'Good Morning') and the corresponding translation in Swedish (i.e. 'God Morgon).

The server does not enforce a specific way of writing the language ('en', 'eng', 'english', etc) - it will treat them as different languages. Same with capitalization, e.g. the following are three different translations: 'Good Morning', 'Good morning', 'good morning', 'GOOD MORNING'. There is no specification on this in the instructions so it was not considered.


## Infra
Contains Terraform code to provision an Ubuntu server on AWS.

## Src
Contains source code to run the API server on Python33 Flask.

The API server has the following two methods:

### set: Allows you to set a translation by POST:ing to this 
```bash
curl -X POST --header 'language:en' --header 'text:Good Morning' --header 'translation:God Morgon'  {INSERT IP}/set
curl -X POST --header 'language:no' --header 'text:Akkurat' --header 'translation:Precis'  {INSERT IP}/set
curl -X POST --header 'language:es' --header 'text:Suecia' --header 'translation:Sverige'  {INSERT IP}/set
```

The SET method associates a Swedish translation with a specific language->text entry, provided with headers as above.

### get: Allows you to get a translation by GET:ing to this
```bash
curl -X GET --header 'language:en' --header 'text:Good Morning'  {INSERT IP}/get
curl -X GET --header 'language:no' --header 'text:Akkurat'  {INSERT IP}/get
curl -X GET --header 'language:es' --header 'text:Suecia'  {INSERT IP}/get
```
Provided that the translations have been set with the SET method, the above API calls will return "God Morgon", "Precis" and "Sverige".