import 'package:accordion/accordion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      body: showGrandTotal(context),
      // bottomNavigationBar: showOrdersHistory(context),
    );
  }

  showOrdersHistory(context) {
    return Container(
      margin: EdgeInsets.all(20),
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc('W9lxAPG5ZmPKvhAX2YLz')
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
                    /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),*/
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
  }

  showGrandTotal(context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc('W9lxAPG5ZmPKvhAX2YLz')
              .collection('Orders')
              // .orderBy("date", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                // alignment: Alignment.center,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    // itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, int index) {
                      var data = snapshot.data!.docs[index].data();
                      var date = data['date'].toString();
                      var grand_total = data['grand_total'].toString();
                      var order_status = data['order_status'].toString();
                      return Accordion(
                        maxOpenSections: 1,
                        headerTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,),
                        leftIcon: Icon(Icons.audiotrack, color: Colors.white),
                        children: [
                          AccordionSection(
                            isOpen: true,
                            content: Icon(Icons.airplanemode_active,
                                size: 200, color: Colors.amber),
                            /*content: Card(
                                shadowColor: Colors.red,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.all(20),
                                    child: ListTile(
                                      onTap: () {},
*//*                                      title: Container(
                                        // width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          order_status,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange),
                                        ),
                                      ),
                                      trailing: Text(
                                        grand_total,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrange),
                                      ),*//*
                                    ))),*/
                            headerText: grand_total,
                          ),
                        ],
                      );
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
