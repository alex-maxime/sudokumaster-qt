/*
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

import QtQuick 1.0

View {
    id: waitNote

    animSpeed: 0

    Image {
        anchors.centerIn: parent
        source: "gfx/waitNote.png"
        NumberAnimation on rotation {
            id: animation

            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 1500
        }
    }
}
