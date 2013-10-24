/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

MouseArea {
    id: view

    property alias viewWidth: bg.width
    property alias viewHeight: bg.height
    property alias viewOpacity: bg.opacity
    property alias color: bg.color
    property bool modal: true
    property int animSpeed: 500

    signal closed()

    scale: 0
    width: modal ? main.width : viewWidth
    height: modal ? main.height : viewHeight
    x: viewLoader.initX - main.width/2
    y: viewLoader.initY - main.height/2

    Rectangle {
        id: bg

        opacity: 0.5
        radius: 10
        z: -2

        anchors.centerIn: parent
    }
    Rectangle {
        radius: 10
        border.width: 2
        anchors.fill: bg
        color: "transparent"
    }

    states: [
        State {
            name: "open"
            PropertyChanges {
                target: view
                scale: 1
                x: 0
                y: 0
            }
        }
    ]

    transitions: [
        Transition {
            to: "open"
            PropertyAnimation {
                properties: "scale, x, y"
                duration: animSpeed
                easing.type: Easing.OutBack
                easing.overshoot: 1.8
            }
        },
        Transition {
            to: ""
            SequentialAnimation {
                PropertyAnimation {
                    properties: "scale, x, y"
                    duration: animSpeed
                    easing.type: Easing.InBack
                    easing.overshoot: 1.8
                }
                ScriptAction {
                    script: {
                        closed();
                        viewLoader.source = viewLoader.file;
                    }
                }
            }
        }
    ]
}
