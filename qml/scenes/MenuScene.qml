import Felgo 3.0
import QtQuick 2.0

import "../common"

SceneBase {
    id: menuScene

    // Allow changin the title from the outside.
    property string title : "PING PONG"

    // Signal indicating that the newGameScene should be displayed
    signal playPressed

    // Signal indicating that the creditsScene should be displayed
    signal creditsPressed

    // Background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#47688e"
    }

    // The title
    RetroText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 30
        font.pixelSize: 30
        color: "#e9e9e9"
        text: menuScene.title
    }

    // The menu
    Column {
        anchors.centerIn: parent
        spacing: 10
        MenuButton {
            text: "Play"
            onClicked: playPressed()
            anchors.horizontalCenter: parent.horizontalCenter
        }
        MenuButton {
            text: "Credits"
            onClicked: creditsPressed()
            anchors.horizontalCenter: parent.horizontalCenter
        }
        MenuButton {
            text: "Quit"
            onClicked: backButtonPressed()
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
