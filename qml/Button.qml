/*
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

import QtQuick 1.0

Rectangle {
    id: button

    property alias text: buttonLabel.text

    signal clicked();

    border.width: 2
    color: focus ? "#ffeecc" : "#ffd47f"
    radius: 10

    Text {
        id: buttonLabel

        anchors.centerIn: parent
        font.pixelSize: main.defaultFontPixelSize
    }

    MouseArea {
        id: buttonMouseArea

        anchors.fill: parent
        onPressed: {
            parent.scale = 0.9;
            parent.color = "#c69961";
        }
        onReleased: {
            parent.scale = 1;
            parent.color = "#ffeecc";
        }
        onClicked: {
            button.clicked();
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Select || event.key == Qt.Key_Return ||
                event.key == Qt.Key_Enter)
            buttonMouseArea.clicked(0);
    }
}
