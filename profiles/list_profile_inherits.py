#!/usr/bin/python

import portage
for p in portage.settings.profiles:
    print("%s" % p)
