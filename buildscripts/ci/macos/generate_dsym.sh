#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# MuseScore-Studio-CLA-applies
#
# MuseScore Studio
# Music Composition & Notation
#
# Copyright (C) 2026 MuseScore Limited
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

# On macOS the linker leaves the DWARF in the object files and puts only a
# debug map into the executable, so dsymutil has to run while both are still
# around: Package strips the binary and deletes every dSYM inside the bundle.
#
# The dSYM keeps matching the shipped binary afterwards, because LC_UUID
# survives strip, install_name_tool and codesign.

echo "Generate dSYM"

trap 'echo "Generate dSYM failed"; exit 1' ERR
set -o pipefail

APP_BIN=applebuild/mscore.app/Contents/MacOS/mscore
APP_DSYM=applebuild/mscore.dSYM
DSYMUTIL_LOG=applebuild/dsymutil.log

# Size of the DWARF payload below which the dSYM is considered empty: one built
# from a binary without debug info is a few hundred KiB.
MIN_DWARF_SIZE_MB=50

echo "APP_BIN: $APP_BIN"
echo "APP_DSYM: $APP_DSYM"

if [ ! -f "$APP_BIN" ]; then
    echo "error: $APP_BIN not found"
    exit 1
fi

rm -rf "$APP_DSYM"

dsymutil "$APP_BIN" -o "$APP_DSYM" 2>&1 | tee "$DSYMUTIL_LOG"

# dsymutil warns and still exits 0 when there is nothing to collect, so the
# exit code alone does not tell us whether it found any debug info.
if grep -q "no debug symbols in executable" "$DSYMUTIL_LOG"; then
    echo "error: no debug map in $APP_BIN"
    echo "       the build has no debug info, or the binary is already stripped"
    exit 1
fi

DWARF_BIN="$APP_DSYM/Contents/Resources/DWARF/$(basename "$APP_BIN")"
if [ ! -f "$DWARF_BIN" ]; then
    echo "error: $DWARF_BIN not found"
    exit 1
fi

DWARF_SIZE_MB=$(( $(stat -f%z "$DWARF_BIN") / 1024 / 1024 ))
echo "dSYM DWARF size: ${DWARF_SIZE_MB} MB"

if [ "$DWARF_SIZE_MB" -lt "$MIN_DWARF_SIZE_MB" ]; then
    echo "error: dSYM contains no usable debug info (< ${MIN_DWARF_SIZE_MB} MB)"
    exit 1
fi

echo "-----"
echo "Binary UUIDs:"
dwarfdump --uuid "$APP_BIN"
echo "dSYM UUIDs:"
dwarfdump --uuid "$APP_DSYM"
