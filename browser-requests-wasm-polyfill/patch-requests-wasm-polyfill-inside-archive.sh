#!/bin/bash
FILENAME=$(ls build/requests-wasm-polyfill-*.tar.gz)
cp -a $FILENAME "${FILENAME/.tar.gz/.backup}"
DIRNAME='build/requests-wasm-polyfill'
tar --one-top-level=$DIRNAME -xzf $FILENAME
sed -si.bak 's/xmlr.responseType = "arraybuffer"/# &/' ./$DIRNAME/lib/python*/site-packages/requests/api.py
tar -czf $FILENAME -C ./$DIRNAME $(ls $DIRNAME)
