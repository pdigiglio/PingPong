import QtQuick 2.0

Rectangle {
    id: button

    // this will be the default size, it is same size as the contained text + some padding
    width:  buttonText.width  + 2 * paddingHorizontal
    height: buttonText.height + 2 * paddingVertical

    // Don't draw the actual button. I'll delimit its area with a
    // pair of square brackets.
    color: "transparent"

    // Draw a border (for debugging)
    //border.color: "red"

    // the horizontal margin from the Text element to the Rectangle at both the left and the right side.
    property int paddingHorizontal: 10

    // the vertical margin from the Text element to the Rectangle at both the top and the bottom side.
    property int paddingVertical: 5

    // Expose a "text" property.
    property string text: "button"

    // Allow accessing the Text.color property.
    property alias textColor: buttonText.text

    // Allow accessing the Text.font.pixelSize property.
    property alias fontSizePx: buttonText.font.pixelSize

    // this handler is called when the button is clicked.
    signal clicked

    RetroText {
        id: buttonText
        anchors.centerIn: parent
        font.pixelSize: 18
        color: "yellow"
        text: mouseArea.containsMouse ? "[-" + button.text + "-]" : "[ " + button.text + " ]"
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: button.clicked()

        onPressed: button.opacity = 0.5
        onReleased: button.opacity = 1

        onEntered: button.opacity = 0.8
        onExited:  button.opacity = 1
    }
}
