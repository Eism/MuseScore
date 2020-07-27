import QtQuick 2.7
import QtQuick.Layouts 1.15

import MuseScore.UiComponents 1.0
import MuseScore.Languages 1.0

Item {
    id: root

    property var language: undefined

    height: contentColumn.height

    QtObject {
        id: prop

        property string _currentOperation: "undefined" // "install" "update" "uninstall" "openPreferences"

        function _currentOperationButton() {
            var currentButton
            if (prop._currentOperation === "install") {
                currentButton = installButton
            } else if (prop._currentOperation === "update") {
                currentButton = updateButton
            }

            return currentButton
        }
    }

    function setData(data) {
        language = data
    }

    function setProgress(status, indeterminate, current, total) {
        var currentButton = prop._currentOperationButton()

        currentButton.progressTitle = status
        currentButton.indeterminate = indeterminate
        if (!indeterminate) {
            currentButton.value = current
            currentButton.to = total
        }
    }

    function resetProgress() {
        var currentButton = prop._currentOperationButton()
        currentButton.indeterminate = false
    }

    signal install(string code)
    signal update(string code)
    signal uninstall(string code)
    signal openPreferences()

    Column {
        id: contentColumn

        anchors.left: parent ? parent.left : undefined
        anchors.right: parent ? parent.right : undefined

        spacing: 42

        StyledTextLabel {
            width: 585

            font.pixelSize: 22
            font.bold: true
            horizontalAlignment: Text.AlignLeft

            text: Boolean(language) ? language.name : ""
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 19

            FlatButton {
                Layout.alignment: Qt.AlignLeft
                text: qsTrc("languages", "Open language preferences")

                onClicked: {
                    prop._currentOperation = "openPreferences"
                    root.openPreferences()
                }
            }

            Row {
                Layout.alignment: Qt.AlignRight

                spacing: 19

                ProgressButton {
                    id: updateButton

                    visible: Boolean(language) ? (language.status === LanguageStatus.NeedUpdate) : false

                    text: qsTrc("languages", "Update available")

                    onClicked: {
                        prop._currentOperation = "update"
                        root.update(language.code)
                    }
                }
                ProgressButton {
                    id: installButton

                    visible: Boolean(language) ? (language.status === LanguageStatus.NoInstalled) : false

                    text: qsTrc("languages", "Install")

                    onClicked: {
                        prop._currentOperation = "install"
                        root.install(language.code)
                    }
                }
                FlatButton {
                    visible: Boolean(language) ? (language.status === LanguageStatus.Installed ||
                                                  language.status === LanguageStatus.NeedUpdate) : false

                    text: qsTrc("languages", "Uninstall")

                    onClicked: {
                        prop._currentOperation = "uninstall"
                        root.uninstall(language.code)
                    }
                }
            }
        }
    }
}
