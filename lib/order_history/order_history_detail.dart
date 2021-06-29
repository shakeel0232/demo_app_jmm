import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/constants/constant.dart';
import 'package:flutter/material.dart';

double grandTotal = 0;

class OrderHistoryDetail extends StatefulWidget {
  String id;
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
  OrderHistoryDetail(this.id);
}

class _OrderHistoryState extends State<OrderHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),),
      body: showOrdersHistory(context),
    );
  }

  showOrdersHistory(context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(appConstant().userId)
              .collection('Orders')
              .doc(widget.id)
              .collection('OrderProducts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, int index) {
                      var data = snapshot.data!.docs[index].data();
                      var product_name = data['product_name'].toString();
                      var product_price = data['product_price'].toString();
                      var product_qty = data['product_qty'].toString();
                      var product_url = data['product_url'].toString();
                      return Card(
                          shadowColor: Colors.red,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  grandTotal = 10;
                                });
                              },
                              title: Container(
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

}
