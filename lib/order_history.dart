import 'package:accordion/accordion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/constant.dart';
import 'package:demo_app_jmm/order_history_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
double grandTotal = 0;

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Wrap(
          children: [
            Center(child: Text('Orders',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30),)),
            // Center(child: Text('Select Products',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 10),)),
            Center(child: showGrandTotal(context)),
          ],
        ),
      ),
      // body: showGrandTotal(context),
    );
  }

/*  showOrdersHistory(context) {
    return Container(
      margin: EdgeInsets.all(20),
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(appConstant().userId)
              .collection('Orders')
              .doc('RkZdmOVWG5FCKxauDanA')
              .collection('OrderProducts')
              // .orderBy("date", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                // alignment: Alignment.center,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    *//* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),*//*
                    itemCount: snapshot.data!.docs.length,
                    // itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, int index) {
                      var data = snapshot.data!.docs[index].data();
                      var product_name = data['product_name'].toString();
                      var product_price = data['product_price'].toString();
                      var product_qty = data['product_qty'].toString();
                      var product_url = data['product_url'].toString();
                      // var date = data['date'].toString();
                      return Card(
                          shadowColor: Colors.red,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: EdgeInsets.all(20),
                            child: ListTile(
                              onTap: () {
                                // index;

                                setState(() {
                                  grandTotal = 10;
                                });
                              },
                              title: Container(
                                // width: MediaQuery.of(context).size.width,
                                child: Text(
                                  product_name,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange),
                                ),
                              ),
                              trailing: Text(
                                'SAR ' + product_price,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange),
                              ),
                              subtitle: Text(
                                'Qty ' + product_qty,
                                style: TextStyle(
                                    fontSize: 10,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange),
                              ),
                              leading: Image.network(
                                  'https://cdn.shopify.com/s/files/1/2219/4035/products/9_0092150e-49ed-4355-af8d-a9a3abf741e5_1024x1024.jpg?v=1502164799'),
                            ),
                          ));
                    }),
              );
            } else {
              return Center(
                child: Text(''),
              );
            }
          }),
    );
  }*/

  showGrandTotal(context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(appConstant().userId)
              .collection('Orders')
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                // alignment: Alignment.center,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: snapshot.data!.docs.length,
                    // itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, int index) {
                      var data = snapshot.data!.docs[index].data();
                      var  date = data['date'];

                      var grand_total = data['grand_total'].toString();
                      var order_status = data['order_status'].toString();
                      return Card(
                          shadowColor: Colors.red,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              // margin: EdgeInsets.all(20),
                              child: ListTile(
                                onTap: () {

                                  Navigator.of(context).push(
                                    new MaterialPageRoute(
                                      builder: (c) {


                                        return new OrderHistoryDetail(snapshot.data!.docs[index].id);
                                      },
                                    ),
                                  );
                                },
                                title: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    order_status,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange),
                                  ),
                                ),                                subtitle: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  child: Text(DateFormat('kk:mm - dd-MMM-yyyy').format(DateTime.parse(date.toDate().toString())),
                                      // DateTime.parse(date.toDate().toString()).toString(),
                                    // DateTime.fromMillisecondsSinceEpoch(date ).t oString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange),
                                  ),
                                ),
                                trailing: Text(
                                  'Grand Total: '+grand_total,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange),
                                ),
                              )));
                    }),
              );
            } else {
              return Center(
                child: Text(''),
              );
            }
          }),
    );
  }
}
