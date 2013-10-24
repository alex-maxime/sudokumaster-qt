/**
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0
import 'gameLogic.js' as Functions

// The type of the AppWindow depends on the build; e.g. in Symbian and Maemo 5
// AppWindow is actually a regular Item QML element. In Harmattan build,
// AppWindow is Window Qt component.
AppWindow {
    id: main

    signal freeCellsReseted()
    signal boardChanged()

    property int blockDim: Functions.BLOCK_DIM
    property int blocksPerSide: Functions.BLOCKS_PER_SIDE
    property int dim: Functions.DIM

    property int moves: 0
    property int empties: 0
    property int time: 0
    property bool gameOn: false
    property bool portrait: true

    // The interface for the cells to the gameLogic.js.
    function resetNumber(index)
    {
        Functions.numbers[index] = 0;
        empties++;
    }

    function setSelectedNumber()
    {
        var cell = mainBoard.currentItem.currentItem;
        if (cell && cell.free)
            if(Functions.setNumberByUser(cell.cellIdx, viewLoader.item.selectedNumber))
                cell.number = viewLoader.item.selectedNumber ? viewLoader.item.selectedNumber : "";
    }

    function getNumber(index)
    {
        return Functions.numbers[index];
    }

    function win()
    {
        mainTimer.stop();
        gameOn = false;
        viewLoader.switchTo("WinNote.qml", viewLoader.initX, viewLoader.initY);
    }

    function reset()
    {
        freeCellsReseted();
        moves = 0;
        time = 0;
        mainTimer.start();
    }

    function newGame()
    {
        moves = 0;
        time = 0;
        puzzleWorker.sendMessage({});
    }

    function getFormattedTime(pTime)
    {
        var minFirstDigits = Math.floor(pTime/600);
        var secFirstDigits = Math.floor(pTime/10);
        var formattedTime = minFirstDigits + "" +
            (Math.floor(pTime/60)-minFirstDigits*10) + ":" +
            secFirstDigits%6 + "" + (pTime-secFirstDigits*10);
        return formattedTime;
    }

    function startCollisionAnimations(indices)
    {
        var prevBlockIdx = mainBoard.currentIndex;
        var prevIdx = mainBoard.currentItem.currentIndex;
        var idx;
        for (var i = 0; i < indices.length; i++) {
            idx = indices[i];
            var row = Math.floor(idx/dim);
            var column = idx%dim;
            var blockRow = Math.floor(row/blockDim);
            var blockColumn = Math.floor(column/blockDim);
            var rowInBlock = row - blockDim*blockRow;
            var colInBlock = column - blockDim*blockColumn;
            var blockIndex = blockRow*blocksPerSide+blockColumn;
            var indexInBlock = rowInBlock*blockDim+colInBlock;
            mainBoard.currentIndex = blockIndex;
            mainBoard.currentItem.currentIndex = indexInBlock;
            mainBoard.currentItem.currentItem.startCollisionAnimation();
        }

        mainBoard.currentIndex = prevBlockIdx;
        mainBoard.currentItem.currentIndex = prevIdx;
    }

    anchors.fill: parent

    onEmptiesChanged: {
        if (!empties)
            win();
    }

    Image {
        anchors.fill: parent
        source: "gfx/background.png"

        onHeightChanged: {
            main.portrait = (width < height);
            console.debug("main.qml:Image:onHeightChanged(): [", width, ",", height, "], portrait ==", portrait);
        }
    }

    WorkerScript {
        id: puzzleWorker
        source: "gameLogic.js"

        onMessage: {
            Functions.numbers = messageObject.board;
            empties = messageObject.boardEmpties;
            boardChanged();
            viewLoader.close();
            gameOn = true;
            mainBoard.focus = true;
            mainTimer.start();
        }
    }

    Timer {
        id: mainTimer

        interval: 1000
        repeat: true
        onTriggered: time++
    }

    Image {
        id: topic

        width: portrait ? sourceSize.width : statistics.width
        height: 0.25 * width
        source: "gfx/logo.png"

        anchors {
            top: parent.top
            topMargin: portrait ? parent.height * 0.02 : statistics.y - height - 10
            left: parent.left
            leftMargin: portrait ? parent.width / 2 - width / 2 : 10
        }
    }

    GridView {
        id: mainBoard

        property int currentBlockRow: Math.floor(currentIndex / blocksPerSide);
        property int currentBlockCol: currentIndex - currentBlockRow * blocksPerSide;

        width: portrait ? parent.width : parent.height
        height: width
        cellWidth: width / 3 - 3
        cellHeight: cellWidth
        boundsBehavior: Flickable.StopAtBounds

        anchors {
            topMargin: portrait ? (parent.height - height) / 2
                                  - topic.height - parent.height * 0.04 : 10;
            top: portrait ? topic.bottom : parent.top
            leftMargin: 5
            left: portrait ? parent.left : topic.right
        }

        delegate: Block {
            cellWidth: portrait ? mainBoard.width / dim - 2 : mainBoard.height / dim - 2
            cellHeight: cellWidth
            blockIdx: index;
            blockRow: Math.floor(blockIdx / blocksPerSide);
            blockCol: blockIdx - blockRow * blocksPerSide;
            currentRowInBlock: Math.floor(mainBoard.currentItem.currentIndex / blockDim);
            currentColInBlock: mainBoard.currentItem.currentIndex - currentRowInBlock * blockDim;
            isAtCurrentRow: Math.floor(index/blocksPerSide) == mainBoard.currentBlockRow;
            isAtCurrentCol: index - Math.floor(index / blocksPerSide) * blocksPerSide ==
                                mainBoard.currentBlockCol;

            onChangingBlockToLeft: {
                if (mainBoard.currentBlockCol != 0) {
                    var prevIdx = mainBoard.currentItem.currentIndex;
                    mainBoard.currentIndex--;
                    mainBoard.currentItem.currentIndex = prevIdx + blockDim-1;
                }
                else {
                    var prevIdx = mainBoard.currentItem.currentIndex;
                    mainBoard.currentIndex += blocksPerSide-1;
                    mainBoard.currentItem.currentIndex = prevIdx + blockDim-1;
                }
            }

            onChangingBlockToRight: {
                if (mainBoard.currentBlockCol != blocksPerSide-1) {
                    var prevIdx = mainBoard.currentItem.currentIndex;
                    mainBoard.currentIndex++;
                    mainBoard.currentItem.currentIndex = prevIdx - (blockDim-1);
                }
                else {
                    var prevIdx = mainBoard.currentItem.currentIndex;
                    mainBoard.currentIndex -= blocksPerSide-1;
                    mainBoard.currentItem.currentIndex = prevIdx - (blockDim-1);
                }
            }
        }

        model: 9

        Keys.onPressed: {
            if (event.key == Qt.Key_Up) {
                if (currentBlockRow != 0) {
                    var prevIdx = currentItem.currentIndex;
                    currentIndex = currentIndex - blocksPerSide;
                    currentItem.currentIndex = prevIdx + blockDim*(blockDim-1);
                    event.accepted = true;
                }
                else {
                    var prevIdx = currentItem.currentIndex;
                    currentIndex = currentIndex + blocksPerSide*(blocksPerSide-1);
                    currentItem.currentIndex = prevIdx + blockDim*(blockDim-1);
                    event.accepted = true;
                }
            }
            if (event.key == Qt.Key_Down) {
                if (currentBlockRow != 2) {
                    var prevIdx = currentItem.currentIndex;
                    currentIndex = currentIndex + blocksPerSide;
                    currentItem.currentIndex = prevIdx - blockDim*(blockDim-1);
                    event.accepted = true;
                }
                else {
                    var prevIdx = currentItem.currentIndex;
                    currentIndex = currentIndex - blocksPerSide*(blocksPerSide-1);
                    currentItem.currentIndex = prevIdx - blockDim*(blockDim-1);
                    event.accepted = true;
                }
            }
            if (event.key == Qt.Key_Select || event.key == Qt.Key_Return ||
                    event.key == Qt.Key_Enter) {
                boardMouseArea.clicked(0);
                event.accepted = true;
            }
        }
    }

    MouseArea {
        id: boardMouseArea

        property int blockDim: width/blocksPerSide+1

        function resetSelection() {
            mainBoard.currentIndex = blocksPerSide * blocksPerSide / 2 - 1;
            mainBoard.currentItem.currentIndex = main.blockDim * main.blockDim / 2-1;
        }

        anchors {
            bottomMargin: 12
            rightMargin: 12
            fill: mainBoard
        }

        Component.onCompleted: resetSelection();
        onPressed: positionChanged(mouse);
        onPositionChanged: {
            if (0 < mouseX && 0 < mouseY && mouseX < width && mouseY < height) {
                var prevBlockIdx = mainBoard.currentIndex;
                var prevIdx = mainBoard.currentItem.currentIndex;
                mainBoard.currentIndex = mainBoard.indexAt(mouseX, mouseY);

                if (mainBoard.currentItem) {
                    mainBoard.currentItem.currentIndex =
                            mainBoard.currentItem.indexAt(
                                mouseX - Math.floor(mouseX / blockDim) * blockDim,
                                mouseY - Math.floor(mouseY / blockDim) * blockDim);

                    if (!mainBoard.currentItem.currentItem) {
                        mainBoard.currentIndex = prevBlockIdx;
                        mainBoard.currentItem.currentIndex = prevIdx;
                    }
                }
            }
            else
                resetSelection();
        }
        onClicked: {
            if (mainBoard.currentItem.currentItem &&
                    mainBoard.currentItem.currentItem.free) {
                viewLoader.switchTo("NumberPad.qml",
                                    x + mainBoard.currentItem.x
                                    + mainBoard.currentItem.currentItem.x,
                                    y + mainBoard.currentItem.y
                                    + mainBoard.currentItem.currentItem.y);
            }
        }
    }

    Image {
        id: statistics

        property int imageSize: 20

        source: "gfx/statistic.png"
        width: portrait ? parent.width * 0.4 : parent.height * 0.4
        height: width * 0.9

        anchors {
            bottom: parent.bottom
            bottomMargin: portrait ? 5 : 100
            left: parent.left
            leftMargin: portrait ? parent.width / 2 - width / 2 : 10
        }

        Column {
            anchors.centerIn: parent

            spacing: parent.height * 0.08

            Row {
                spacing: 10

                Image {
                    width: statistics.imageSize
                    height: statistics.imageSize
                    source: "gfx/move.png"
                }
                Text {
                    text: moves
                    font.pixelSize: main.smallFontPixelSize
                    font.family: "series 60 zdigi"
                }
            }
            Row {
                spacing: 10

                Image {
                    width: statistics.imageSize
                    height: statistics.imageSize
                    source: "gfx/empty.png"
                }
                Text {
                    text: empties
                    font.pixelSize: main.smallFontPixelSize
                    font.family: "series 60 zdigi"
                }
            }
            Row {
                spacing: 10

                Image {
                    width: statistics.imageSize
                    height: statistics.imageSize
                    source: "gfx/time.png"
                }
                Text {
                    text: getFormattedTime(time);
                    font.pixelSize: main.smallFontPixelSize
                    font.family: "series 60 zdigi"
                }
            }
        }
    }

    Text {
        id: optionsButton

        function click() {
            mainTimer.stop();
            viewLoader.switchTo("Menu.qml", x+width/2,
                                y-height/2);
        }
        function press() {
            scale = 0.9
            color = "lightgray"
        }
        function release() {
            scale = 1
            color = "#ffffff"
        }

        anchors {
            left: parent.left
            leftMargin: 5
            bottom: parent.bottom
            bottomMargin: 5
        }
        text: "Options"
        font.pixelSize: main.largeFontPixelSize
        color: parent.focus ? "black" : "#ffffff"

        MouseArea {
            id: optionsMouseArea

            anchors.fill: parent
            onPressed: parent.press();
            onReleased: parent.release();
            onClicked: parent.click();
        }
    }

    Keys.onPressed: {
        if (!viewLoader.focus) {
            if (event.key == Qt.Key_Context1) {
                optionsButton.press();
                event.accepted = true;
            }
            if (event.key == Qt.Key_Context2) {
                exitButton.press();
                event.accepted = true;
            }
        }
    }

    Keys.onReleased: {
        if (!viewLoader.focus) {
            if (event.key == Qt.Key_Context1) {
                optionsButton.release();
                optionsButton.click();
                event.accepted = true;
            }
            if (event.key == Qt.Key_Context2) {
                exitButton.release();
                exitButton.click();
                event.accepted = true;
            }
        }
    }

    Text {
        id: exitButton

        function click() {
            Qt.quit();
        }
        function press() {
            scale = 0.9
            color = "lightgray"
        }
        function release() {
            scale = 1
            color = "#ffffff"
        }

        text: "Exit"
        font.pixelSize: main.largeFontPixelSize
        color: focus ? "black" : "#ffffff"

        anchors {
            right: parent.right
            rightMargin: 5
            bottom: parent.bottom
            bottomMargin: 5
        }

        MouseArea {
            id: exitMouseArea

            anchors.fill: parent
            onPressed: parent.press();
            onReleased: parent.release();
            onClicked: parent.click();
        }
    }

    Loader {
        id: viewLoader

        property string file
        property int initX: parent.width / 2
        property int initY: parent.height / 2

        function switchTo(fileName, fromX, fromY)
        {
            if (fileName != file) {
                file = fileName;
                initX = fromX;
                initY = fromY;

                if (item)
                    item.state = "";
                else
                    source = file;

                focus = true;
            }
        }

        function close(fromX, fromY)
        {
            if (fromX != undefined && fromY != undefined) {
                initX = fromX;
                initY = fromY;
            }

            switchTo("", initX, initY);
            focus = false;
            mainBoard.focus = true;
        }

        anchors.centerIn: parent
        focus: true
        source: "Menu.qml"

        onLoaded: item.state = "open"
    }
} // AppWindow
