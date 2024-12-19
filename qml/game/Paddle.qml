import QtQuick 2.0
import QtQuick 2.15 // For DragHandler
import Felgo 3.0


EntityBase {
    id: paddleEntity
    entityType: "paddle"

    height: 75
    width : 15

    property int dragMinimumY: 0
    property int dragMaximumY: 0

    signal beginContact(other: Fixture, contactNormal: point)

    Rectangle {
        id: rectangle
        anchors.fill: parent

        // Use a different color while dragging (for debugging)
        color: dragHandler.active ? "white" : "lightgray"
    }

    DragHandler {
        id: dragHandler
        target: parent

        // TODO: set a sensible value for the margin. How wide
        // is an average thumb?
        margin: 5

        // Only allow vertical drags
        xAxis.enabled: false

        yAxis.enabled: true
        yAxis.minimum: parent.dragMinimumY
        yAxis.maximum: parent.dragMaximumY
    }

    BoxCollider {
        anchors.fill: parent
        bodyType: Body.Static
        fixture.onBeginContact: {
            paddleEntity.beginContact(other, contactNormal);
        }
    }
}
