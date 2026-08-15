#!/usr/bin/env bash
set -euo pipefail
SRC="${1:?usage: migrate-config.sh old.toml new.json}"
DST="${2:?usage: migrate-config.sh old.toml new.json}"
echo "Converting $SRC → $DST..."
python3 -c "
import sys, tomllib, json
toml = open('$SRC','rb').read()
data = tomllib.loads(toml)
json.dump(data, open('$DST','w'), indent=2)
print('converted')
"
