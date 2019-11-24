import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'globals.dart' as globals;

Future<void> get_info (BuildContext context) async {

  String table_name = globals.table_name;

  var databasesPath = await getDatabasesPath();
  String path = Path.join(databasesPath, 'storage.db');
  Database database = await openDatabase(
      path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $table_name ("
            "name TEXT)");
      }
  );

//  await database.rawDelete('DELETE FROM $table_name');

  List<Map> row = await database.rawQuery(
      "SELECT * FROM $table_name");
  if (row.length == 0) {
    globals.name = "";
  } else {
    globals.name = row[0]['name'];
  }

//    print(name);

  bool first_time = (globals.name != "") ? false : true;


  while (first_time) {
    final input_controller = TextEditingController();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
              height: 300,
              width: 200,
              child: AlertDialog(
                  title: Text("input your name"),
                  content: Column(
                    children: <Widget>[
                      new Expanded(
                        child: new TextField(
                            controller: input_controller,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                filled: false,
                                contentPadding: new EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 10),
                                hintText: " input your name in here",
                                hintStyle: new TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 18)

                            )
                        ),
                        flex: 2,
                      ),
                      new Container(
                        height: 75,
                        width: 275,
                        padding: new EdgeInsets.all(5),
                        child: RaisedButton(
                          color: Colors.red.shade600,
                          onPressed: () async {
                            String input_name;
                            input_name = input_controller.text;
//                              print(input_name);
                            if (input_name != "") {
                              first_time = false;
                              globals.name = input_name;
                              await database.transaction((txn) async {
                                await txn.rawInsert(
                                    'INSERT INTO $table_name(name) '
                                        'VALUES("' + globals.name + '")'
                                );
                                print("inserted " + globals.name);
                              });
                              Navigator.of(context).pop();

                            }
                          },
                          child: Text(
                            "START",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 25
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
              )
          );
        }
    );
  }
}