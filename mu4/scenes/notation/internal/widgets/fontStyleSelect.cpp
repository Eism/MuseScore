//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2017 Werner Schweer and others
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENSE.GPL
//=============================================================================

#include "fontStyleSelect.h"

#include "ui/view/iconcodes.h"

#include "libmscore/types.h"

using namespace Ms;
using namespace mu::framework;

//---------------------------------------------------------
//    FontStyleSelect
//---------------------------------------------------------

FontStyleSelect::FontStyleSelect(QWidget* parent)
    : QWidget(parent)
{
    setupUi(this);

    auto iconCodeToChar = [](IconCode::Code code) -> QChar {
        return QChar(static_cast<char16_t>(code));
    };

    bold->setText(iconCodeToChar(IconCode::Code::TEXT_BOLD));
    italic->setText(iconCodeToChar(IconCode::Code::TEXT_ITALIC));
    underline->setText(iconCodeToChar(IconCode::Code::TEXT_UNDERLINE));

    connect(bold, SIGNAL(toggled(bool)), SLOT(_fontStyleChanged()));
    connect(italic, SIGNAL(toggled(bool)), SLOT(_fontStyleChanged()));
    connect(underline, SIGNAL(toggled(bool)), SLOT(_fontStyleChanged()));
}

//---------------------------------------------------------
//   _fontStyleChanged
//---------------------------------------------------------

void FontStyleSelect::_fontStyleChanged()
{
    emit fontStyleChanged(fontStyle());
}

//---------------------------------------------------------
//   fontStyle
//---------------------------------------------------------

FontStyle FontStyleSelect::fontStyle() const
{
    FontStyle fs = FontStyle::Normal;

    if (bold->isChecked()) {
        fs = fs + FontStyle::Bold;
    }
    if (italic->isChecked()) {
        fs = fs + FontStyle::Italic;
    }
    if (underline->isChecked()) {
        fs = fs + FontStyle::Underline;
    }

    return fs;
}

//---------------------------------------------------------
//   setFontStyle
//---------------------------------------------------------

void FontStyleSelect::setFontStyle(FontStyle fs)
{
    bold->setChecked(fs & FontStyle::Bold);
    italic->setChecked(fs & FontStyle::Italic);
    underline->setChecked(fs & FontStyle::Underline);
}
