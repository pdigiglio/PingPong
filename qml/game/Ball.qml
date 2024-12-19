import QtQuick 2.0
import Felgo 3.0


EntityBase {
    id: ballEntity
    entityType: "ball"

    height: 15
    width : 15

    // For some reason, I can't access linearVelocity when either of
    // the colliding objects is of type Body.Static. So I store (and
    // operate on) two more variables for the velocity.
    property int vx: -30
    property int vy: 60

    Rectangle {
        id: rectangle
        anchors.fill: parent

        // Use a different color while dragging (for debugging)
        color: "white"
    }

    BoxCollider {
        id: boxCollider
        anchors.fill: parent

        // The ball won't rotate.
        fixedRotation: true

        linearVelocity: Qt.point(ballEntity.vx, ballEntity.vy)
        linearDamping: 0
        friction: 0
    }

    function bounce(contactNormal, increase= 1) {
        console.log("contactNormal: " + contactNormal);
        console.log("my old vel: " + Qt.point(vx, vy));

        if (contactNormal.x !== 0)
            ballEntity.vx = -ballEntity.vx;

        if (contactNormal.y !== 0)
            ballEntity.vy = -ballEntity.vy;

        // Fix this: make sure that the module does not exceed a certain limit.
        var min = -300;
        var max =  300;
        ballEntity.vx = Math.min(Math.max(increase * ballEntity.vx, min), max);
        ballEntity.vy = Math.min(Math.max(increase * ballEntity.vy, min), max);

        boxCollider.linearVelocity = Qt.point(ballEntity.vx, ballEntity.vy);
        console.log("my new vel: " + boxCollider.linearVelocity);
    }
}
