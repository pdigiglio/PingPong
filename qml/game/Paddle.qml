import QtQuick 2.0
//import QtQuick.VirtualKeyboard 2.15
import Felgo 3.0


Rectangle {
    id: rectangle

    property alias entityId : paddleEntity.entityId

    property int dragMinimumY: 0
    property int dragMaximumY: 0


    //property int upKey   : Qt.Key_K
    //property int downKey : Qt.Key_J

    //property alias y : paddle.y

    //color: mouseArea.pressed ? "blue" : "white"

    color: "white"

    // By default, position the paddle at the vertical middle of the screen.
    //y: (parent.y + parent.height - paddle.height) / 2

    height:  75
    width :  15

    Drag.active: mouseArea.drag.active
    MouseArea {
        id: mouseArea
        anchors.fill: parent

        drag.minimumY: parent.dragMinimumY
        drag.maximumY: parent.dragMaximumY

        drag.target: parent
        drag.axis: Drag.YAxis

        hoverEnabled: true
        onEntered: parent.opacity = 0.8
        onExited:  parent.opacity = 1
    }

    EntityBase {
        id: paddleEntity
        entityType: "paddle"
    }


    //// Handle keyboard inputs (for desktop).
    //focus: true
    //Keys.onPressed: onKeyPressed(event)

    //function onKeyPressed(event) {

    ////Keys.onPressed: {
    //    var accepted = false
    //    var displacement = 10

    //    console.log(paddle + " received " + event.key)
    //    if (event.key === upKey)
    //    {
    //        console.log("Paddle up");
    //        paddle.y += displacement
    //        accepted = true;
    //    }
    //    else if (event.key === downKey)
    //    {
    //        console.log("Paddle down");
    //        paddle.y -= displacement
    //        accepted = true;
    //    }

    //    event.accepted = accepted;
    //}
}
