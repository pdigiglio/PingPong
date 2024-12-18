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

    // Allow setting my color from outside.
    property alias color: text.color

    // Allow setting my text from outside.
    property alias text : text.text

    // Allow setting my opacity from outside.
    property alias textOpacity : text.opacity

    // the horizontal margin from the Text element to the Rectangle at both the left and the right side.
    property int paddingHorizontal: 10

    // the vertical margin from the Text element to the Rectangle at both the top and the bottom side.
    property int paddingVertical: 5

    Common.RetroText {
        id: text

        anchors.centerIn: parent

        font.pixelSize: 52
        opacity: 0.3
    }
}
