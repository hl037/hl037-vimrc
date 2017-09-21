# Calculating char order for dawg
# We calculate how many times a character appears after another char.


_dCharOrder = {
    # key: previous char, value: dictionary of chars {c: nValue}
    "": {}
}


def addWord (sWord):
    cPrevious = ""
    for cChar in sWord:
        if cPrevious not in _dCharOrder:
            _dCharOrder[cPrevious] = {}
        _dCharOrder[cPrevious][cChar] = _dCharOrder[cPrevious].get(cChar, 0) + 1
        cPrevious = cChar


def getCharOrderForPreviousChar (cChar):
    return _dCharOrder.get(cChar, None)


def displayCharOrder ():
    for key, value in _dCharOrder.items():
        print("[" + key + "]: ", ", ".join([ c+":"+str(n)  for c, n  in  sorted(value.items(), key=lambda t: t[1], reverse=True) ]))
