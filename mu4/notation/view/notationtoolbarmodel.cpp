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
#include "notationtoolbarmodel.h"

#include "log.h"
#include "ui/view/iconcodes.h"

using namespace mu::notation;
using namespace mu::actions;
using namespace mu::workspace;
using namespace mu::framework;

static const std::string TOOLBAR_TAG("Toolbar");
static const std::string NOTE_INPUT_TOOLBAR_NAME("noteInput");

static const std::string ADD_ACTION_NAME("add");
static const std::string ADD_ACTION_TITLE("Add");
static const IconCode::Code ADD_ACTION_ICON_CODE = IconCode::Code::PLUS;
static const QString ADD_ITEM_SECTION = QString::number(1000);

NotationToolBarModel::NotationToolBarModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

QVariant NotationToolBarModel::data(const QModelIndex& index, int role) const
{
    const ActionItem& item = m_items.at(index.row());
    switch (role) {
    case IconRole: return static_cast<int>(item.action.iconCode);
    case SectionRole: return item.section;
    case NameRole: return QString::fromStdString(item.action.name);
    case CheckedRole: return item.checked;
    }
    return QVariant();
}

int NotationToolBarModel::rowCount(const QModelIndex&) const
{
    return m_items.count();
}

QHash<int,QByteArray> NotationToolBarModel::roleNames() const
{
    static const QHash<int, QByteArray> roles = {
        { IconRole, "iconRole" },
        { SectionRole, "sectionRole" },
        { NameRole, "nameRole" },
        { CheckedRole, "checkedRole" }
    };
    return roles;
}

void NotationToolBarModel::load()
{
    RetValCh<std::shared_ptr<IWorkspace> > workspace = workspaceManager()->currentWorkspace();
    if (!workspace.ret) {
        LOGW() << workspace.ret.toString();
        return;
    }

    beginResetModel();

    m_items.clear();

    AbstractDataPtr toolbarData = workspace.val->data(TOOLBAR_TAG, NOTE_INPUT_TOOLBAR_NAME);
    std::vector<std::string> noteInputActions = std::dynamic_pointer_cast<ToolbarData>(toolbarData)->actions;

    auto areg = aregister();

    noteInputActions.insert(noteInputActions.begin(), "note-input");
    noteInputActions.insert(noteInputActions.begin(), "note-input-rhythm");
    noteInputActions.insert(noteInputActions.begin(), "note-input-repitch");
    noteInputActions.insert(noteInputActions.begin(), "note-input-realtime-auto");
    noteInputActions.insert(noteInputActions.begin(), "note-input-realtime-manual");
    noteInputActions.insert(noteInputActions.begin(), "");
//    noteInputActions.insert(noteInputActions.begin(), "add-marcato");
//    noteInputActions.insert(noteInputActions.begin(), "add-sforzato");
//    noteInputActions.insert(noteInputActions.begin(), "add-tenuto");
//    noteInputActions.insert(noteInputActions.begin(), "add-staccato");
//    noteInputActions.insert(noteInputActions.begin(), "");

    int section = 0;
    for (const std::string& actionName: noteInputActions) {
        if (actionName == "") {
            section++;
            continue;
        }

        m_items << makeItem(areg->action(actionName), QString::number(section));
    }

    m_items << makeAddItem();

    endResetModel();

    emit countChanged(rowCount());

    workspace.ch.onReceive(this, [this](std::shared_ptr<IWorkspace>) {
        load();
    });

    workspace.val->dataChanged().onReceive(this, [this](const AbstractDataPtr data) {
        if (data->name == NOTE_INPUT_TOOLBAR_NAME) {
            load();
        }
    });

    onNotationChanged();
    m_notationChanged = globalContext()->currentNotationChanged();
    m_notationChanged.onNotify(this, [this]() {
        onNotationChanged();
    });

    playbackController()->isPlayingChanged().onNotify(this, [this]() {
        updateState();
    });
}

NotationToolBarModel::ActionItem& NotationToolBarModel::item(const actions::ActionName& name)
{
    for (ActionItem& item : m_items) {
        if (item.action.name == name) {
            return item;
        }
    }

    LOGE() << "item not found with name: " << name;
    static ActionItem null;
    return null;
}

void NotationToolBarModel::onNotationChanged()
{
    std::shared_ptr<INotation> notation = globalContext()->currentNotation();

    //! NOTE Unsubscribe from previous notation, if it was
    m_notationChanged.resetOnNotify(this);
    m_inputStateChanged.resetOnNotify(this);

    if (notation) {
        m_inputStateChanged = notation->interaction()->inputStateChanged();
        m_inputStateChanged.onNotify(this, [this]() {
            updateState();
        });
    }

    updateState();
}

void NotationToolBarModel::updateState()
{
    bool isPlaying = playbackController()->isPlaying();
    if (!notation() || isPlaying) {
        for (ActionItem& item : m_items) {
            item.enabled = false;
            item.checked = false;
        }
    } else {
        for (ActionItem& item : m_items) {
            item.enabled = true;
            item.checked = false;
        }

        updateInputState();
    }

    emit dataChanged(index(0), index(rowCount() - 1));
}

void NotationToolBarModel::updateInputState()
{
    auto is = notation()->interaction()->inputState();
    if (!is->isNoteEnterMode()) {
        for (ActionItem& item : m_items) {
            item.checked = false;
        }

        return;
    }

    item("note-input").checked = true;

    static QMap<actions::ActionName, Pad> noteInputActionPads = {
        { "note-longa", Pad::NOTE00 },
        { "note-breve", Pad::NOTE0 },
        { "pad-note-1", Pad::NOTE1 },
        { "pad-note-2", Pad::NOTE2 },
        { "pad-note-4", Pad::NOTE4 },
        { "pad-note-8", Pad::NOTE8 },
        { "pad-note-16", Pad::NOTE16 },
        { "pad-note-32", Pad::NOTE32 },
        { "pad-note-64", Pad::NOTE64 },
        { "pad-note-128", Pad::NOTE128 },
        { "pad-note-256", Pad::NOTE256 },
        { "pad-note-512", Pad::NOTE512 },
        { "pad-note-1024", Pad::NOTE1024 },
        { "pad-dot", Pad::DOT },
        { "pad-dotdot", Pad::DOTDOT },
        { "pad-dot3", Pad::DOT3 },
        { "pad-dot4", Pad::DOT4 },
        { "pad-rest", Pad::REST },
        { "add-marcato", Pad::ARTICULATION_MORCATO },
        { "add-sforzato", Pad::ARTICULATION_ACCENT },
        { "add-tenuto", Pad::ARTICULATION_TENUTO },
        { "add-staccato", Pad::ARTICULATION_STACCATO },
    };

    for (const actions::ActionName& actionName: noteInputActionPads.keys()) {
        item(actionName).checked = is->isPadActive(noteInputActionPads[actionName]);
    }
}

NotationToolBarModel::ActionItem NotationToolBarModel::makeItem(const Action& action, const QString& section)
{
    ActionItem item;
    item.action = action;
    item.section = section;
    return item;
}

NotationToolBarModel::ActionItem NotationToolBarModel::makeAddItem()
{
    Action addAction(ADD_ACTION_NAME, ADD_ACTION_TITLE, shortcuts::ShortcutContext::Undefined, ADD_ACTION_ICON_CODE);
    return makeItem(addAction, ADD_ITEM_SECTION);
}

void NotationToolBarModel::click(const QString& action)
{
    dispatcher()->dispatch(actions::namefromQString(action));
}

QVariantMap NotationToolBarModel::get(int index)
{
    QVariantMap result;

    QHash<int,QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> i(names);
    while (i.hasNext()) {
        i.next();
        QModelIndex idx = this->index(index, 0);
        QVariant data = idx.data(i.key());
        result[i.value()] = data;
    }

    return result;
}

INotationPtr NotationToolBarModel::notation() const
{
    return globalContext()->currentNotation();
}
