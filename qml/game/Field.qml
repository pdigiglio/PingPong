import Felgo 3.0
import QtQuick 2.0

/*!
    \qmltype Field
    \inqmlmodule Game

    A component representing the play field.
 */
Item {
    id: field

    // Allow accessing the actual playField from the outside. Useful
    // for positioning elements and setting drag limits.


    /*!
        \qmlproperty Rectangle playField

        The actual play field (excluding the top and bottom lines).
        Accessing this property is useful for positioning elements
        and setting drag limits.
     */
    readonly property alias playField: playField

    /*!
        \qmlproperty int playFieldTopY

        The \c y coordinate of the play field top.
     */
    readonly property int playFieldTopY:    playField.y

    /*!
        \qmlproperty int playFieldBottomY

        The \c y coordinate of the play field bottom.
     */
    readonly property int playFieldBottomY: playField.y + playField.height

    /*!
        \qmlproperty int playFieldCenterY

        The \c y coordinate of the play field center.
     */
    readonly property int playFieldCenterY: playField.y + playField.height / 2

    /*!
        \qmlproperty int playFieldCenterX

        The \c x coordinate of the play field center.
     */
    readonly property int playFieldCenterX: playField.x + playField.width  / 2

    /*!
        \qmlproperty bool infoVisible

        Get or set whether the overlay text about the player information should be visible.
        By default, the this property is \c true.
     */
    property bool infoVisible : true

    /*!
        \qmlproperty string lineColor

        The color of the field line.
     */
    property string lineColor : "yellow"

    /*!
        \qmlproperty int lineWidth

        The width of the field line.
     */
    property int lineWidth: 10

    /*!
        \qmlproperty string fieldColor

        The color of the field.
     */
    property string fieldColor: "blue"

    /*!
        \qmlproperty int p1Score

        The score of the first player.
     */
    property int p1Score : 0

    /*!
        \qmlproperty string p1Name

        The name of the first player.
     */
    property string p1Name: "PL1"

    /*!
        \qmlproperty int p2Score

        The score of the second player.
     */
    property int p2Score : 0

    /*!
        \qmlproperty string p2Name

        The name of the second player.
     */
    property string p2Name: "PL2"

    /*!
        \qmlsignal beginContactWithTopWall(Fixture other, point contactNormal)

        \a other         The fixture of the other colliding body.
        \a contactNormal The direction of the contact normal.

        A signal that gets emitted when the \c BoxCollider of the top wall detects a collision.
     */
    signal beginContactWithTopWall(other: Fixture, contactNormal: point)

    /*!
        \qmlsignal beginContactWithBottomWall(Fixture other, point contactNormal)

        \a other         The fixture of the other colliding body.
        \a contactNormal The direction of the contact normal.

        A signal that gets emitted when the \c BoxCollider of the bottom wall detects a collision.
     */
    signal beginContactWithBottomWall(other: Fixture, contactNormal: point)

    /*!
        \qmlsignal beginContactWithLeftBorder(Fixture other, point contactNormal)

        \a other         The fixture of the other colliding body.
        \a contactNormal The direction of the contact normal.

        A signal that gets emitted when the \c BoxCollider of the left border detects a collision.
        This means that player 2 is the winner.
     */
    signal beginContactWithLeftBorder(other: Fixture, contactNormal: point)

    /*!
        \qmlsignal beginContactWithRightBorder(Fixture other, point contactNormal)

        \a other         The fixture of the other colliding body.
        \a contactNormal The direction of the contact normal.

        A signal that gets emitted when the \c BoxCollider of the right border detects a collision.
        This means that player 1 is the winner.
     */
    signal beginContactWithRightBorder(other: Fixture, contactNormal: point)

    // Make a rectangle as big as the scene, with the same color
    // as the line. I'll draw another rectangle on top with a bit
    // of vertical margin to make sure the top/bottom field lines
    // are visible.
    Rectangle {
        anchors.fill: parent
        color: lineColor
    }

    // Draw a shorter rectangle on top of the previous one so that
    // the field top/bottom lines get drawn. The paddle items will
    // only be allowed to move within the height of this rectangle
    // (which, then, represents the actual field).
    Rectangle {
        id: playField

        anchors.fill: parent
        anchors.topMargin:    parent.lineWidth
        anchors.bottomMargin: parent.lineWidth

        color: parent.fieldColor
    }

    // Draw a line to the left of the playfield. This line may be
    // hidden on some screens (but it's fine).
    Rectangle {
        id: leftLine

        anchors.left:   parent.right
        anchors.top:    parent.top
        anchors.bottom: parent.bottom

        width: parent.lineWidth
        color: parent.lineColor
    }

    // Draw a line to the right of the playfield. This line may be
    // hidden on some screens (but it's fine).
    Rectangle {
        id: rightLine

        anchors.right:  parent.left
        anchors.top:    parent.top
        anchors.bottom: parent.bottom

        width: parent.lineWidth
        color: parent.lineColor
    }

    // Draw a vertical dashed line to visually separate the field
    // for each player.
    Column {
        id: fieldSeparator

        property int dashCount: 10
        property int dashLen: parent.height / (2 * dashCount)

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: dashLen / 2
        spacing: dashLen

        Repeater {
            model: parent.dashCount
            Rectangle {
                height: parent.dashLen
                width: field.lineWidth
                color: lineColor
            }
        }
    }

    // Make top wall bounceable
    BoxCollider {
        id: topWallEntity
        bodyType: Body.Static
        anchors.top: field.playField.top
        anchors.bottom: field.top

        fixture.onBeginContact: {
            field.beginContactWithTopWall(other, contactNormal);
        }
    }

    // Make bottom wall bounceable
    BoxCollider {
        id: bottomWallEntity
        bodyType: Body.Static
        anchors.top:    field.playField.bottom
        anchors.bottom: field.bottom

        fixture.onBeginContact: {
            field.beginContactWithBottomWall(other, contactNormal);
        }
    }

    // Make bottom wall bounceable
    BoxCollider {
        id: p1LoseCollider
        bodyType: Body.Static
        anchors.top:    field.playField.top
        anchors.bottom: field.playField.bottom
        anchors.left:   field.left
        width: 1

        fixture.onBeginContact: {
            field.beginContactWithLeftBorder(other, contactNormal);
        }
    }

    // Make bottom wall bounceable
    BoxCollider {
        id: p2LoseCollider
        bodyType: Body.Static
        anchors.top:    field.playField.top
        anchors.bottom: field.playField.bottom
        anchors.right:  field.right
        width: 1

        fixture.onBeginContact: {
            field.beginContactWithRightBorder(other, contactNormal);
        }
    }

    // Information about players

    InfoText {
        id: p1ScoreText

        visible: parent.infoVisible
        anchors.bottom: playField.bottom
        anchors.right:  fieldSeparator.left

        text: p1Score
        color: parent.lineColor
    }

    InfoText {
        id: p1NameText

        visible: parent.infoVisible
        anchors.top:   playField.top
        anchors.right: fieldSeparator.left

        text: p1Name
        color: parent.lineColor
    }

    InfoText {
        id: p2ScoreText

        visible: parent.infoVisible
        anchors.bottom: playField.bottom
        anchors.left:   fieldSeparator.right

        text: p2Score
        color: parent.lineColor
    }

    InfoText {
        id: p2NameText

        visible: parent.infoVisible
        anchors.top:  playField.top
        anchors.left: fieldSeparator.right

        text: p2Name
        color: parent.lineColor
    }
}
