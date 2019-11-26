import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luncher/firebase_controller.dart' as firebase;

Widget manage_order_page (BuildContext context) {
  return new Scaffold(
    appBar: AppBar(
      title: Text('管理訂單'),
    ),
    body: Container(
      width: 500,
      height: 1000,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: 160.0,
            color: Colors.red,
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => set_order_page()
            )
        );
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 20,),
    ),
  );
}

class set_order_page extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _set_order_page_state();
  }

}



class _set_order_page_state extends State<StatefulWidget> {

  final _password_controller = new TextEditingController();
  final _order_name_controller = new TextEditingController();
  String menu_name = "選擇";
  String _order_name_input_error = "訂單名";
  var _order_name_color = Colors.grey.shade500;
  String _password_input_error = "密碼";
  var _password_color = Colors.grey.shade500;

  void _order_name_empty () {
    setState(() {
      _order_name_input_error = "訂單名不能為空";
      _order_name_color = Colors.red.shade500;
    });
  }
  void _order_name_typed () {
    setState(() {
      _order_name_input_error = "訂單名";
      _order_name_color = Colors.grey.shade500;
    });
  }
  void _password_empty () {
    setState(() {
      _password_input_error = "密碼不能為空";
      _password_color = Colors.red.shade500;
    });
  }
  void _password_typed() {
    setState(() {
      _password_input_error = "密碼";
      _password_color = Colors.grey.shade500;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
          title: Text('創建訂單'),
        ),
        body: new Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: <Widget>[
                        new Text(
                          "訂單名",
                          style: TextStyle(
                              fontSize: 25
                          ),
                        ),
                        Container(
                          width: 245,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: new TextFormField(
                              style: TextStyle(
                                fontSize: 25,
                              ),
                              controller: _order_name_controller,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                contentPadding: new EdgeInsets.all(5),
                                labelText: _order_name_input_error,
                                labelStyle: new TextStyle(
                                    color: _order_name_color,
                                    fontSize: 17),
                              ),
                              autofocus: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: <Widget>[
                        new Text(
                          "菜單",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: new RaisedButton(
                            child: Text(
                              menu_name,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 25,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => choose_menu_page()
                                )
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: <Widget>[
                        new Text(
                          "密碼",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Container(
                            width: 270,
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: new TextField(
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                                controller: _password_controller,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: new EdgeInsets.all(5),
                                  labelText: _password_input_error,
                                  labelStyle: new TextStyle(
                                      color: _password_color,
                                      fontSize: 17),

                                ),
//                                autofocus: true,
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Center(
                      child: RaisedButton(
                        onPressed: (){
                          if(_order_name_controller.text != ""
                              &&
                              _password_controller.text != ""){

                            print("selecting menu");
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => choose_menu_page()
//                                )
//                            );
                          }
                          if(_order_name_controller.text == ""){
                            _order_name_empty();
                          }else{
                            _order_name_typed();
                          }
                          if(_password_controller.text == ""){
                            _password_empty();
                          }else{
                            _password_typed();
                          }
                        },
                        child: Text(
                          "創建",
                          style: TextStyle(
                              fontSize: 25
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )
        )
    );
  }
}


class choose_menu_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
          title: Text('選擇菜單'),
        ),
        body: Center(
          child: Container(
            width: 500,
            height: 1000,
            child: stream_build(context),
          ),
        )

    );
  }
}


Widget stream_build(BuildContext context) {
  return new StreamBuilder(
      stream: Firestore.instance.collection('Menus')
        .snapshots()
      ,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Loading...");
        }

        var userDocument = snapshot.data;
        return new Text(userDocument["name"]);
      }
  );
}


void showWindow (BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
            height: 100,
            width: 100,


            // 跳出打名字的視窗
            child: AlertDialog(
                title: Text("格式錯誤"),
                content: Column(
                    children: <Widget>[
                      Text("test")

                    ]
                )
            )
        );
      }
  );
}
//Widget stream_build(BuildContext context) {
//  return new StreamBuilder(
//      stream: Firestore.instance.collection('Users')
//          .document('for_test')
//          .snapshots(),
//
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) {
//          return new Text("Loading");
//        }
//        var userDocument = snapshot.data;
//        return new Text(userDocument["name"]);
//      }
//  );
//}
