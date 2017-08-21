import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

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

            if (!selectObj.value)
                return;

            var currentRow = Math.floor(index / Logic.size);
            var currentColumn = index % Logic.size;

            var leftIndex = index - 1
            var leftRow = Math.floor(leftIndex / Logic.size);
            if (leftRow == currentRow && checkIndex(leftIndex)) {
                swap(index, leftIndex)
                return;
            }

            var rightIndex = index + 1
            var rightRow = Math.floor(rightIndex / Logic.size);

            if (rightRow == currentRow && checkIndex(rightIndex)) {
                swap(index, rightIndex)
                return;
            }

            var upIndex = index - Logic.size
            var upColumn = upIndex % Logic.size;
            if (currentColumn == upColumn && checkIndex(upIndex)) {
                swap(index, upIndex)
                return;
            }

            var downIndex = index + Logic.size
            var downColumn = downIndex % Logic.size;
            if (currentColumn == downColumn && checkIndex(downIndex)) {
                swap(index, downIndex)
                return;
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
                if (gameFieldModel.get(i).value !== (i + 1)) {
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
                        msgCongratulation.visible = true;
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

    MessageDialog {
        id: msgCongratulation
        title: "Notification"
        text: "You win"
        onAccepted: {
            gameFieldModel.addData();
        }
        Component.onCompleted: visible = false
    }
}
