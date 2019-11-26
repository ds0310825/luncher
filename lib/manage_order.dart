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

class set_order_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order_name_controller = TextEditingController();
    final menu_name_controller = TextEditingController();
    final password_controller = TextEditingController();
    String menu_name = "選擇";

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
                        child: new TextField(
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            controller: order_name_controller,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: true,

                              contentPadding: new EdgeInsets.all(5),
                              hintText: "訂單名",
                              hintStyle: new TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 25),


                            )
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
                          print("selecting menu");

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
                              controller: password_controller,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: new EdgeInsets.all(5),
                                  hintText: "密碼",
                                  hintStyle: new TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 25)

                              )
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
