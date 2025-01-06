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

        console.log("Contact normal: " + contactNormal);
        console.log("Ball velocity before contact: " + Qt.point(this.vx, this.vy));

        if (contactNormal.x !== 0)
            this.vx = -this.vx;

        if (contactNormal.y !== 0)
            this.vy = -this.vy;

        // Make sure the module of the velocity is at most maxVelocityModule.
        increase = this.getClampedIncrease(increase, this.vx, this.vy);

        this.vx *= increase;
        this.vy *= increase;

        boxCollider.linearVelocity = Qt.point(this.vx, this.vy);
        console.log("Ball velocity after contact: " + boxCollider.linearVelocity + "; |.|: ", Math.hypot(this.vx, this.vy));
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
        \qmlmethod generateRandomVelocity(real velocityModule)

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

        return v;
    }

    /*!
        \qmlmethod initVelocity()

        Set initial kinematic parameters for the ball.
     */
    function initVelocity() {
        var v = this.generateRandomVelocity(75);

        this.vx = v.x;
        this.vy = v.y;
        boxCollider.linearVelocity = v;

        console.log("Initial ball velocity: " + v);
    }

    /*!
        \qmlmethod generateRandomPos(rect fieldArea)

        Return a position whose \c x is in the middle of \c fieldArea and whose
        \c y is chosen at random within \c fieldArea.
    */
    function generateRandomPos(fieldArea: Qt.rect) {
        var yMax = fieldArea.y + fieldArea.height - this.height;
        var yMin = fieldArea.y;

        var ballHalfWidth = this.width / 2;
        var fieldHalfWidth = fieldArea.width / 2;

        var pos = Qt.point(
            // Always start in x-center.
            fieldArea.x + fieldHalfWidth - ballHalfWidth,
            // Generate random y (within the field).
            yMin + (yMax - yMin) * Math.random());

        return pos;
    }

    /*!
        \qmlmethod initPosition(rect fieldArea)

        Set the initial position of the ball within \c fieldArea.
     */
    function initPosition(fieldArea: Qt.rect) {
        var initPos = this.generateRandomPos(fieldArea);
        this.x = initPos.x;
        this.y = initPos.y;

        console.log("Initial ball position: " + initPos);
    }

    /*!
        \qmlmethod init(rect fieldArea)

        Initialize the ball within the \c fieldArea before starting a new game.
     */
    function init(fieldArea: Qt.rect) {
        this.initPosition(fieldArea);
        this.initVelocity();
    }
}
