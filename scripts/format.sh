#!/bin/bash

DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

if ! command -v clang-format &> /dev/null; then
    echo "clang-format is not installed"
    exit -1
fi


find "${DIR}/../src" -iname *.cpp -o -iname *.hpp | xargs clang-format -i --style=file:"${DIR}/../.clang-format"
