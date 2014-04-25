/*
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

import QtQuick 1.0

Image {
    id: cell

    property int cellIdx
    property url bgImageSource
    property alias number: cellLabel.text
    property bool free: false
    property bool highlighted: false

    source: highlighted ? "gfx/lightGridItem.png" : bgImageSource
    //width: //portrait ? (main.blockDim * (main.width / main.dim - 2)) / 3 : (main.blockDim * (main.height / main.dim - 2)) / 3 //portrait ? main.width / 9 - 2 : main.height / 9 - 2
    height: width

    function startCollisionAnimation() {
        collisionNote.startAnimation();
    }

    Connections {
        target: main

        onFreeCellsReseted: {
            if (free && cellLabel.text) {
                resetNumber(cellIdx);
                cellLabel.text = "";
            }
        }
        onBoardChanged: {
            var val = getNumber(cellIdx);
            cellLabel.text = val ? val : "";
            free = !val;

            // The following needs to be done, because sometimes QML can't
            // handle the changing automatically.
            cellLabel.color = free ? "white" : "black"
        }
    }

    Text {
        id: cellLabel

        font {
            pixelSize: 30
            family: "series 60 zdigi"
        }

        color: free ? "white" : "black"
        anchors.centerIn: parent
    }

    Rectangle {
        id: collisionNote

        property string colorOfLabel

        function startAnimation() {
            collisionNoteAnimation.start();
        }

        scale: 0
        color: "red"
        opacity: 0.45
        anchors {
            fill: parent
        }

        SequentialAnimation {
            id: collisionNoteAnimation

            property int speed: 800

            ScriptAction {
                script: {
                    collisionNote.colorOfLabel = cellLabel.color;
                    cellLabel.color = "red";
                }
            }
            NumberAnimation {
                target: collisionNote
                property: "scale"
                to: 1
                duration: collisionNoteAnimation.speed
            }
            ScriptAction {
                script: collisionNote.scale = 0;
            }
            NumberAnimation {
                target: collisionNote
                property: "scale"
                to: 1
                duration: collisionNoteAnimation.speed
            }
            ScriptAction {
                script: collisionNote.scale = 0;
            }
            NumberAnimation {
                target: collisionNote
                property: "scale"
                to: 1
                duration: collisionNoteAnimation.speed
            }
            ScriptAction {
                script: {
                    cellLabel.color = collisionNote.colorOfLabel;
                    collisionNote.scale = 0;
                }
            }
        }
    }
}
