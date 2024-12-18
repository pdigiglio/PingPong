import QtQuick 2.0
import QtQuick 2.15 // For DragHandler
import Felgo 3.0


Rectangle {
    id: rectangle

    // Use a different color while dragging (for debugging)
    color: dragHandler.active ? "white" : "lightgray"

    height:  75
    width :  15

    property alias entityId : paddleEntity.entityId

    property int dragMinimumY: 0
    property int dragMaximumY: 0

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

    EntityBase {
        id: paddleEntity
        entityType: "paddle"
    }
}
