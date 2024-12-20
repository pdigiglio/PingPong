import QtQuick 2.0
import QtQuick 2.15 // For DragHandler
import Felgo 3.0


/*!
    \qmltype Paddle
    \inqmlmodule Game

    A component representing a paddle.
 */
EntityBase {
    id: paddleEntity
    entityType: "paddle"

    height: 75
    width : 15


    /*!
        \qmlproperty int dragMinimumY

        The minimum value of \c y the paddle can be dragged to.
        The top of the playfield is a sensible value.
     */
    property int dragMinimumY: 0

    /*!
        \qmlproperty int dragMaximumY

        The maximum value of \c y the paddle can be dragged to.
        The top of the playfield is a sensible value.
     */
    property int dragMaximumY: 0

    /*!
        \qmlsignal beginContact(Fixture other, point contactNormal)

        \a other         The fixture of the other colliding body.
        \a contactNormal The direction of the contact normal.

        A signal that gets emitted when the \c BoxCollider detects a collision.
     */
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
