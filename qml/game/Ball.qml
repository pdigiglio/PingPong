import QtQuick 2.0
import Felgo 3.0


/*!
    \qmltype Ball
    \inqmlmodule Game

    A component representing a bouncing ball.
 */
EntityBase {
    id: ballEntity
    entityType: "ball"

    height: 15
    width : 15

    /*!
        \qmlproperty int vx

        The ball velocity along the \c x axis.
     */
    property int vx: -30

    /*!
        \qmlproperty int vy

        The ball velocity along the \c y axis.
     */
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

    /*!
        \qmlmethod bounce(point contactNormal, real increase = 1)

        \a contactNormal The direction of the contact normal.
        \a increase      A multiplicative increase in the velocity.

        Bounce the ball (typically after a collision), possibly changing its
        velocity by a factor of \c increase (up to a certain hard-coded amount).
     */
    function bounce(contactNormal, increase = 1) {
        // For some reason, I can't access linearVelocity when either of
        // the colliding objects is of type Body.Static. So I store (and
        // operate on) two more variables (i.e. vx, vy) for the velocity.

        console.log("contactNormal: " + contactNormal);
        console.log("my old vel: " + Qt.point(vx, vy));

        if (contactNormal.x !== 0)
            ballEntity.vx = -ballEntity.vx;

        if (contactNormal.y !== 0)
            ballEntity.vy = -ballEntity.vy;

        // Make sure the module of the velocity is at most maxVelocityModule.
        var maxVelocityModule = 400;
        var v = increase * Math.hypot(ballEntity.vx, ballEntity.vy);
        if (v > maxVelocityModule)
            increase *= maxVelocityModule / v;

        ballEntity.vx *= increase;
        ballEntity.vy *= increase;

        boxCollider.linearVelocity = Qt.point(ballEntity.vx, ballEntity.vy);
        console.log("my new vel: " + boxCollider.linearVelocity + "; ; |.|: ", Math.hypot(ballEntity.vx, ballEntity.vy));
    }

    /*!
        \qmlmethod initVelocity()

        Set initial kinematic parameters for the ball. The user is supposed to
        call this method when starting a new game.
     */
    function initVelocity() {
        ballEntity.vx = -30;
        ballEntity.vy = 60;

        boxCollider.linearVelocity = Qt.point(ballEntity.vx, ballEntity.vy);
    }
}
