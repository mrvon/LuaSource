#!/usr/bin/python
# Filename: yahoo_search.py


import sys
if sys.version_info[0] != 3:
    sys.exit("This program needs Python 3.0")

import json
import urllib
import urllib.parse
import urllib.request
import urllib.response

# Get your own APP ID at http://developer.yahoo.com/wsregapp/
YAHOO_APP_ID = "APP_ID"
SEARCH_BASE = "SEARCH_BASE"


class YahooSearchError(Exception):
    pass

# Taken from http://developer.yahoo.com/python/python-json.html


def search(query, results=20, start=1, **kwargs):
    kwargs.update({
        'appid': YAHOO_APP_ID,
        'query': query,
        'results': results,
        'start': start,
        'output': 'json'
    })
    url = SEARCH_BASE + "?" + urllib.parse.urlencode(kwargs)
    result = json.load(urllib.request.urlopen(url))
    if "Error" in result:
        raise YahooSearchError(result['Error'])
    return result['ResultSet']

query = input("What do you want to search for? ")
search(query)
for result in search(query)['Result']:
    print("{0} : {1}".format(result['Title'], result['Url']))
