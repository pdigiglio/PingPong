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
        \qmlproperty real vx

        The ball velocity along the \c x axis.
     */
    property real vx: -30

    /*!
        \qmlproperty real vy

        The ball velocity along the \c y axis.
     */
    property real vy: 60

    /*!
        \qmlproperty real maxVelocityModule

        The maximum velocity of the ball.
     */
    readonly property real maxVelocityModule: 400;

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
        increase = this.getClampedIncrease(increase, ballEntity.vx, ballEntity.vy);

        ballEntity.vx *= increase;
        ballEntity.vy *= increase;

        boxCollider.linearVelocity = Qt.point(ballEntity.vx, ballEntity.vy);
        console.log("my new vel: " + boxCollider.linearVelocity + ";  |.|: ", Math.hypot(ballEntity.vx, ballEntity.vy));
    }

    /*!
        \qmlmethod getClampedIncrease

        Returns a multiplicative factor for the velocity such that its
        module does not exceed \c maxVelocityModule.
    */
    function getClampedIncrease(increase: real, vx: real, vy: real)
    {
        var v = increase * Math.hypot(vx, vy);
        if (v > this.maxVelocityModule)
        {
            var clampedIncrease = increase * this.maxVelocityModule / v;
            increase = clampedIncrease;
        }

        return increase;
    }

    /*!
        \qmlmethod generateRandomVelocity

        Return a velocity whose module is \c velocityModule. The velocity quadrant
        is chosen at random. The angle of the velocity is also chosen at random in
        the range [30 deg, 60 deg].
    */
    function generateRandomVelocity(velocityModule: real) {
        var minAngle = Math.PI / 6;
        var maxAngle = Math.PI / 3;
        console.assert(minAngle <= maxAngle, "min angle greater than max angle");

        // Generate a random angle in range [minAngle, maxAngle].
        // Note: Math.random() returns a number in [0, 1].
        var randomAngle = minAngle + (maxAngle - minAngle) * Math.random();

        // Generate random signs.
        var xSign = (Math.random() < 0.5) ? -1 : +1;
        var ySign = (Math.random() < 0.5) ? -1 : +1;

        velocityModule = Math.min(velocityModule, this.maxVelocityModule);
        var v = Qt.point(
            velocityModule * xSign * Math.cos(randomAngle),
            velocityModule * ySign * Math.sin(randomAngle));

        console.log("Initial ball velocity: " + v + " with angle: " + randomAngle + " rad");
        return v;
    }


    /*!
        \qmlmethod initVelocity()

        Set initial kinematic parameters for the ball. The user is supposed to
        call this method when starting a new game.
     */
    function initVelocity() {
        var v = this.generateRandomVelocity(75);

        ballEntity.vx = v.x;
        ballEntity.vy = v.y;
        boxCollider.linearVelocity = v;
    }
}
