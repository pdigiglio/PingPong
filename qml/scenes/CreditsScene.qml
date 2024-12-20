import Felgo 3.0
import QtQuick 2.0

import "../common"

SceneBase {
    id:creditsScene

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#47688e"
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: creditsScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: creditsScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        onClicked: backButtonPressed()
    }

    // Credits
    Column {
        anchors.centerIn: parent

        RetroText {
            text: "PING PONG"
            color: "white"
            font.pixelSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RetroText {
            text: "Author:  Paolo Di Giglio"
            color: "white"
            font.pixelSize: 18
        }

        RetroText {
            text: "Version: 1.0.0"
            color: "white"
            font.pixelSize: 18
        }
    }
}
