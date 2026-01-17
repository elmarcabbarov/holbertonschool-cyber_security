#!/bin/bash
python3 -c "import base64, sys; print(''.join(chr(b ^ 95) for b in base64.b64decode(sys.argv[1][5:])))" "$1"
