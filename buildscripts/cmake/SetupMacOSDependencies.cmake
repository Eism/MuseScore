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
#
# Pull the precompiled macOS audio dependencies (libFLAC, Opus, libsndfile,
# Ogg, Vorbis) from musescore/muse_deps and register them as IMPORTED targets.

include(MuseDeps)

populate(ogg        "ogg/1.3.5")
populate(vorbis     "vorbis/1.3.7")
populate(flac       "flac/1.4.2")
populate(opus       "opus/1.5.2")
populate(libsndfile "libsndfile/1.0.31")
