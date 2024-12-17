import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: retroButton

    property string text: "button"

    // Signal is called "clicked" and slot will be called "onClicked".
    signal clicked

    Button {
        text: "[ " + retroButton.text + " ]"
        onClicked: retroButton.clicked()
    }
}
