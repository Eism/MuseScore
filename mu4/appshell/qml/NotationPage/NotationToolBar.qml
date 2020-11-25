import QtQuick 2.12
import QtQuick.Controls 2.12

import MuseScore.NotationScene 1.0
import MuseScore.UiComponents 1.0
import MuseScore.Ui 1.0

Rectangle {
    id: root

    property alias orientation: gridView.orientation

    QtObject {
        id: privatesProperties

        property bool isHorizontal: orientation === Qt.Horizontal
    }

    Rectangle {
        id: testSpace

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 300

        Row {
            id: row
            anchors.fill: parent

            Repeater {

                model: [
                    { action: "note-input", icon: IconCode.EDIT },
                    { action: "note-input-rhythm", icon: IconCode.RHYTHM_ONLY },
                    { action: "note-input-repitch", icon: IconCode.RE_PITH },
                    { action: "note-input-realtime-auto", icon: IconCode.METRONOME },
                    { action: "note-input-realtime-manual", icon: IconCode.FOOT_PEDAL },
//                    { action: "note-input-timewise", icon: IconCode.NOTE_TO_RIGHT },
//                    { action: "note-input-repitch", icon: IconCode.NOTE_PLUS }
                ]

                FlatButton {
                    width: 36
                    height: width

                    normalStateColor: "transparent"

                    icon: modelData["icon"]

                    onClicked: {
                        toolModel.test_setNoteEntryMethod(modelData["action"])
                    }
                }
            }
        }
    }

    GridViewSectional {
        id: gridView

        anchors.top: parent.top
        anchors.left: testSpace.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        sectionRole: "sectionRole"

        cellWidth: 36
        cellHeight: cellWidth

        model: toolModel

        sectionDelegate: Rectangle {
            color: ui.theme.strokeColor
        }

        itemDelegate: FlatButton {
            property var item: Boolean(itemModel) ? itemModel : null

            normalStateColor: Boolean(item) && item.checkedRole ? ui.theme.accentColor : "transparent"

            icon: Boolean(item) ? item.iconRole : null

            onClicked: {
                toolModel.click(item.nameRole)
            }
        }
    }

    FlatButton {
        id: customizeButton

        anchors.margins: 8

        icon: IconCode.CONFIGURE
        normalStateColor: "transparent"

        onClicked: {
            api.launcher.open("musescore://notation/noteinputbar/customise")
        }
    }

    NotationToolBarModel {
        id: toolModel
    }

    Component.onCompleted: {
        toolModel.load()
    }

    states: [
        State {
            when: privatesProperties.isHorizontal
            PropertyChanges {
                target: gridView
                sectionWidth: 2
                sectionHeight: root.height
                rows: 1
                columns: gridView.noLimit
            }

            AnchorChanges {
                target: customizeButton
                anchors.right: root.right
                anchors.verticalCenter: root.verticalCenter
            }
        },
        State {
            when: !privatesProperties.isHorizontal
            PropertyChanges {
                target: gridView
                sectionWidth: root.width
                sectionHeight: 2
                rows: gridView.noLimit
                columns: 2
            }

            AnchorChanges {
                target: customizeButton
                anchors.bottom: root.bottom
                anchors.right: root.right
            }
        }
    ]
}
