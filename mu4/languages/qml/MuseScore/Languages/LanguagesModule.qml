import QtQuick 2.7

import MuseScore.UiComponents 1.0
import MuseScore.Languages 1.0

Item {
    id: root

    property alias search: filterModel.searchString

    onSearchChanged: {
        languagePanel.hide()
    }

    Component.onCompleted: {
        languageListModel.load()
    }

    LanguageListModel {
        id: languageListModel
    }

    FilterProxyModel {
        id: filterModel

        sourceModel: languageListModel
        searchRoles: ["name"]
    }

    Row {
        id: header

        property real itemWidth: parent.width / 2

        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 133
        anchors.right: parent.right
        anchors.rightMargin: 133

        height: 48

        StyledTextLabel {
            width: header.itemWidth

            text: qsTrc("languages", "LANGUAGES")
            horizontalAlignment: Text.AlignLeft
            opacity: 0.5
        }
        StyledTextLabel {
            width: header.itemWidth

            text: qsTrc("languages", "STATUS")
            horizontalAlignment: Text.AlignLeft
            opacity: 0.5
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: view.top

        height: 8
        z: 1

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: ui.theme.backgroundColor
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }

    ListView {
        id: view

        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: languagePanel.visible ? languagePanel.top : parent.bottom

        model: filterModel

        clip: true

        boundsBehavior: Flickable.StopAtBounds

        delegate: LanguageItem {
            width: view.width

            title: model.name
            statusTitle: model.statusTitle

            color: (index % 2 == 0) ? ui.theme.popupBackgroundColor
                                    : ui.theme.backgroundColor

            headerWidth: header.itemWidth
            sideMargin: 133

            onClicked: {
                languagePanel.show(model)
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: view.bottom

        height: 8
        z:1

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 1.0
                color: ui.theme.backgroundColor
            }
        }
    }

    PopupPanel {
        id: languagePanel

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false

        content: LanguageInfo {
            id: languageInfo

            onInstall: {
                languageListModel.install(code)
            }

            onUpdate: {
                languageListModel.update(code)
            }

            onUninstall: {
                languageListModel.uninstall(code)
            }

            onOpenPreferences: {
                languageListModel.openPreferences()
            }

            Connections {
                target: languageListModel
                function onProgress(status, indeterminate, current, total) {
                    languageInfo.setProgress(status, indeterminate, current, total)
                }
                function onFinish() {
                    languageInfo.resetProgress()
                }
            }
        }

        onClose: {
            visible = false
        }

        function show(language) {
            setContentData(language)

            visible = true
        }

        function hide() {
            visible = false
        }
    }
}
