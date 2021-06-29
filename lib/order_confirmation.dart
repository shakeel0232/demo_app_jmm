import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/constant.dart';
import 'package:demo_app_jmm/object/product.dart';
import 'package:demo_app_jmm/order_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var grandTotal=0;

int product_qty = 0;
int product_qty2 = 1;
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
    for (int z = 0; z < widget.list.length; z++) {
      listGT.add(int.parse(widget.list[z].product_price) *
          int.parse(widget.list[z].product_qty2));
    }
    for (var i = 0; i < listGT.length; i++) {
      listPQ.add(int.parse(widget.list[i].product_qty2));
      grandTotal += listGT[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> data = widget.list;
    // data.add(p);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Wrap(
          children: [
            Center(
                child: Text(
              'Selected Products',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),
            // Center(child: Text('Select Products',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 10),)),
            Center(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (_, int index) {
                      int product_price = int.parse(data[index].product_price);
                      return Card(
                        child: ListTile(
                          onTap: () {
                            listPQ.add(int.parse(widget.list[index].product_qty2));

                            setState(() {
                              // product_qty=int.parse( widget.list[index].product_qty2);
                              // product_q/ty++;
                              // product_qty=
                              listPQ[index]++;
                              // grandTotal = product_price * int.parse( widget.list[index].product_qty2);
                              grandTotal += (product_price *
                                  int.parse(widget.list[index].product_qty2));
                            });
                          },
                          title: Container(
                            // width: MediaQuery.of(context).size.width,
                            child: Text(
                              data[index].product_name.toString() +
                                  ' : ' +
                                  (data[index].product_id.toString()),
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
                          // title: Text(data[index].product_name.toString()),
                          // trailing: Text('SAR : ' + data[index].product_price.toString()),
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
                    })),
          ],
        ),
      ),
      /* body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (_, int index) {
            return Card(
              child: ListTile(
                onTap: () {
                  setState(() {
                    qty += int.parse(data[index].product_qty);
                  });
                },
                title: Text(data[index].product_name.toString()),
                trailing: Text('SAR : ' + data[index].product_price.toString()),
                subtitle: Text(qty.toString() +
                    'x' +
                    data[index].product_price.toString()),
              ),
            );
          }),*/
      bottomNavigationBar: showGrandTotal(context),
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
            // padding: EdgeInsets.all(10),
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
            // margin: EdgeInsets.all(10),
            // padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
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
              },
              child: Text('Place Order'),
            ),
          )
        ],
      ),
    );
  }

  addOrderItems(docId) async {
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
        'product_qty': widget.list[i].product_qty2,
        'product_url': widget.list[i].product_url
      });
      deductQty(widget.list[i].product_id,listPQ[i]);
      widget.list.clear();
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (c) {
            return new OrderHistory();
          },
        ),
      );
    }
  }

  deductQty(docId,value) {
    FirebaseFirestore.instance
        .collection('Products')
        .doc(docId)
        .update({'product_qty': FieldValue.increment(-value)}).then(
            (value) => Fluttertoast.showToast(msg: 'Successfully Place Order'));
  }
}
