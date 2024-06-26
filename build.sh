#!/usr/bin/env bash

SCRIPT=$(readlink -f $0)
REPO_DIR="$(dirname $SCRIPT)"

TARGET="${1:-all}"

BUILD_DIR="${REPO_DIR}/build"
KEYBOARDS_DIR="${REPO_DIR}/keyboards"
QMK_DIR="${REPO_DIR}/qmk_firmware"
QMK_KEYBOARDS_DIR="${QMK_DIR}/keyboards"

SRC_DIRS=( $(find "$KEYBOARDS_DIR" -type f | xargs -I{} dirname {} | sort -u | xargs -I{} realpath -s --relative-to="$KEYBOARDS_DIR" {}) )

git submodule update --init --recursive
qmk setup -H "${QMK_DIR}" -y

for keyboard in "${SRC_DIRS[@]}"; do

    if [ "$TARGET" != "all" ] && [[ "/$keyboard/" != *"/$TARGET/"* ]]; then
        continue
    fi

    KEYMAP_DIR="${KEYBOARDS_DIR}/${keyboard}"
    QMK_KEYMAP_DIR="${QMK_KEYBOARDS_DIR}/${keyboard}/keymaps/${USER}"

    echo "Building ${KEYMAP_DIR} => ${QMK_KEYMAP_DIR}"

    ln -sf "${KEYMAP_DIR}" "${QMK_KEYMAP_DIR}"

    make BUILD_DIR="${BUILD_DIR}" -C "${QMK_DIR}" "${keyboard}:${USER}"

    rm -rf "${QMK_KEYMAP_DIR}"
done
