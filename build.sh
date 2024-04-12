#!/bin/bash

SCRIPT=$(readlink -f $0)
REPO_DIR="$(dirname $SCRIPT)"
KEYBOARDS_DIR="${REPO_DIR}/keyboards"
QMK_DIR="${REPO_DIR}/qmk_firmware"
QMK_KEYBOARDS_DIR="${QMK_DIR}/keyboards"

SRC_DIRS=( $(fd -t f "." "$KEYBOARDS_DIR" | xargs -I{} dirname {} | sort -u | xargs -I{} realpath -s --relative-to="$KEYBOARDS_DIR" {}) )

git submodule update --init --recursive

for dir in "${SRC_DIRS[@]}"; do
    echo "Building ${dir} ${QMK_KEYBOARDS_DIR}/${dir}/${USER}"
    ln -sf "${KEYBOARDS_DIR}/${dir}" "${QMK_KEYBOARDS_DIR}/${dir}/keymaps/${USER}"
done

for dir in "${SRC_DIRS[@]}"; do
    make BUILD_DIR="${REPO_DIR}/build" -C "${QMK_DIR}" "${dir}:${USER}"
done
