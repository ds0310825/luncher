import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final databaseReference = Firestore.instance;

void getData() {
  List<DocumentSnapshot> data = new List<DocumentSnapshot>();

  databaseReference
      .collection("Users")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach(
      (f) {
        print('${f.data}}');
        data.add(f);
      }
    );
  });
  print(data);
}

void createOrder(String orderName, String menuName, String passWord) async {

  /*******結構*******
   * 在Firebase上
   * Orders--
   *        \(訂單名)
   *        \走~柳川館--
   *                  \passWord (密碼): "6969669"
   *                  \柳川館 (菜單名) 每次使用就用名字爬菜單出來
   *        \維琪媽媽不見了
   *        \氪金完沒錢了，吃吉利
   *
   * 這是訂單的儲存結構
   *
   * ****************/


   /****
   * @Parameter:
   *   orderName: 訂單名
   *   menuName: 菜單名 (如果把菜單整個加進去，每日免費流量可能會爆炸...吧?)
   *   passWord: 密碼
   *
   ****/

  await databaseReference.collection(orderName)
      .document("柳川館")
      .collection("肉燥飯")
      .document("info")
      .setData({
        'passWord': passWord,
        'menuName': menuName,
      }
  );
}

void createMenu (String shopName, List<Map> menuInfos) {

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
  *   shopName: 店家名
  *   menuInfos: {
  *       menuInfo: {
  *           name: 餐點名 String
  *           price: 價格  Int
  *       }
  *       menuInfo,
  *       menuInfo,
  *   }
  *
  ****/


  menuInfos.forEach(
    (menuInfo) async {
      await databaseReference.collection("Menus")
          .document(shopName)
          .collection(menuInfo['name'])
          .document("info")
          .setData(
          {
            'price': menuInfo['price']
          }
      );
    }
  );

}