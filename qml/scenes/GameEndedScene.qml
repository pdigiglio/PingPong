import Felgo 3.0
import QtQuick 2.0

import "../common"

SceneBase {
    id: gameEnded

    property string text: "Game Ended"

    // signal indicating that the "keep playing" button was pressed
    signal keepPlayingButtonPressed

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#47688e"
    }

    // the "title"
    RetroText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 30
        font.pixelSize: 30
        color: "#e9e9e9"
        text: gameEnded.text
    }

    // menu
    Column {
        anchors.centerIn: parent
        spacing: 10
        MenuButton {
            text: "Keep Playing"
            onClicked: keepPlayingButtonPressed()
            anchors.horizontalCenter: parent.horizontalCenter
        }
        MenuButton {
            text: "Back"
            onClicked: backButtonPressed()
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
