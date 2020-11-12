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
#include "actionnoteinputbaritem.h"

#include "log.h"

using namespace mu::notation;

ActionNoteInputBarItem::ActionNoteInputBarItem(const ItemType& type, QObject* parent)
    : AbstractNoteInputBarItem(type, parent)
{
}

int ActionNoteInputBarItem::icon() const
{
    return m_icon;
}

bool ActionNoteInputBarItem::checked() const
{
    return m_checked;
}

void ActionNoteInputBarItem::setIcon(int icon)
{
    if (m_icon == icon) {
        return;
    }

    m_icon = icon;
    emit iconChanged(m_icon);
}

void ActionNoteInputBarItem::setChecked(bool checked)
{
    if (m_checked == checked) {
        return;
    }

    m_checked = checked;
    emit checkedChanged(m_checked);
}
