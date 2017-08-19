//map weight height
var size = 4;

//map
var currentMap;

function generateMap() {
    createGameField();

    var arrayLength = currentMap.length - 1;

    for (var num = 1; num < currentMap.length; num++) {
        var rndPosition = randomIntFromInterval(0, arrayLength);

        var filteredArray = currentMap.filter(function(item) {
            return item.value === 0;
        });

        filteredArray[rndPosition].value = num;
        arrayLength -= 1;
    }
}

function createGameField() {
    currentMap = new Array(size*size - 1);
    for (var i = 0; i < size; i++) {
        for (var j = 0; j < size; j++) {
            var currentObj = {
                row: i,
                column: j,
                value: 0
            };
            currentMap[i*size + j] = currentObj;
        }
    }
}

function randomIntFromInterval(min, max) {
    return Math.floor(Math.random()*(max-min+1)+min);
}

