import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

final database_reference = Firestore.instance;

void testing__get_data() {
  List<DocumentSnapshot> data = new List<DocumentSnapshot>();

  database_reference
    .collection("Users")
    .getDocuments()
    .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach(
        (f) {
          print('${f.data}');
          data.add(f);
        }
      );
    }
  );
  print(data);
}

void get_menus_name () {
//  List<String> _menus_name = [];
  database_reference.collection('Menus')
    .getDocuments()
    .then(
      (QuerySnapshot snapshot) {
      globals.menu_names.clear();

      snapshot.documents.forEach(
          (f) {
            globals.menu_names.add(f.documentID);
//            print(f.documentID);
//            print(globals.menus_name);
          }
        );
      }
    );
//  print(globals.menus_name);
}

void get_menu_item (String menu_name) {
  database_reference
    .collection('Menus')
    .document(menu_name)
    .snapshots()
    .forEach(
      (f) {
        print(f.data);
        print(f.data.values.toList()[0]['price']);
      }
    );
}

void get_exist_order () {
  database_reference.collection('Orders')
    .getDocuments().then((QuerySnapshot snapshot) {
      globals.exist_orders.clear();

      snapshot.documents.forEach((f) {
//        print(f.documentID);
        globals.exist_orders.add(f.documentID);
//        print(globals.exist_orders);
      });

      globals.order_counter = globals.exist_orders.length;

  }
  );
}

void create_order(String order_name, String menu_name, String creator_name, String password) async {

  /*******結構*******
   * 在Firebase上
   * Orders--
   *        \(訂單名)
   *        \走~柳川館--
   *                  \password (密碼): "6969669"
   *                  \柳川館 (菜單名) 每次使用就用名字爬菜單出來
   *        \維琪媽媽不見了
   *        \氪金完沒錢了，吃吉利
   *
   * 這是訂單的儲存結構
   *
   * ****************/


   /****
   * @Parameter:
   *   order_name: 訂單名
   *   menu_name: 店家名 (如果把菜單整個加進去，每日免費流量可能會爆炸...吧?)
   *   password: 密碼
   *
   ****/

  await database_reference.collection('Orders')
    .document(order_name)
    .setData({
      "menu": menu_name,
      "password": password,
      "creator_name": creator_name,
      "state": true
    }
  );
}

void create_menu (String shop_name, List<Map> menu_infos) {

  /*******結構*******
  * 在Firebase上
  * Menus--
  *       \(店家名)
  *       \柳川館--
  *              \肉燥飯--
  *                     \info--
  *                           \price: 45 (number)
  *       \維琪媽媽
  *       \吉利自助餐
  *
  * 這是菜單的儲存結構
  *
  * ****************/

  /****
  * @Parameter:
  *   shop_name: 店家名
  *   menu_infos: {
  *       menu_info: {
  *           name: 餐點名 String
  *           price: 價格  Int
  *       }
  *       menu_info,
  *       menu_info,
  *   }
  *
  ****/


  menu_infos.forEach(
    (menu_info) async {
      await database_reference.collection("Menus")
          .document(shop_name)
          .collection(menu_info['name'])
          .document("info")
          .setData(
          {
            'price': menu_info['price']
          }
      );
    }
  );

}