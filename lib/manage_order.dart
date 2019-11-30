import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:luncher/firebase_controller.dart' as firebase;

Widget manage_orders_page (BuildContext context) {

  firebase.get_menus_name();
  firebase.get_exist_order();

  return new Scaffold(
    appBar: AppBar(
      title: Text('管理訂單'),
    ),
    body: Container(
      width: 500,
      height: 1000,
      child: selected_order_list()
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
        size: 40,),
    ),
  );
}

Widget selected_order_list () {
  return ListView.builder(
    itemCount: globals.order_counter,
    itemBuilder: (context, index) {
      return selected_menu_row(context, index);
    },
  );
}

String selected_order;

Widget selected_order_row (BuildContext context, int index) {
  return SizedBox(
    width: double.infinity,
    height: 150,
    child: Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: RaisedButton(
        onPressed: () {
          selected_order = globals.exist_orders[index];
        },
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                "state",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.deepPurple,
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Text(
                globals.exist_orders[index],
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.deepPurple,
                ),
              ),
              flex: 2,
            ),
          ],
        ),
      )
    ),
  );
}

class manage_order_page extends StatefulWidget {

  @override
  _manage_order_page_state createState () {
    return _manage_order_page_state();
  }
}

class _manage_order_page_state extends State<manage_order_page> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selected_order),
      ),
      body: Container(
        child: ,
      ),
    );
  }
}

Widget stream_build(BuildContext context) {
  return new StreamBuilder(
      stream: Firestore.instance.collection('Users')
          .document('for_test')
          .snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Loading");
        }
        var userDocument = snapshot.data;
        return new Text(userDocument["name"]);
      }
  );
}

class set_order_page extends StatefulWidget {

  @override
  State<StatefulWidget> createState () {
    return _set_order_page_state();
  }

}

String selected_menu = "";
String order_name_input_error = "訂單名";
String password_input_error = "密碼";
String menu_input_error = "選擇";

var order_name_color = Colors.grey.shade500;
var password_color = Colors.grey.shade500;
var menu_color = Colors.purple;

class _set_order_page_state extends State<StatefulWidget> {

  final _password_controller = new TextEditingController();
  final _order_name_controller = new TextEditingController();

  void _order_name_empty () {
    setState(() {
      order_name_input_error = "訂單名不能為空";
      order_name_color = Colors.red.shade500;
    });
  }
  void _order_name_typed () {
    setState(() {
      order_name_input_error = "訂單名";
      order_name_color = Colors.grey.shade500;
    });
  }
  void _password_empty () {
    setState(() {
      password_input_error = "密碼不能為空";
      password_color = Colors.red.shade500;
    });
  }
  void _password_typed () {
    setState(() {
      password_input_error = "密碼";
      password_color = Colors.grey.shade500;
    });
  }
  void _order_exist () {
    setState(() {
      order_name_input_error = "訂單名已存在";
      order_name_color = Colors.red.shade500;
    });
  }
  void _order_not_exist () {
    setState(() {
      order_name_input_error = "訂單名";
      order_name_color= Colors.grey.shade500;
    });
  }
  void _menu_empty () {
    setState(() {
      menu_input_error = "菜單不能為空";
      password_color = Colors.red.shade500;
    });
  }
  void _menu_typed () {
    setState(() {
      menu_input_error = selected_menu;
      password_color = Colors.grey.shade500;
    });
  }

  void _order_counter_increase () {
    setState(() {
      globals.order_counter++;
    });
  }

  void _create_order_check () {

    bool is_exist = (globals.exist_orders.indexOf(_order_name_controller.text) == -1) ? false : true;

    if(_order_name_controller.text != ""
        &&
        _password_controller.text != ""
        &&
        !is_exist
        &&
        selected_menu != ""
      ){

      firebase.create_order(
          _order_name_controller.text,
          selected_menu,
          globals.user_name,
          _password_controller.text);

      _order_counter_increase();

      Navigator.pop(context);
    }

    if(_order_name_controller.text == ""){
      _order_name_empty();
    }else{
      _order_name_typed();

      if(is_exist) {
        _order_exist();

      }else{
        _order_not_exist();

      }
    }

    if(_password_controller.text == ""){
      _password_empty();
    }else{
      _password_typed();
    }

    if(selected_menu == "") {
      menu_input_error = selected_menu;
    }
  }

  @override
  Widget build(BuildContext context) {

    firebase.get_menus_name();
    firebase.get_exist_order();

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
                                labelText: order_name_input_error,
                                labelStyle: new TextStyle(
                                    color: order_name_color,
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
                              menu_input_error,
                              style: TextStyle(
                                color: menu_color,
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
                                  labelText: password_input_error,
                                  labelStyle: new TextStyle(
                                      color: password_color,
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
                          _create_order_check();
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


class choose_menu_page extends StatefulWidget {
//  final Stream stream;
//  choose_menu_page({this.stream});
//
//  static of(BuildContext context, {bool root = false}) => root
//    ? context.rootAncestorStateOfType(const TypeMatcher<choose_menu_page_state>())
//    : context.ancestorRenderObjectOfType(const TypeMatcher<choose_menu_page_state>());


  @override
  _choose_menu_page_state createState() {
    return _choose_menu_page_state();
  }}

class _choose_menu_page_state extends State<choose_menu_page> {


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
          child: selected_menu_list(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('testing');
        },
        child: Icon(Icons.add, size: 40,),
      ),
    );
  }
}


Widget selected_menu_list(BuildContext context) {

  return ListView.builder(
    itemCount: globals.menu_names.length,
    itemBuilder: (context, index) {
      print(globals.menu_names[index]);
      return selected_menu_row(context, index);
    },
  );
}

Widget selected_menu_row (BuildContext context, int index) {
  return SizedBox(
    width: double.infinity,
    height: 70,
    child: new Padding(
      padding: EdgeInsets.only(
          left: 10, right: 10, top: 10),
      child: RaisedButton(
        child: Text(
          globals.menu_names[index],
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {

          selected_menu = globals.menu_names[index];
          menu_input_error = globals.menu_names[index];

          print(selected_menu);
          Navigator.pop(context);
        },

      ),
    )
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
