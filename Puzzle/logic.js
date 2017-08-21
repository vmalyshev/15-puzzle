//map weight height
var size = 4;

//map
var currentMap;

function generateMap() {
    createGameField();

    do {
        console.log("check");
        currentMap = shuffleArray(currentMap);
    } while (isTaskSolve())
}

function createGameField() {
    currentMap = new Array(size*size - 1);
    for (var i = 0; i < size; i++) {
        for (var j = 0; j < size; j++) {
            var currentObj = {
                row: i,
                column: j,
                value: i * size + j
            };
            currentMap[i*size + j] = currentObj;
        }
    }
}

function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
}

function isTaskSolve() {
    var sum = 0;
    var zeroValueItemPosition;

    for (var i = 0; i < size * size; i++) {
        if (!currentMap[i].value) {
            zeroValueItemPosition = i;
            continue;
        }

        for (var j = i; j < size * size; j++) {
            if ((currentMap[i] < currentMap[j]) && currentMap[j].value !== 0) {
                sum += 1;
            }
        }
    }

    var rowWithZeroValue = zeroValueItemPosition / 2 + 1;
    var result = ((sum + rowWithZeroValue) % 2 == 0);
    return result;
}
