import Felgo 3.0
import QtQuick 2.0

Item {
    id: field

    // Allow accessing the actual playField from the outside. Useful
    // for positioning elements and setting drag limits.
    readonly property alias playField: playField

    readonly property int playFieldTopY:    playField.y
    readonly property int playFieldBottomY: playField.y + playField.height

    //readonly property int playFieldLeftX:  playField.x
    //readonly property int playFieldRightX: playField.x + playField.width

    readonly property int playFieldCenterY: playField.y + playField.height / 2
    readonly property int playFieldCenterX: playField.x + playField.width  / 2

    property bool infoVisible : true

    property string lineColor : "yellow"
    property int lineWidth: 10

    property string fieldColor: "blue"

    property int p1Score : 0
    property string p1Name: "PL1"

    property int p2Score : 0
    property string p2Name: "PL2"

    signal beginContactWithTopWall(other: Fixture, contactNormal: point)
    signal beginContactWithBottomWall(other: Fixture, contactNormal: point)
    signal beginContactWithLeftBorder(other: Fixture, contactNormal: point)
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
