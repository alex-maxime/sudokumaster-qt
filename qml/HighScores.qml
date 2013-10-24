/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0
import 'dbHandling.js' as Rankings

View {
    id: highScores

    property bool closedToMainView: false

    viewWidth: portrait ? 250 : 400
    viewHeight: portrait ? 450 : 350
    viewOpacity: 0.8
    color: "#ffeecc"

    onClosed: {
        if (closedToMainView)
            mainTimer.start();
    }

    onClicked: {
        if (gameOn) {
            closedToMainView = true;
            viewLoader.switchTo("", optionsButton.x+optionsButton.width/2, optionsButton.y+optionsButton.height/2);
        }
    }

    Text {
        id: topic

        text: "Top 10"
        font.pixelSize: 40
        anchors {
            left: parent.left
            leftMargin: portrait ? parent.width/2-width/2 : parent.width/2-viewWidth/2 + 10
            top: parent.top
            topMargin: portrait ? parent.height/2-viewHeight/2 + 10 : 10
        }
    }

    ListView {
        id: rankingList

        anchors {
            top: portrait ? topic.bottom : parent.top
            topMargin: 10
            left: portrait ? parent.left : resumeButton.right
            leftMargin: portrait ? parent.width/2-width/2 : 30
        }

        width: 200
        height: 30*model.count
        model: Rankings.getRankingsModel();
        delegate: Item {
            height: text.height
            Text {
                id: text
                font.pixelSize: 25
                text: placement + ".";
            }
            Text {
                font.pixelSize: 25
                x: 40
                text: name
            }
            Text {
                font.pixelSize: 25
                x: rankingList.width-60
                text: getFormattedTime(rankTime);
            }
        }
    }

    Button {
        id: resumeButton

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height/2-viewHeight/2 + 20
            left: portrait ? parent.left : topic.left
            leftMargin: portrait ? parent.width/2-width/2 : 0
        }
        focus: true
        width: portrait ? viewWidth*0.8 : 120
        height: 50
        text: "Resume"
        onClicked: viewLoader.switchTo("Menu.qml", x+width/2, y+height/2);
    }
}
