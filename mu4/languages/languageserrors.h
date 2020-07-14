//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2020 MuseScore BVBA and others
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================
#ifndef MU_LANGUAGES_LANGUAGESERRORS_H
#define MU_LANGUAGES_LANGUAGESERRORS_H

#include "ret.h"
#include "translation.h"

namespace mu {
namespace languages {
enum class Err {
    Undefined       = int(Ret::Code::Undefined),
    NoError         = int(Ret::Code::Ok),
    UnknownError    = int(Ret::Code::LanguagesFirst),

    ErrorParseConfig,
    ErrorLoadingLanguage,
    ErrorLanguageNotFound,
    ErrorRemoveLanguageDirectory
};

inline Ret make_ret(Err e)
{
    switch (e) {
    case Err::Undefined: return Ret(static_cast<int>(Ret::Code::Undefined));
    case Err::NoError: return Ret(static_cast<int>(Ret::Code::Ok));
    case Err::UnknownError: return Ret(static_cast<int>(Ret::Code::UnknownError));
    case Err::ErrorParseConfig: return Ret(static_cast<int>(Err::ErrorParseConfig),
                   trc("languages", "Error parsing response from server"));
    case Err::ErrorLoadingLanguage: return Ret(static_cast<int>(Err::ErrorLoadingLanguage),
                   trc("languages", "Error loading language"));
    case Err::ErrorLanguageNotFound: return Ret(static_cast<int>(Err::ErrorLanguageNotFound),
                   trc("languages", "Language not found"));
    case Err::ErrorRemoveLanguageDirectory: return Ret(static_cast<int>(Err::ErrorRemoveLanguageDirectory),
                   trc("languages", "Error remove language directory"));
    }

    return Ret(static_cast<int>(e));
}
}
}

#endif // MU_LANGUAGES_LANGUAGESERRORS_H
