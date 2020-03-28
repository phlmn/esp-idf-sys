#!/usr/bin/env bash

set -e

. ./setenv.sh

# : "${SYSROOT:=$(xtensa-esp32-elf-gcc --print-sysroot)}"
SYSROOT=/Users/phlmn/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/xtensa-esp32-elf/sys-include
TARGET=xtensa-esp32-none-elf

: "${BINDGEN:=bindgen}"
: "${LIBCLANG_PATH:=../llvm_build/lib}"

CLANG_FLAGS="\
    --sysroot=$SYSROOT \
    -I$SYSROOT \
    -I$(pwd)
    -D__bindgen \
    --target=$TARGET \
    -x c"

CLANG_FLAGS="${CLANG_FLAGS} ${CLANG_INCLUDES}"

generate_bindings()
{
    readonly crate="$1"

    cd "$crate"

    # --no-rustfmt-bindings because we run rustfmt separately with regular rust
    LIBCLANG_PATH="$LIBCLANG_PATH" \
    "$BINDGEN" \
        --use-core \
        --no-layout-tests \
        --no-rustfmt-bindings \
        $BINDGEN_FLAGS \
        --output esp-idf-sys/src/bindings.rs \
        esp-idf-sys/src/bindings.h \
        -- $CLANG_FLAGS

    rustup run stable rustfmt esp-idf-sys/src/bindings.rs
}

generate_bindings "$@"
