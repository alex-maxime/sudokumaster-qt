/*
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

var BLOCK_DIM = 3;
var BLOCKS_PER_SIDE = 3;
var DIM = BLOCKS_PER_SIDE * BLOCK_DIM;

var numbers; // The main array for the numbers on the Sudoku game board
var numbersCopy; // A working copy of the main array
var randOrder; // An array for helping in the randomization
var solutionFound = 0; // A helper variable for checking of the unique solution

/* Tries to set the given number to the given index of the main array.
 * Returns 1 if it was possible, 0 otherwise. If it wasn't possible
 * this function will start the collision animations.
 */
function setNumberByUser(index, value)
{
    var row = Math.floor(index/DIM);
    var column = index%DIM;
    var rowCollision = testRow(index, row, value);
    var columnCollision = testColumn(index, column, value);
    var blockCollision = testBlock(index, row, column, value);

    if (numbers[index] || value)
        moves++;
    if (!rowCollision && !columnCollision && !blockCollision) {
        if (!numbers[index] && value)
            empties--;
        if (numbers[index] && !value)
            empties++;
        numbers[index] = value;
        return 1;
    }
    else {
        var indices = new Array();
        if (rowCollision)
            indices.push(rowCollision-1);
        if (columnCollision)
            indices.push(columnCollision-1);
        if (blockCollision)
            indices.push(blockCollision-1);
        startCollisionAnimations(indices);
        return 0;
    }
}

/* Tries to set the given number to the given index.
 * Returns 1 if it was possible, 0 otherwise.
 *
 * @param useCopy, tells whether we use the main array or a copy of it
 */
function setNumber(index, value, useCopy)
{
    var row = Math.floor(index/DIM);
    var column = index%DIM;
    if (!testRow(index, row, value, useCopy) &&
        !testColumn(index, column, value, useCopy) &&
        !testBlock(index, row, column, value, useCopy)) {
            if (useCopy)
                numbersCopy[index] = value;
            else
                numbers[index] = value;
            return 1;
    }
    return 0;
}

/*
 * Tests if there already is this number in the same row.
 * If there is, this returns the numbers index plus one and
 * 0 otherwise.
 *
 * @param useCopy, tells whether we use the main array or a copy of it
 */
function testRow(index, row, value, useCopy)
{
    var min = row*DIM;
    var max = row*DIM + DIM;
    for (var i = min; i < max; i++)
        if (useCopy) {
            if (numbersCopy[i])
                if (i != index && numbersCopy[i] == value)
                    return i+1;
        }
        else {
            if (numbers[i])
                if (i != index && numbers[i] == value)
                    return i+1;
        }
    return 0;
}

/*
 * Tests if there already is this number in the same column.
 * If there is, this returns the numbers index plus one and
 * 0 otherwise.
 *
 * @param useCopy, tells whether we use the main array or a copy of it
 */
function testColumn(index, column, value, useCopy)
{
    var max = DIM*DIM;
    for (var i = column; i <= max; i += DIM)
        if (useCopy) {
            if (numbersCopy[i])
                if (i != index && numbersCopy[i] == value)
                    return i+1;
        }
        else {
            if (numbers[i])
                if (i != index && numbers[i] == value)
                    return i+1;
        }
    return 0;
}

/*
 * Tests if there already is this number in the same block.
 * If there is, this returns the numbers index plus one and
 * 0 otherwise.
 *
 * @param useCopy, tells whether we use the main array or a copy of it
 */
function testBlock(index, row, column, value, useCopy)
{
    var blockRow = Math.floor(row/BLOCK_DIM);
    var blockColumn = Math.floor(column/BLOCK_DIM);
    var min = blockRow*BLOCK_DIM*DIM + blockColumn*BLOCK_DIM;
    var max = min+BLOCK_DIM;
    var idx;
    for (var x = min; x < max; x++)
        for (var y = 0; y < 3; y++) {
            idx = x + y*DIM;
            if (useCopy) {
                if (numbersCopy[idx])
                    if (idx != index && numbersCopy[idx] == value)
                        return idx+1;
            }
            else {
                if (numbers[idx])
                    if (idx != index && numbers[idx] == value)
                        return idx+1;
            }
        }
    return 0;
}

/*
 * Creates an array with numbers 1-9 in it, ordered randomly.
 */
function fillRandOrder()
{
    randOrder = new Array();
    var isSet = 0;
    var rand;
    for (var i = 0; i < DIM; i++) {
        while (!isSet) {
            rand = Math.floor(Math.random()*DIM)+1;
            for (var j = 0; j < DIM; j++)
                if (randOrder[j] && (rand == randOrder[j]))
                    break;
            if (j == DIM) {
                randOrder[i] = rand;
                isSet = 1;
            }
        }
        isSet = 0;
    }
}

/* Generates a random full sudoku board by using recursive
 * backtracking method.
 */
function fillCell(index)
{
    if (index == DIM*DIM)
        return 1;
    for (var i = 0; i < 9; i++) {
        if (setNumber(index, randOrder[i], 0) && fillCell(index+1))
            return 1;
        numbers[index] = 0;
    }
    return 0;
}

/* Checks whether the puzzle has an unique solution.
 * Returns 0 if it does, 1 otherwise. The algorithm is mainly
 * the same as is fillCell().
 */
function checkUniqueness(index)
{
    if (index == DIM*DIM) {
        if (solutionFound) {
            solutionFound = 0;
            return 1;
        }
        solutionFound = 1;
        return 0;
    }
    if (numbersCopy[index]) {
        if (checkUniqueness(index+1))
            return 1;
    }
    else
        for (var i = 1; i <= 9; i++)
            if (setNumber(index, i, 1)) {
                if (checkUniqueness(index+1))
                    return 1;
                numbersCopy[index] = 0;
            }
    return 0;
}

/* Removes numbers from the board until a desired puzzle is obtained.
 * Checks after every deletion that the puzzle still has an unique solution.
 */
function removeCells()
{
    var temp;
    var rand;
    while (empties < 45) {
        rand = Math.floor(Math.random()*DIM*DIM);
        temp = numbers[rand];
        if (temp) {
            numbers[rand] = 0;
            numbersCopy = numbers.slice(0);
            if (checkUniqueness(0))
                numbers[rand] = temp;
            else
                empties++;
        }
    }
}

/*
 * Generates a new Sudoku puzzle.
 */
function generatePuzzle()
{
    numbers = new Array();
    fillRandOrder();
    fillCell(0);
    empties = 0;
    removeCells();
}

/*
 * This enables the puzzle generating in another thread.
 */
WorkerScript.onMessage = function(message) {
    generatePuzzle(message.rands);
    WorkerScript.sendMessage( {board: numbers, boardEmpties: empties} );
}
