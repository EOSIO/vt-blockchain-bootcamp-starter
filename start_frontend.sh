#!/usr/bin/env bash

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# change to script's directory
cd "${SOURCE_DIR}/frontend"

echo "=== npm start ==="
npm start
