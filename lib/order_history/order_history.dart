import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/constants/constant.dart';
import 'package:demo_app_jmm/order_history/order_history_detail.dart';
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
        appBar: AppBar(
          title: Text(
            'Orders',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: showGrandTotal(context));
  }

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
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, int index) {
                      var data = snapshot.data!.docs[index].data();
                      var date = data['date'];
                      var grand_total = data['grand_total'].toString();
                      var order_status = data['order_status'].toString();
                      return Card(
                          shadowColor: Colors.red,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    new MaterialPageRoute(
                                      builder: (c) {
                                        return new OrderHistoryDetail(
                                            snapshot.data!.docs[index].id);
                                      },
                                    ),
                                  );
                                },
                                title: Container(
                                  child: Text(
                                    order_status,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange),
                                  ),
                                ),
                                subtitle: Container(
                                  child: Text(
                                    DateFormat('kk:mm - dd-MMM-yyyy').format(
                                        DateTime.parse(
                                            date.toDate().toString())),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange),
                                  ),
                                ),
                                trailing: Text(
                                  'Grand Total: ' + grand_total,
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
