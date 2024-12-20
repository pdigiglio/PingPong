import Felgo 3.0
import QtQuick 2.0
import QtQuick 2.15

import "../common"
import "../game"

/*!
    \qmltype GameScene
    \inqmlmodule Scenes

    The scene where the actual game happens.
 */
SceneBase {
    id: gameScene

    /*!
        \qmlproperty int p1Score

        The score of the first player.
     */
    property int p1Score:  0

    /*!
        \qmlproperty string p1Name

        The name of the first player.
     */
    property string p1Name: "PL1"

    /*!
        \qmlproperty int p2Score

        The score of the second player.
     */
    property int p2Score:  0

    /*!
        \qmlproperty string p2Name

        The name of the second player.
     */
    property string p2Name: "PL2"

    /*!
        \qmlproperty string lineColor

        The color of the field line.
     */
    property string lineColor : "yellow"

    /*!
        \qmlproperty string fieldColor

        The color of the field.
     */
    property string fieldColor: "#47688e"

    /*!
        \qmlproperty int fieldLineWidth

        The width of the lines to be drawn on the field.
     */
    property int fieldLineWidth : 10

    /*!
        \qmlproperty int paddleHorizontalMargin

        The horizontal distence (in pixel) of the paddle from either
        side of the field.
     */
    readonly property int paddleHorizontalMargin : 5

    /*!
        \qmlsignal gameEnded(string winner)

        \a winner The name of the winner.

        A signal that gets emitted when the game ends (i.e. one of the players
        is not able to catch the ball).
     */
    signal gameEnded(winner: string)

    /*!
        \qmlproperty string gameState

        The game will have 3 states:

         (todo)
         * wait: The ball won't move. The game starts after both player move the
         paddle (meaning they're ready).

         * play: Actual game.

         * gameEnded: Either player failed to catch the ball, meaning the other
         player wins.
     */
    property string gameState: "play"

    PhysicsWorld {
        // The physics simulation will only be running in "play" mode.
        running: gameState === "play"

        debugDrawVisible: true
        z: 1000
    }

    // Background (this will fill the screen outside of the field)
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: parent.fieldColor
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

    /*!
        \qmlmethod playerWins(string winner)

        Handle the event where either player wins.

        This handler will update the scores of the plaers, change the scene
        state and signal that the game has handed for other components to
        react.
     */
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

    /*!
        \qmlmethod resetScores()

        Reset the scores, tipically before starting a new game.
     */
    function resetScore() {
        gameScene.p1Score = 0;
        gameScene.p2Score = 0;
    }

    /*!
        \qmlmethod playNewGame()

        Play a new game.

        Reset the position of the ball and the paddles. The score is not reset.
     */
    function playNewGame() {
        ball.x = field.playFieldCenterY;
        ball.y = field.playFieldCenterX;
        ball.initVelocity();

        p1Paddle.y = field.playFieldCenterY - p1Paddle.height / 2;
        p2Paddle.y = field.playFieldCenterY - p2Paddle.height / 2;

        gameScene.gameState = "play";
    }
}
