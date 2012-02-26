#!/usr/bin/python

import sys
import bcrypt

def main(argv):
    if len(argv) > 1:
        salt = bcrypt.gensalt(13)
        print bcrypt.hashpw(argv[1], salt)
        return
    else:
        raise SystemExit('usage: %s <password>' % argv[0])

if __name__ == "__main__":
    main(sys.argv[0:])
