/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.15
import QtQuick.Layouts 1.15

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0

Rectangle {
    id: root

    color: ui.theme.backgroundPrimaryColor

    property alias title: titleLabel.text
    property alias text: textLabel.text

    property bool withIcon: false
    property bool iconCode: ""

    property bool withShowAgain: false

    ColumnLayout {
        anchors.fill: parent

        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 28

            StyledIconLabel {
                iconCode: iconFromCode(root.iconCode)
                visible: !isEmpty
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: 16

                StyledTextLabel {
                    id: titleLabel

                    Layout.fillWidth: true

                    font.family: ui.theme.largeBodyBoldFont
                }

                StyledTextLabel {
                    id: textLabel

                    Layout.fillWidth: true

                    visible: !isEmpty
                }

                CheckBox {
                    Layout.fillWidth: true

                    text: qsTrc("ui", "Show this message again")

                    visible: root.withShowAgain
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignBottom | Qt.AlignRight

            spacing: 28

            // todo
            FlatButton {
                text: "Ok"
            }
        }
    }

    function iconFromCode(code) {
        switch (code) {
        case "QUESTION":
            return IconCode.AMBITUS
        case "INFO":
            return IconCode.AUDIO
        case "WARNING":
            return IconCode.BRACE
        case "ERROR":
            return IconCode.COUNT_IN
        }

        return IconCode.NONE
    }
}
