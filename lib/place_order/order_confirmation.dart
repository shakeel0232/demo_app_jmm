import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/constants/constant.dart';
import 'package:demo_app_jmm/main.dart';
import 'package:demo_app_jmm/object/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var grandTotal = 0;
List<int> listGT = [];
List<int> listPQ = [];

class OrderConfirmation extends StatefulWidget {
  List<Product> list;

  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();

  OrderConfirmation(this.list);
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.list.length > 0) {
      for (int z = 0; z < widget.list.length; z++) {
        listGT.add(int.parse(widget.list[z].product_price) *
            int.parse(widget.list[z].product_selected_qty));
      }

      for (int i = 0; i < listGT.length; i++) {
        listPQ.add(int.parse(widget.list[i].product_selected_qty));
        grandTotal += listGT[i];
      }
    }
  }

  Future<bool> onWillPop() {
    widget.list.clear();
    listPQ.clear();
    grandTotal=0;
    listGT.clear();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    List<Product> data = widget.list;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Selected Products',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (_, int index) {
              int product_price = int.parse(data[index].product_price);
              return Card(
                child: ListTile(
                  onTap: () {
                    listPQ.add(
                        int.parse(widget.list[index].product_selected_qty));
                    setState(() {
                      listPQ[index]++;
                      grandTotal += (product_price *
                          int.parse(widget.list[index].product_selected_qty));
                    });
                  },
                  title: Container(
                    child: Text(
                      data[index].product_name.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    ),
                  ),
                  trailing: Text(
                    'SAR ' + (listPQ[index] * product_price).toString(),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                  subtitle: Text(
                    listPQ[index].toString() +
                        ' x ' +
                        data[index].product_price.toString(),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                  leading: Image.network(data[index].product_url),
                ),
              );
            }),
        bottomNavigationBar: showGrandTotal(context),
      ),
    );
  }

  showGrandTotal(context) {
    var docId;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Wrap(
        children: [
          Container(
            color: Colors.redAccent,
            height: 1,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Grand Total : SAR. ' + grandTotal.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.redAccent,
            height: 1,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                if (grandTotal > 0 && widget.list.length > 0) {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(appConstant().userId)
                      .collection('Orders')
                      .add({
                    'grand_total': grandTotal,
                    'order_status': 'pending',
                    'date': FieldValue.serverTimestamp()
                  }).then((value) => docId = value.id);
                  addOrderItems(docId);
                } else {
                  Fluttertoast.showToast(msg: 'Please add items');
                }
              },
              child: Text('Place Order'),
            ),
          )
        ],
      ),
    );
  }

  addOrderItems(docId) async {
    print('len:001: ' + widget.list.length.toString());
    for (int i = 0; i < widget.list.length; i++) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(appConstant().userId)
          .collection('Orders')
          .doc(docId)
          .collection('OrderProducts')
          .add({
        'product_name': widget.list[i].product_name,
        'product_price': widget.list[i].product_price,
        'product_qty': listPQ[i],
        'product_url': widget.list[i].product_url
      });
      deductQty(widget.list[i].product_id, listPQ[i]);
    }
    setState(() {
      widget.list.clear();
      grandTotal = 0;
      listGT.clear();
      listPQ.clear();
    });

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (c) {
          return new MyApp();
        },
      ),
    );
  }

  deductQty(docId, value) {
    FirebaseFirestore.instance
        .collection('Products')
        .doc(docId)
        .update({'product_qty': FieldValue.increment(-value)}).then(
            (value) => Fluttertoast.showToast(msg: 'Successfully Place Order'));
  }
}
