import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

import "logic.js" as Logic

Window {
    visible: true;
    width: 640;
    height: 480;
    title: qsTr("15 Puzzle");

    property int cellSize: height / Logic.size;

    ListModel {
        id: gameFieldModel;

        Component.onCompleted: {
            addData();
        }

        function addData() {
            clear();
            Logic.generateMap();

            for (var i = 0; i < Logic.currentMap.length; i++) {
                append(Logic.currentMap[i]);
            }
        }

        function checkNeighbors(index) {
            var selectObj = gameFieldModel.get(index);

            if (selectObj.value === 0)
                return;

            var currentRow = selectObj.row;
            var currentColumn = selectObj.column;

            var leftIndex = index - 1
            if (checkIndex(leftIndex)) {
                swap(index, leftIndex)
            }

            var rightIndex = index + 1
            if (checkIndex(rightIndex)) {
                swap(index, rightIndex)
            }

            var upIndex = index - Logic.size
            if (checkIndex(upIndex)) {
                swap(index, upIndex)
            }

            var downIndex = index + Logic.size
            if (checkIndex(downIndex)) {
                swap(index, downIndex)
            }
        }

        function checkIndex(index) {
            if (index >= 0 && index < Logic.currentMap.length) {

                var selectObj = gameFieldModel.get(index);
                if (selectObj.value === 0) {
                    return true;
                }
                return false;

            }
            return false;
        }

        function swap(from, to) {
            var min = Math.min(from, to);
            var max = Math.max(from, to);

            move(min, max, 1);
            move(max - 1, min, 1);
        }

        function isUserWin() {
            for (var i = 0; i < Logic.currentMap.length - 1; i++) {
                if (gameFieldModel.get(i) !== (i + 1)) {
                    return false;
                }
            }
            return true;
        }
    }

    Item {
        id: gameField
        width: parent.height;
        height: parent.height;

        GridView {
            id: gameBoard
            anchors.fill: parent;
            cellHeight: cellSize;
            cellWidth: cellSize;
            model: gameFieldModel;

            delegate: Cell {
                height: gameBoard.cellHeight;
                width: gameBoard.cellWidth;

                onItemSelected: {
                    gameFieldModel.checkNeighbors(num);

                    if (gameFieldModel.isUserWin()) {
                        console.log("you win")
                        gameFieldModel.addData();
                    }
                }
            }

            move: Transition {
                NumberAnimation {
                    properties: "x,y";
                    duration: 200;
                }
            }
        }
    }

    Button {
        text: "shuffle"

        anchors {
            left: gameField.right
            right: parent.right
            margins: 10
        }

        onClicked: {
            gameFieldModel.addData();
        }
    }
}
