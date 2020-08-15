import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0
import MuseScore.UserScores 1.0

Item {
    id: root

    StyledTextLabel {
        id: title

        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter

        font.bold: true
        text: qsTrc("instruments", "Additional Score Information")
    }

    ColumnLayout {
        anchors.top: title.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom

        spacing: 30

        AdditionalInfoView {
            anchors.left: parent.left
            anchors.right: parent.right

            Layout.preferredHeight: 150
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right

            height: 2

            color: ui.theme.buttonColor
        }

        GeneralInfoView {
            Layout.fillHeight: true

            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
}
