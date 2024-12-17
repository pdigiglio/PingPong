import Felgo 3.0
import QtQuick 2.0

import "../common"
import ".."

SceneBase {
    id: menuScene

    // signal indicating that the setPlayerNamesScene should be displayed
    //signal setPlayerNamesPressed

    // signal indicating that the newGameScene should be displayed
    signal playPressed

    // signal indicating that the creditsScene should be displayed
    signal creditsPressed

    // background (debugging only)
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "red"
    }

    // background
    Rectangle {
        //anchors.fill: parent.gameWindowAnchorItem
        anchors.fill: parent
        color: "#47688e"
    }

    // the "logo"
    RetroText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 30
        font.pixelSize: 30
        color: "#e9e9e9"
        //text: window.title
        text: "PING PONG"
    }

    // menu
    Column {
        anchors.centerIn: parent
        spacing: 10
        //MenuButton {
        //    text: "Set Player Names"
        //    onClicked: setPlayerNamesPressed()
        //    anchors.horizontalCenter: parent.horizontalCenter
        //}
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

    //// a little Felgo logo is always nice to have, right?
    //Image {
    //    source: "../../assets/img/felgo-logo.png"
    //    width: 60
    //    height: 60
    //    anchors.right: menuScene.gameWindowAnchorItem.right
    //    anchors.rightMargin: 10
    //    anchors.bottom: menuScene.gameWindowAnchorItem.bottom
    //    anchors.bottomMargin: 10
    //}
}
