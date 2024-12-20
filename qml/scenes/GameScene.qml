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

    function resetScore() {
        gameScene.p1Score = 0;
        gameScene.p2Score = 0;
    }

    function playNewGame() {
        ball.x = field.playFieldCenterY;
        ball.y = field.playFieldCenterX;
        ball.initVelocity();

        p1Paddle.y = field.playFieldCenterY - p1Paddle.height / 2;
        p2Paddle.y = field.playFieldCenterY - p2Paddle.height / 2;

        gameScene.gameState = "play";
    }
}
