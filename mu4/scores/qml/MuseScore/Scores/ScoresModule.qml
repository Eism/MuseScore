import QtQuick 2.7
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import MuseScore.UiComponents 1.0
import MuseScore.Scores 1.0

FocusScope {
    id: root

    QtObject {
        id: privateProperties

        readonly property int sideMargin: 134
        readonly property int buttonWidth: 134
    }

    RecentScoresModel {
        id: recentScoresModel
    }

    FilterProxyModel {
        id: recentScoresFilterModel

        sourceModel: recentScoresModel
        searchString: searchLine.text
        searchRoles: [ "title" ]
    }

    Rectangle {
        anchors.fill: parent

        color: ui.theme.backgroundColor
    }

    RowLayout {
        id: topLayout
        anchors.top: parent.top
        anchors.topMargin: 66
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 12

        StyledTextLabel {
            id: pageTitle

            Layout.leftMargin: privateProperties.sideMargin
            Layout.alignment: Qt.AlignLeft

            text: qsTrc("scores", "Scores")

            font.pixelSize: 32
            font.bold: true
        }

        SearchLine {
            id: searchLine

            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            width: pageTitle.width
            Layout.rightMargin: privateProperties.sideMargin
            Layout.alignment: Qt.AlignLeft
        }
    }

    Column {
        anchors.top: topLayout.bottom
        anchors.topMargin: 74
        anchors.left: parent.left
        anchors.leftMargin: privateProperties.sideMargin
        anchors.right: parent.right
        anchors.rightMargin: privateProperties.sideMargin

        spacing: 24

        StyledTextLabel {
            text: qsTrc("scores", "New & recent")

            font.pixelSize: 18
            font.bold: true
        }

        Item {
            anchors.left: parent.left
            anchors.leftMargin: -32.8
            anchors.right: parent.right
            anchors.rightMargin: -32.8
            height: recentScoresView.contentHeight

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
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

            GridView {
                id: recentScoresView

                model: recentScoresFilterModel

                width: parent.width
                height: 658

                clip: true

                cellHeight: 334
                cellWidth: 237.6

                delegate: Item {
                    height: recentScoresView.cellHeight
                    width: recentScoresView.cellWidth

                    ScoreItem {
                        anchors.centerIn: parent

                        height: 272
                        width: 172

                        title: score.title
                        thumbnail: score.thumbnail
                        isAdd: index === 0

                        onClicked: {
                            recentScoresModel.openRecentScore(index)
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
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
        }
    }

    Rectangle {
        id: buttons

        anchors.bottom: parent.bottom

        height: 114
        width: parent.width
        opacity: 0.75

        color: ui.theme.popupBackgroundColor

        Row {
            anchors.right : parent.right
            anchors.rightMargin: privateProperties.sideMargin
            anchors.verticalCenter: parent.verticalCenter

            spacing: 22

            FlatButton {
                width: privateProperties.buttonWidth
                text: qsTrc("scores", "New")

                onClicked: {
                    recentScoresModel.newScore()
                }
            }

            FlatButton {
                width: privateProperties.buttonWidth
                text: qsTrc("scores", "Open other...")

                onClicked: {
                    recentScoresModel.openScore()
                }
            }
        }
    }
}
