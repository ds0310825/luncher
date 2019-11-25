import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'globals.dart' as globals;

Future<void> showWindow (BuildContext context) async {

  String table_name = globals.table_name;

  var databasesPath = await getDatabasesPath(); // 獲取databese路徑
  String path = Path.join(databasesPath, 'storage.db');

  // 尋找資料庫 "storage.db/table_name" 是否存在
  // 如果沒有就創建一個
  // name: 用戶名
  Database database = await openDatabase(
      path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $table_name ("
            "name TEXT)");
      }
  );

// 刪除資料庫 (測試用)
//  await database.rawDelete('DELETE FROM $table_name');

  // 把資料庫的全部資料抓出來 (反正也只會有一個)
  List<Map> row = await database.rawQuery(
      "SELECT * FROM $table_name");
  if (row.length == 0) {
    globals.name = ""; // 如果資料庫是空的 or 用戶名是空的
  } else {
    globals.name = row[0]['name']; // 直接取出名字
  }

//    print(name);

  // 名字是空的就是第一次進入
  bool first_time = (globals.name != "") ? false : true;

  // 如果是第一次，要好好對待人家哦<3~
  while (first_time) {
    final input_controller = TextEditingController();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
              height: 300,
              width: 200,


              // 跳出打名字的視窗
              child: AlertDialog(
                  title: Text("input your name"),
                  content: Column(
                    children: <Widget>[

                      // 輸入框
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

                        // 這是按鈕
                        child: RaisedButton(
                          color: Colors.red.shade600,
                          onPressed: () async {
                            String input_name;

                            // 從輸入格取出String
                            input_name = input_controller.text;
//                              print(input_name);

                            // 如果輸入的是空白的，就繼續留著視窗不關
                            // 如果有輸入東西，就把他就把他儲存在storage.db/table_name裡面
                            if (input_name != "") {
                              first_time = false;
                              globals.name = input_name;
                              await database.transaction((txn) async {
                                // 儲存資料
                                await txn.rawInsert(
                                    'INSERT INTO $table_name(name) '
                                        'VALUES("' + globals.name + '")'
                                );
                                print("inserted " + globals.name);
                              });
                              // 把輸入視窗從螢幕顯示拿掉
                              Navigator.of(context).pop(); // pop(): 拿掉陣列最上層

                            }
                          },

                          // 按鈕字
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