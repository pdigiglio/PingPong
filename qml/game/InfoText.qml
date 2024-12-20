import QtQuick 2.0

import "../common" as Common

/*!
    \qmltype InfoText
    \inqmlmodule Game

    A text box to display player information (e.g. name or score) in the game scene.
 */
Item {
    id: infoText

    // This will be the default size, it is same size as the contained text + some padding
    width:  text.width  + 2 * paddingHorizontal
    height: text.height + 2 * paddingVertical

    /*!
        \qmlproperty string color

        The text color.
     */
    property alias color: text.color

    /*!
        \qmlproperty string text

        The text string.
     */
    property alias text : text.text

    /*!
        \qmlproperty real textOpacity

        The text opacity.
     */
    property alias textOpacity : text.opacity

    /*!
        \qmlproperty int paddingHorizontal

        The horizontal margin from the Text element to the Rectangle at both the left and the right side.
     */
    property int paddingHorizontal: 10

    /*!
        \qmlproperty int paddingVertical

        The vertical margin from the Text element to the Rectangle at both the top and the bottom side.
     */
    property int paddingVertical: 5

    Common.RetroText {
        id: text

        anchors.centerIn: parent

        font.pixelSize: 52
        opacity: 0.3
    }
}
