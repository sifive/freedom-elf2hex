#!/bin/bash

unset bit_width
unset input
unset output
target="X_TARGET_PREFIX_X"
tcpath="X_TOOLCHAIN_PATH_X"
objcopy="${target}objcopy"
mydirname=$(dirname "${BASH_SOURCE}")
bin2hex="${mydirname}/../util/freedom-bin2hex"
while [[ "$1" != "" ]]
do
    case "$1" in
    -h | --help) echo "$0 [--help] --bit-width BIT_WIDTH --input INPUT.ELF [--output OUTPUT.HEX]" >&2; exit 0;;
    -w | --bit-width) bit_width="$2"; shift 2;;
    --input) input="$2"; shift 2;;
    --output) output="$2"; shift 2;;
    *) echo "$0: unknown argument $1">&2; exit 1;;
    esac
done
   
if [[ "$bit_width" == "" ]]
then
    echo "$0 [-h] --bit-width BIT_WIDTH --input INPUT.ELF [--output OUTPUT.HEX]" >&2
    exit 1
fi

if [[ "$input" == "" ]]
then
    echo "$0 [-h] --bit-width BIT_WIDTH --input INPUT.ELF [--output OUTPUT.HEX]" >&2
    exit 1
fi

if [[ "$RISCV_PATH" == "" ]]
then
    objcopy="${tcpath}${objcopy}"
else
    objcopy="${RISCV_PATH}/bin/${objcopy}"
fi

temp="$(mktemp -d)"
trap "rm -rf $temp" EXIT

"$objcopy" "$input" -O binary "$temp"/output.bin
if [[ "$output" == "" ]]
then
    exec "$bin2hex" -w "$bit_width" -i "$temp"/output.bin
else
    exec "$bin2hex" -w "$bit_width" -i "$temp"/output.bin -o "$output"
fi
