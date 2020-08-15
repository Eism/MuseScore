import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0
import MuseScore.UserScores 1.0

Column {

    spacing: 20

    Row {
        anchors.left: parent.left
        anchors.right: parent.right

        property real childWidth: (width / 2) - 15
        height: 60

        spacing: 20

        Column {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.childWidth
            spacing: 10

            StyledTextLabel {
                anchors.left: parent.left
                anchors.right: parent.right

                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTrc("instruments", "Title")
            }

            TextInputField {
                hint: qsTrc("instruments", "Optional")
            }
        }

        Column {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.childWidth
            spacing: 10

            StyledTextLabel {
                anchors.left: parent.left
                anchors.right: parent.right

                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTrc("instruments", "Composer")
            }

            TextInputField {
                hint: qsTrc("instruments", "Optional")
            }
        }
    }

    Row {
        //                id: row

        anchors.left: parent.left
        anchors.right: parent.right

        property real childWidth: (width / 3) - 15
        height: 60

        spacing: 20

        Column {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.childWidth

            spacing: 10

            StyledTextLabel {
                anchors.left: parent.left
                anchors.right: parent.right

                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTrc("instruments", "Subtitle")
            }

            TextInputField {
                hint: qsTrc("instruments", "Optional")
            }
        }

        Column {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.childWidth

            spacing: 10

            StyledTextLabel {
                anchors.left: parent.left
                anchors.right: parent.right

                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTrc("instruments", "Lyricist")
            }

            TextInputField {
                hint: qsTrc("instruments", "Optional")
            }
        }

        Column {
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.childWidth

            spacing: 10

            StyledTextLabel {
                anchors.left: parent.left
                anchors.right: parent.right

                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTrc("instruments", "Copiright")
            }

            TextInputField {
                hint: qsTrc("instruments", "Optional")
            }
        }
    }
}
