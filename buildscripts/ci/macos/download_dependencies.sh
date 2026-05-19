#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# MuseScore-Studio-CLA-applies
#
# MuseScore Studio
# Music Composition & Notation
#
# Copyright (C) 2025 MuseScore Limited and others
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

echo "Download dependencies"
trap 'code=$?; echo "error: Download dependencies: command \`$BASH_COMMAND\` exited with code $code." >&2; exit 1' ERR

DEPS_DIR="$HOME/musescore_deps_macos"
DEPS_BASE_URL="https://raw.githubusercontent.com/musescore/muse_deps/main"
DEPS_ARCHIVE="macos_universal_relwithdebinfo_appleclang15_os1013.7z"

DEPS=(
    "flac/1.4.2"
    "ogg/1.3.5"
    "vorbis/1.3.7"
    "opus/1.5.2"
    "libsndfile/1.0.31"
)

mkdir -p "$DEPS_DIR"
for dep in "${DEPS[@]}"; do
    echo "Download $dep"
    wget -q --show-progress -O dep.7z "$DEPS_BASE_URL/$dep/$DEPS_ARCHIVE"
    7z x -y dep.7z -o"$DEPS_DIR"
    rm dep.7z

    # also fetch the cmake helper next to the extracted lib/include
    name=$(basename "${dep%/*}")
    wget -q -O "$DEPS_DIR/${name}.cmake" "$DEPS_BASE_URL/$dep/${name}.cmake"
done

echo "Download dependencies done"
