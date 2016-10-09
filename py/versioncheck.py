#!/usr/bin/python
# Filename: versioncheck.py


import sys
import warnings

if sys.version_info[0] < 3:
    warnings.warn("Need Python 3.0 for this program to run.", RuntimeWarning)
else:
    print("Proceeed as normal.")
