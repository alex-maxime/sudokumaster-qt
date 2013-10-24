/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

View {
    id: menu

    property string action

    viewWidth: 250
    viewHeight: 350
    color: "#ffeecc"

    onClosed: {
        switch(action) {
        case "resume":
            mainTimer.start();
            break;
        case "reset":
            reset();
            break;
        case "new game":
            newGame();
            break;
        }
    }

    onClicked: {
        if (gameOn) {
            action = "resume"
            viewLoader.close(optionsButton.x + optionsButton.width / 2,
                             optionsButton.y + optionsButton.height / 2);
        }
    }

    Column {
        id: buttonColumn

        anchors.centerIn: parent
        spacing: 15

        Button {
            id: resumeButton

            opacity: gameOn
            width: viewWidth * 0.8
            height: viewHeight * 0.15
            text: "Resume"

            onClicked: {
                action = "resume"
                viewLoader.close(optionsButton.x + optionsButton.width / 2,
                                 optionsButton.y + optionsButton.height / 2);
            }

            focus: gameOn
            KeyNavigation.up: menuExitButton
            KeyNavigation.down: restartButton
        }
        Button {
            id: restartButton

            opacity: gameOn
            width: viewWidth * 0.8
            height: viewHeight * 0.15
            text: "Restart"

            onClicked: {
                action = "reset";
                viewLoader.close(buttonColumn.x + x + width / 2,
                                 buttonColumn.y + y + height / 2);
            }

            KeyNavigation.up: resumeButton
            KeyNavigation.down: newGameButton
        }
        Button {
            id: newGameButton

            width: viewWidth * 0.8
            height: viewHeight * 0.15
            text: "New game"

            onClicked: {
                viewLoader.switchTo("WaitNote.qml",
                                    buttonColumn.x + x + width / 2,
                                    buttonColumn.y + y + height / 2);
                action = "new game";
            }

            focus: !gameOn
            KeyNavigation.up: gameOn ? restartButton : menuExitButton
            KeyNavigation.down: highScoresButton
        }
        Button {
            id: highScoresButton

            width: viewWidth * 0.8
            height: viewHeight * 0.15
            text: "High Scores"
            onClicked: viewLoader.switchTo("HighScores.qml",
                                           buttonColumn.x + x + width / 2,
                                           buttonColumn.y + y + height / 2);
            KeyNavigation.up: newGameButton
            KeyNavigation.down: menuExitButton
        }
        Button{
            id: menuExitButton

            width: viewWidth * 0.8
            height: viewHeight * 0.15
            text: "Exit"
            onClicked: Qt.quit();
            KeyNavigation.up: highScoresButton
            KeyNavigation.down: gameOn ? resumeButton : newGameButton
        }
    }
}
