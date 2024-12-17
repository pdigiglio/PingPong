import QtQuick 2.0

import "../common" as Common

/*!
  A text box to display player information (e.g. name and score) in the game scene.
 */
Item {
    id: infoText

    // this will be the default size, it is same size as the contained text + some padding
    width:  text.width  + 2 * paddingHorizontal
    height: text.height + 2 * paddingVertical

    property alias color: text.color
    property alias text : text.text

    // the horizontal margin from the Text element to the Rectangle at both the left and the right side.
    property int paddingHorizontal: 10

    // the vertical margin from the Text element to the Rectangle at both the top and the bottom side.
    property int paddingVertical: 5

    //Rectangle {
    //    anchors.fill: parent
    //    border.color: "red"
    //}

    Common.RetroText {
        id: text

        anchors.centerIn: parent

        text: ""
        color: "yellow"
        font.pixelSize: 52
        opacity: 0.5
    }
}

