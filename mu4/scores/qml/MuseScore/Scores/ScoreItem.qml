import QtQuick 2.7
import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0
import MuseScore.Scores 1.0

Item {
    id: root

    property string title: ""
    property int daysAgoCount: 0
    property alias thumbnail: loader.thumbnail
    property bool isAdd: false

    signal clicked()

    Column {
        anchors.fill: parent

        spacing: 16

        Loader {
            id: loader

            height: 224
            width: 172

            property var thumbnail: undefined

            sourceComponent: isAdd ? addComp : thumbnailComp

            onLoaded: {
                if (!isAdd) {
                    item.setThumbnail(thumbnail)
                }
            }
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: 4

            StyledTextLabel {
                anchors.horizontalCenter: parent.horizontalCenter

                text: root.title
            }

            StyledTextLabel {
                anchors.horizontalCenter: parent.horizontalCenter

                text: root.daysAgoCount + qsTrc("scores", " DAYS AGO")
                font.pixelSize: 12

                visible: !isAdd
            }
        }
    }

    Component {
        id: thumbnailComp

        ScoreThumbnail {
            anchors.fill: parent

            radius: 3
        }
    }

    Component {
        id: addComp

        Rectangle {
            anchors.fill: parent

            color: "#FFFFFF"

            radius: 3

            StyledIconLabel {
                anchors.centerIn: parent

                iconCode: IconCode.PLUS

                font.pixelSize: 50
            }
        }

    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            root.clicked()
        }
    }
}
