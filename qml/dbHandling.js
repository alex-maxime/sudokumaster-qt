/*
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

var _db = openDatabaseSync("SudokumasterDb", "0.1", "Sudokumaster database", 1000000);

_createSettingsTable();


function getRankingsModel() {

    var result;

    _db.transaction(function(tx) {
                       result = tx.executeSql('SELECT * FROM rankings ORDER BY placement');
    });

    var model = Qt.createQmlObject('import Qt 4.7; ListModel {}', main);

    for (var i = 0; i < result.rows.length; i++) {
        model.append(result.rows.item(i));
    }

    return model;
}


function setRecord(placement, time, name) {

    _db.transaction(function(tx) {

                        var model = getRankingsModel();

                        for (var i = placement+1; i <= model.count; i++){
                            var prev = model.get(i-2);
                            tx.executeSql('UPDATE rankings SET rankTime = ?, name = ? WHERE placement = ?', [prev.rankTime, prev.name, i]);
                        }

                        tx.executeSql('UPDATE rankings SET rankTime = ?, name = ? WHERE placement = ?', [time, name, placement]);
    });
}

function _createSettingsTable() {

    _db.transaction(function(tx) {

                        // Uncomment/comment this line if you need to reset/keep your rankings.
                        // tx.executeSql('DROP TABLE rankings');

                        var createTableSql  = 'CREATE TABLE IF NOT EXISTS rankings(';
                           createTableSql += 'placement NUMERIC PRIMARY KEY,';
                           createTableSql += 'rankTime TEXT,';
                           createTableSql += 'name TEXT)';

                        tx.executeSql(createTableSql);
                        var check = tx.executeSql('SELECT * FROM rankings');

                        if (!check.rows.length) {
                            for (var i = 1; i <= 10; i++) {
                                tx.executeSql('INSERT INTO rankings VALUES (?, 3600, "Test")', [i]);
                            }
                        }
    });
}
