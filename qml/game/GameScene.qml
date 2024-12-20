import Felgo 3.0
import QtQuick 2.0
import QtQuick 2.15
import "../common"

SceneBase {
    id: gameScene

    property int p1Score:  0
    property string p1Name: "PL1"

    property int p2Score:  0
    property string p2Name: "PL2"

    property string lineColor : "yellow"
    property string fieldColor: "#47688e"

    // The width of the lines to be drawn on the field.
    property int fieldLineWidth : 10

    readonly property int paddleHorizontalMargin : 5

    signal gameEnded(winner: string)

    // The game will have 3 states:
    //
    //  (todo)
    //  * wait: The ball won't move. The game starts after both player move the
    //  paddle (meaning they're ready).
    //
    //  * play: Actual game.
    //
    //  * gameEnded: Either player failed to catch the ball, meaning the other
    //  player wins.
    property string gameState: "play"

    PhysicsWorld {
        // The physics simulation will only be running in "play" mode.
        running: gameState === "play"

        debugDrawVisible: true
        z: 1000
    }

    // background (debugging only)
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "red"
    }

    // Draw the playing field. Make sure to insert this before
    // the paddles and ball, otherwise they'll not be visible.
    // Otherwise, you could manually specify the "z" property.
    Field {
        id: field
        anchors.fill: parent

        fieldColor: parent.fieldColor
        lineColor : parent.lineColor
        lineWidth: parent.fieldLineWidth

        p1Score: parent.p1Score
        p1Name: parent.p1Name

        p2Score: parent.p2Score
        p2Name: parent.p2Name

        onBeginContactWithTopWall:    { ball.bounce(contactNormal, 1); }
        onBeginContactWithBottomWall: { ball.bounce(contactNormal, 1); }

        onBeginContactWithRightBorder: { gameScene.playerWins(gameScene.p1Name); }
        onBeginContactWithLeftBorder:  { gameScene.playerWins(gameScene.p2Name); }

        //infoVisible: false
    }

    Paddle {
        id: p1Paddle
        entityId: "p1Paddle"

        dragMinimumY: field.playFieldTopY
        dragMaximumY: field.playFieldBottomY - p1Paddle.height

        y: field.playFieldCenterY - height / 2
        anchors.left: field.left
        anchors.leftMargin: parent.paddleHorizontalMargin

        onBeginContact: { ball.bounce(contactNormal, 2); }
    }

    Paddle {
        id: p2Paddle
        entityId: "p2Paddle"

        dragMinimumY: field.playFieldTopY
        dragMaximumY: field.playFieldBottomY - p1Paddle.height

        y: field.playFieldCenterY - height / 2
        anchors.right: field.right
        anchors.rightMargin: parent.paddleHorizontalMargin

        onBeginContact: { ball.bounce(contactNormal, 2); }
    }

    Ball {
        id: ball
        entityId: "ball"

        x: field.playFieldCenterY
        y: field.playFieldCenterX
    }

    function playerWins(winner) {
        console.log(winner + " wins!");
        if (winner === gameScene.p1Name)
        {
            ++gameScene.p1Score;
        }
        else if (winner === gameScene.p2Name)
        {
            ++gameScene.p2Score;
        }

        gameScene.gameState = "gameEnded";

        // Emit the signal
        gameScene.gameEnded(winner);
    }


    //// the filename of the current level gets stored here, it is used for loading the
    //property string activeLevelFileName
    //// the currently loaded level gets stored here
    //property variant activeLevel
    //// score
    //property int score: 0
    //// countdown shown at level start
    //property int countdown: 0
    //// flag indicating if game is running
    //property bool gameRunning: countdown == 0

    //// set the name of the current level, this will cause the Loader to load the corresponding level
    //function setLevel(fileName) {
    //    activeLevelFileName = fileName
    //}

    //// background
    //Rectangle {
    //    anchors.fill: parent.gameWindowAnchorItem
    //    color: "#dd94da"
    //}

    //// back button to leave scene
    //MenuButton {
    //    text: "Back to menu"
    //    // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
    //    anchors.right: gameScene.gameWindowAnchorItem.right
    //    anchors.rightMargin: 10
    //    anchors.top: gameScene.gameWindowAnchorItem.top
    //    anchors.topMargin: 10
    //    onClicked: {
    //        backButtonPressed()
    //        activeLevel = undefined
    //        activeLevelFileName = ""
    //    }
    //}

    //// name of the current level
    //Text {
    //    anchors.left: gameScene.gameWindowAnchorItem.left
    //    anchors.leftMargin: 10
    //    anchors.top: gameScene.gameWindowAnchorItem.top
    //    anchors.topMargin: 10
    //    color: "white"
    //    font.pixelSize: 20
    //    text: activeLevel !== undefined ? activeLevel.levelName : ""
    //}

    //// load levels at runtime
    //Loader {
    //    id: loader
    //    source: activeLevelFileName != "" ? "../levels/" + activeLevelFileName : ""
    //    onLoaded: {
    //        // reset the score
    //        score = 0
    //        // since we did not define a width and height in the level item itself, we are doing it here
    //        item.width = gameScene.width
    //        item.height = gameScene.height
    //        // store the loaded level as activeLevel for easier access
    //        activeLevel = item
    //        // restarts the countdown
    //        countdown = 3
    //    }
    //}

    //// we connect the gameScene to the loaded level
    //Connections {
    //    // only connect if a level is loaded, to prevent errors
    //    target: activeLevel !== undefined ? activeLevel : null
    //    // increase the score when the rectangle is clicked
    //    onRectanglePressed: {
    //        // only increase score when game is running
    //        if(gameRunning) {
    //            score++
    //        }
    //    }
    //}

    //// name of the current level
    //Text {
    //    anchors.horizontalCenter: parent.horizontalCenter
    //    anchors.top: gameScene.gameWindowAnchorItem.top
    //    anchors.topMargin: 30
    //    color: "white"
    //    font.pixelSize: 40
    //    text: score
    //}

    //// text displaying either the countdown or "tap!"
    //Text {
    //    anchors.centerIn: parent
    //    color: "white"
    //    font.pixelSize: countdown > 0 ? 160 : 18
    //    text: countdown > 0 ? countdown : "tap!"
    //}

    //// if the countdown is greater than 0, this timer is triggered every second, decreasing the countdown (until it hits 0 again)
    //Timer {
    //    repeat: true
    //    running: countdown > 0
    //    onTriggered: {
    //        countdown--
    //    }
    //}
}
