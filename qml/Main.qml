import Felgo 3.0
import QtQuick 2.0

import "scenes"
import "game" as Game

// TODO
//  1. Add a new scene: "winner wins" continue|goto menu
//  2. Fill in the credit page
//  3. start ball with random velocity
//  4. Improve the way I clamp the velocity
//  5. clean up files I don't need

GameWindow {
    id: window
    screenWidth: 960
    screenHeight: 640

    // Force landscape layout.
    //
    // NOTE: if the phone gets rotated, the GameWindow will get
    //       rotated as well but the aspect ratio won't change.
    //
    // TODO: prevent rotation altogether.
    landscape: true

    // create and remove entities at runtime
    EntityManager {
        id: entityManager
    }

    // menu scene
    MenuScene {
        id: menuScene

        onPlayPressed:    window.state = "game"
        onCreditsPressed: window.state = "credits"
        // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
        onBackButtonPressed: {
            var title = qsTr("Really quit the game?");
            var description = "";
            var buttons = 2;
            nativeUtils.displayMessageBox(title, description, buttons);
        }

        // listen to the return value of the MessageBox
        Connections {
            target: nativeUtils
            onMessageBoxFinished: {
                // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
                if(accepted && window.activeScene === menuScene)
                    Qt.quit()
            }
        }
    }

    // credits scene
    CreditsScene {
        id: creditsScene
        onBackButtonPressed: window.state = "menu"
    }

    // Game scene to play
    Game.GameScene {
        id: gameScene
        onBackButtonPressed: window.state = "menu"
        onGameEnded:         window.state = "gameEnded"
    }

    // menuScene is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
        },
        State {
            name: "gameEnded"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
        },
        State {
            name: "credits"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: window; activeScene: creditsScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
        }
    ]
}
