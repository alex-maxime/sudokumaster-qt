/*
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

import QtQuick 1.0

GridView {
    id: block

    property int blockIdx
    property int blockRow
    property int blockCol
    property bool isAtCurrentRow
    property bool isAtCurrentCol
    property int currentRowInBlock
    property int currentColInBlock

    signal changingBlockToLeft();
    signal changingBlockToRight();

    width: blockDim * cellWidth
    height: width
    boundsBehavior: Flickable.StopAtBounds

    // Note: cellWidth and cellHeight properties must be defined by the parent.

    delegate: Cell {
        cellIdx: blockRow * dim * blocksPerSide + Math.floor(index / blockDim) * dim
                 + blockCol * blocksPerSide + index - Math.floor(index / blocksPerSide) * blocksPerSide;
        width: parent.width / main.blockDim
        height: parent.height / main.blockDim
        highlighted: (block.isAtCurrentRow && block.currentRowInBlock ==
                        Math.floor(index/blocksPerSide)) ||
                     (block.isAtCurrentCol && block.currentColInBlock ==
                      index - Math.floor(index/blocksPerSide)*blocksPerSide);
        bgImageSource: blockIdx % 2 ? "gfx/brownGridItem.png" : "gfx/darkGridItem.png"
    }

    model: 9

    Keys.onPressed: {
        if (event.key == Qt.Key_Left) {
            if (currentColInBlock == 0) {
                changingBlockToLeft();
                event.accepted = true;
            }
        }
        if (event.key == Qt.Key_Right) {
            if (currentColInBlock == blockDim-1) {
                changingBlockToRight();
                event.accepted = true;
            }
        }
    }
}
