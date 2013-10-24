/**
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0
import 'dbHandling.js' as Rankings

View {
    id: winNote

    property int winPlacement: getPlacement(time);
    property variant model: Rankings.getRankingsModel();

    function getPlacement(time) {
        if (time < model.get(0).rankTime)
            return 1;

        if (time < model.get(model.count-1).rankTime) {
            for (var i = 0; i < model.count-1; i++)
                if (time >= model.get(i).rankTime
                        && time < model.get(i+1).rankTime)
                    return i+2;
        }
        else {
            return 0;
        }
    }

    function setRecord(placement, time, name) {
        Rankings.setRecord(placement, time, name);
        model.destroy();
        model = Rankings.getRankingsModel();
    }

    viewWidth: 340
    viewHeight: 350
    viewOpacity: 0.8
    color: "#ffeecc"

    onClosed: newGame();
    Component.onCompleted: viewLoader.focus = true;

    Text {
        id: winTopic

        font.pixelSize: 50

        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height / 2 - viewHeight / 2 + 20
            top: parent.top
        }

        text: "COMPLETED!"
    }

    Text {
        id: timeLabel

        text: "Your time was " + getFormattedTime(time);
        font.pixelSize: 25

        anchors {
            top: winTopic.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: placementLabel

        text: winPlacement ? "Your placement is " + winPlacement + "." : "";
        font.pixelSize: 25
        anchors {
            top: timeLabel.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        id: nameInput

        property alias text: nameTextInput.text

        opacity: winPlacement
        color: "white"
        radius: 6
        border.width: 1
        width: winNote.viewWidth * 0.8
        height: 50

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: placementLabel.bottom
            topMargin: 10
        }

        TextInput {
            id: nameTextInput

            width: parent.width
            height: parent.height
            focus: true
            font.pixelSize: height * 0.75

            anchors {
                top: parent.top
                topMargin: 6
                left: parent.left
                leftMargin: 10
            }
        }

        Text {
            id: hintText

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 10
            }

            color: "gray"
            text: "Your name"
            opacity: nameInput.text == "" ? 1 : 0
            font.pixelSize: nameTextInput.height * 0.5
        }

        KeyNavigation.down: winNewGameButton
    }

    Button {
        id: winExitButton

        width: 100
        height: 50

        anchors {
            left: parent.left
            leftMargin: 20
            bottom: parent.bottom
            bottomMargin: parent.height / 2 - viewHeight / 2 + 30
        }

        text: "Exit"

        onClicked: {
            if (winPlacement && nameInput.text != "")
                setRecord(winPlacement, time, nameInput.text);

            Qt.quit();
        }

        KeyNavigation.right: winNewGameButton
        KeyNavigation.up: nameTextInput
    }

    Button {
        id: winNewGameButton

        width: 100
        height: 50

        anchors {
            right: parent.right
            rightMargin: 20
            bottom: parent.bottom
            bottomMargin: parent.height/2-viewHeight/2 + 30
        }

        text: "New game"

        onClicked: {
            if (winPlacement && nameInput.text != "")
                setRecord(winPlacement, time, nameInput.text);

            viewLoader.close(x, y)
        }

        KeyNavigation.left: winExitButton
        KeyNavigation.up: nameTextInput
    }
}
