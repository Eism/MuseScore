import QtQuick 2.7
import MuseScore.NotationScene 1.0
import MuseScore.UiComponents 1.0

Rectangle {
    id: root

    ListView {
        anchors.fill: parent

        orientation: Qt.Horizontal

        model: ["title-text", "subtitle-text", "subtitle-text", "poet-text",
                "part-text", "system-text", "staff-text", "expression-text",
                "rehearsalmark-text", "instrument-change-text", "fingering-text",
                "sticking-text", "chord-text", "roman-numeral-text", "nashville-number-text",
                "lyrics", "figured-bass", "tempo"
        ]

        delegate: FlatButton {
            text: modelData

            onClicked: {
                Qt.callLater(abModel.handle, modelData)
            }
        }
    }

    NotationAccessibilityModel {
        id: abModel
    }

//    NotationAccessibilityInfo {
//        anchors.left: parent.left
//        anchors.leftMargin: 20
//        anchors.verticalCenter: parent.verticalCenter
//    }

//    Row {
//        anchors.right: parent.right
//        anchors.rightMargin: 20

//        spacing: 12

//        ConcertPitchControl {
//            anchors.verticalCenter: parent.verticalCenter
//        }

//        ViewModeControl {
//            anchors.verticalCenter: parent.verticalCenter
//        }

//        ZoomControl {
//            anchors.verticalCenter: parent.verticalCenter
//        }
//    }
}
