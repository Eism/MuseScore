import QtQuick 2.7
import MuseScore.UiComponents 1.0
import MuseScore.Scores 1.0

FocusScope {

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

    StyledTextLabel {
        anchors.bottom: scoresRect.top
        anchors.bottomMargin: 25
        anchors.left: scoresRect.left

        font.pixelSize: 30

        text: qsTrc("scores", "Scores")
    }

    SearchLine {
        id: searchLine

        anchors.bottom: scoresRect.top
        anchors.bottomMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: scoresRect

        anchors.fill: parent
        anchors.topMargin: 100
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        anchors.bottomMargin: 75

        color: ui.theme.popupBackgroundColor
        border.color: ui.theme.strokeColor
        border.width: 1
        radius: 15

        GridView {
            id: view

            anchors.fill: parent
            anchors.margins: 50

            model: recentScoresFilterModel

            clip: true

            cellHeight: 200
            cellWidth: 160

            boundsBehavior: Flickable.StopAtBounds

            delegate: Item {
                height: view.cellHeight
                width: view.cellWidth

                ScoreItem {
                    anchors.centerIn: parent

                    height: 150
                    width: 100

                    title: score.title
                    thumbnail: score.thumbnail
                    isAdd: index === 0

                    onClicked: {
                        recentScoresModel.openRecentScore(index)
                    }
                }
            }
        }
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16

        spacing: 20

        FlatButton {
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            width: 100
            text: qsTrc("scores", "Open a score")
            onClicked: recentScoresModel.openScore()
        }

        FlatButton {
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            width: 100
            text: qsTrc("scores", "Import")
            onClicked: recentScoresModel.importScore()
        }
    }
}
