//=============================================================================
//  MusE Score
//  Linux Music Score Editor
//
//  Copyright (C) 2002-2010 Werner Schweer and others
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
#ifndef MU_NOTATIONSCENE_EDITSTYLE_H
#define MU_NOTATIONSCENE_EDITSTYLE_H

#include "ui_editstyle.h"
#include "modularity/ioc.h"
#include "context/iglobalcontext.h"
#include "scenes/notation/iscenenotationconfiguration.h"

using namespace Ms;

namespace Ms {
class Score;
class EditStyle;

//---------------------------------------------------------
//   StyleWidget
//---------------------------------------------------------

struct StyleWidget {
    Sid idx;
    bool showPercent;
    QObject* widget;
    QToolButton* reset;
};

//---------------------------------------------------------
//   EditStylePage
///   This is a type for a pointer to any QWidget that is a member of EditStyle.
///   It's used to create static references to the pointers to pages.
//---------------------------------------------------------

typedef QWidget* EditStyle::* EditStylePage;

//---------------------------------------------------------
//   EditStyle
//---------------------------------------------------------

class EditStyle : public QDialog, private Ui::EditStyleBase
{
    Q_OBJECT

    INJECT(notation, mu::context::IGlobalContext, globalContext)
    INJECT(notation, mu::scene::notation::ISceneNotationConfiguration, configuration)

    QPushButton* buttonApplyToAllParts = nullptr;
    QVector<StyleWidget> styleWidgets;
    QButtonGroup* keySigNatGroup = nullptr;
    QButtonGroup* clefTypeGroup = nullptr;
    bool isTooBig = false;
    bool hasShown = false;

    virtual void showEvent(QShowEvent*);
    virtual void hideEvent(QHideEvent*);
    QVariant getValue(Sid idx);
    void setValues();

    const StyleWidget& styleWidget(Sid) const;

    static const std::map<ElementType, EditStylePage> PAGES;

private slots:
    void selectChordDescriptionFile();
    void setChordStyle(bool);
    void toggleHeaderOddEven(bool);
    void toggleFooterOddEven(bool);
    void buttonClicked(QAbstractButton*);
    void setSwingParams(bool);
    void concertPitchToggled(bool);
    void lyricsDashMinLengthValueChanged(double);
    void lyricsDashMaxLengthValueChanged(double);
    void systemMinDistanceValueChanged(double);
    void systemMaxDistanceValueChanged(double);
    void resetStyleValue(int);
    void valueChanged(int);
    void textStyleChanged(int);
    void resetTextStyle(Pid);
    void textStyleValueChanged(Pid, QVariant);
    void on_comboFBFont_currentIndexChanged(int index);
    void on_buttonTogglePagelist_clicked();
    void editUserStyleName();
    void endEditUserStyleName();
    void resetUserStyleName();

public:
    EditStyle(QWidget* = nullptr);
    EditStyle(const EditStyle& other);

    void setPage(int no);
    void gotoElement(Element* e);
    void gotoHeaderFooterPage();

    static bool elementHasPage(Element* e);
    static int metaTypeId();
};
}

Q_DECLARE_METATYPE(Ms::EditStyle)

#endif // MU_NOTATIONSCENE_EDITSTYLE_H
