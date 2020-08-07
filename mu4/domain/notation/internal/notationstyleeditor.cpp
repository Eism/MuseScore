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
#include "notationstyleeditor.h"

#include "notation.h"

#include "libmscore/excerpt.h"

using namespace mu;
using namespace mu::domain::notation;

NotationStyleEditor::NotationStyleEditor(Notation* notation)
    : m_notation(notation)
{
}

Style NotationStyleEditor::style() const
{
    return m_notation->masterScore()->style();
}

void NotationStyleEditor::changeStyle(ChangeStyleVal* newStyleValue)
{
    newStyleValue->setScore(m_notation->masterScore());
    m_notation->masterScore()->undo(newStyleValue);
}

void NotationStyleEditor::update()
{
    m_styleChanged.notify();
}

bool NotationStyleEditor::isMaster() const
{
    return m_notation->masterScore()->isMaster();
}

QList<QMap<QString, QString> > NotationStyleEditor::metaTags() const
{
    QList<QMap<QString, QString> > tags;
    tags << m_notation->masterScore()->metaTags();

    return tags;
}

QString NotationStyleEditor::textStyleUserName(Tid tid)
{
    return m_notation->masterScore()->getTextStyleUserName(tid);
}

void NotationStyleEditor::setConcertPitch(bool status)
{
    m_notation->masterScore()->cmdConcertPitchChanged(status, true);
}

void NotationStyleEditor::startEdit()
{
    m_notation->masterScore()->startCmd();
}

void NotationStyleEditor::apply()
{
    m_notation->masterScore()->endCmd();
}

void NotationStyleEditor::applyAllParts()
{
    for (Ms::Excerpt* e : m_notation->masterScore()->excerpts()) {
        e->partScore()->undo(new ChangeStyle(e->partScore(), style()));
        e->partScore()->update();
    }
}

void NotationStyleEditor::cancel()
{
    m_notation->masterScore()->endCmd(true);
}

async::Notification NotationStyleEditor::styleChanged() const
{
    return m_styleChanged;
}
