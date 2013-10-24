/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

View {
    id: numberPad

    property int selectedNumber: choises.currentIndex+1

    animSpeed: 200
    viewWidth: choises.width*1.2
    viewHeight: (choises.height+choises.cellHeight)*1.2
    color: "black"

    GridView {
        id: choises

        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/2 - (height+cellHeight)/2
        currentIndex: 4
        width: 3*cellWidth
        height: width
        cellWidth: 60
        cellHeight: cellWidth
        model: 9
        boundsBehavior: Flickable.StopAtBounds
        focus: true
        z: -1

        delegate: Rectangle {
            color: index == choises.currentIndex ? "gray" : "black"
            radius: 5
            width: choises.cellWidth
            height: width
            border {
                color: "white"
                width: 1
            }

            Text {
                anchors.centerIn: parent
                font {
                    pixelSize: 40
                    family: "series 60 zdigi"
                }
                text: index+1
                color: "white"
            }
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Select || event.key == Qt.Key_Return ||
                event.key == Qt.Key_Enter) {
                    parent.clicked(0);
                    event.accepted = true;
            }
        }
    }

    Rectangle {
        color: choises.currentIndex == -1 ? "gray" : "black"
        radius: 5
        width: choises.cellWidth
        height: width
        anchors {
            top: choises.bottom
            horizontalCenter: parent.horizontalCenter
        }

        border {
            color: "white"
            width: 1
        }

        Text {
            anchors.centerIn: parent
            font {
                pixelSize: 40
                family: "series 60 zdigi"
            }
            text: "C"
            color: "white"
        }
    }
    onPressed: positionChanged(mouse);
    onPositionChanged: {
        if (choises.x < mouseX && choises.y < mouseY && mouseX < choises.x+choises.width && mouseY < choises.y+choises.height)
            choises.currentIndex = choises.indexAt(mouseX-choises.x, mouseY-choises.y);
        else if(choises.y+choises.height < mouseY && mouseY < choises.y+choises.height+choises.cellHeight &&
                choises.x+choises.cellWidth < mouseX && mouseX < choises.x+choises.cellWidth*2)
                    choises.currentIndex = -1;
        else
            choises.currentIndex = -2;
    }
    onClicked: {
        if (choises.currentIndex == -2)
            viewLoader.close();
        else {
            mainBoard.focus = true;
            viewLoader.close();
            setSelectedNumber();
        }
    }
    Keys.onPressed: {
        if (event.key == Qt.Key_Down) {
            choises.currentIndex = -1;
            event.accepted = true;
        }
        if (event.key == Qt.Key_Up && choises.currentIndex == -1) {
            choises.currentIndex = 7;
            event.accepted = true;
        }
        if (choises.currentIndex == -1 &&(event.key == Qt.Key_Select ||
                                         event.key == Qt.Key_Return ||
                                         event.key == Qt.Key_Enter)) {
                clicked(0);
                event.accepted = true;
        }
        if (Qt.Key_0 <= event.key && event.key <= Qt.Key_9) {
            choises.currentIndex = event.key - Qt.Key_0 - 1;
            clicked(0);
            event.accepted = true;
        }
    }
}
