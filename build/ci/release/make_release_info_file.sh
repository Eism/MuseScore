#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# MuseScore-CLA-applies
#
# MuseScore
# Music Composition & Notation
#
# Copyright (C) 2021 MuseScore BVBA and others
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

ARTIFACTS_DIR=build.artifacts

GITHUB_TOKEN=""
GITHUB_REPOSITORY=""

RELEASE_TAG=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --token) GITHUB_TOKEN="$2"; shift ;;
        --repo) GITHUB_REPOSITORY="$2"; shift ;;
        --release_tag) RELEASE_TAG="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "=== Get release info ==="

RELEASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/latest"
if [ ! -z "$RELEASE_TAG" ]; then RELEASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/${RELEASE_TAG}"; fi

RELEASE_INFO=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  $RELEASE_URL)

mkdir -p $ARTIFACTS_DIR
echo $RELEASE_INFO > $ARTIFACTS_DIR/release_info.json
cat $ARTIFACTS_DIR/release_info.json

# check if this is a patch, then get information about the previous minor release
RELEASE_VERSION=$(echo "$RELEASE_TAG" | sed -E 's/^v([0-9]+)\.([0-9]+)\.([0-9]+).*/\1.\2.\3/')
echo $RELEASE_VERSION

RELEASE_MAJOR_MINOR=""

# is patch?
if [[ $RELEASE_VERSION =~ ^[0-9]+\.[0-9]+\.([1-9][0-9]*)$ ]]; then
    echo "=== Get previous minor release info ==="

    # 4.2.1 -> 4.2.0
    RELEASE_MAJOR_MINOR=$(echo "$RELEASE_VERSION" | grep -Eo 's/\.[0-9]*$/\.0/')
    # 4.2.0 -> v4.2.0
    RELEASE_MAJOR_MINOR_TAG=$(echo "v$RELEASE_MAJOR_MINOR")

    PREVIOUS_RELEASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/${RELEASE_MAJOR_MINOR_TAG}"; fi

    PREVIOUS_RELEASE_INFO=$(curl \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      $PREVIOUS_RELEASE_URL)

    mkdir -p $ARTIFACTS_DIR
    echo $PREVIOUS_RELEASE_INFO > $ARTIFACTS_DIR/previous_release_info.json
    cat $ARTIFACTS_DIR/previous_release_info.json

    # remove unnecessary zeros: 4.2.0 -> 4.2
    RELEASE_MAJOR_MINOR=$(echo "$version" | grep -Eo 's/\.0+$//')
fi

pip install markdown

HERE="$(cd "$(dirname "$0")" && pwd)"
python3 $HERE/correct_release_info.py ${ARTIFACTS_DIR}/release_info.json ${RELEASE_MAJOR_MINOR} ${ARTIFACTS_DIR}/previous_release_info.json
