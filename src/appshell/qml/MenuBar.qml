import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0
import MuseScore.AppShell 1.0

Rectangle {
    id: root

    color: ui.theme.backgroundPrimaryColor

    AppMenuModel {
        id: appMenuModel
    }

    Component.onCompleted: {
        appMenuModel.load()
    }

    Drag.active: mouseArea.drag.active
    Drag.dragType: Drag.Automatic

    Drag.onDragStarted: {
        startSystemMoveRequested()
    }

    signal showWindowMinimizedRequested()
    signal toggleWindowMaximizedRequested()
    signal closeWindowRequested()
    signal startSystemMoveRequested()

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        drag.target: parent

        onDoubleClicked: {
            toggleWindowMaximizedRequested()
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8

        RadioButtonGroup {
            id: radioButtonList
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

            height: 30

            model: appMenuModel.items

            delegate: FlatButton {
                id: radioButtonDelegate

                width: 60

                ButtonGroup.group: radioButtonList.radioButtonGroup

                normalStateColor: "transparent"
                accentButton: _menu.isOpened
                text: modelData["title"]

                onClicked: {
                    _menu.toggleOpened()
                }

                StyledMenu {
                    id: _menu

                    model: modelData["subitems"]

                    onHandleAction: {
                        Qt.callLater(appMenuModel.handleAction, actionCode, actionIndex)
                        _menu.close()
                        console.log("selected " + actionCode)
                    }
                }
            }
        }

        StyledTextLabel {
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Text.AlignLeft
            text: qsTrc("appshell", "MuseScore 4")
        }

        Row {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            FlatButton {
                icon: IconCode.MINUS
                normalStateColor: "transparent"

                onClicked: {
                    showWindowMinimizedRequested()
                }
            }

            FlatButton {
                icon: IconCode.SPLIT_OUT_ARROWS
                normalStateColor: "transparent"

                onClicked: {
                    toggleWindowMaximizedRequested()
                }
            }

            FlatButton {
                icon: IconCode.CLOSE_X_ROUNDED
                normalStateColor: "transparent"

                onClicked: {
                    closeWindowRequested()
                }
            }
        }
    }

}
