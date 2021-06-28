import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/constant.dart';
import 'package:demo_app_jmm/object/product.dart';
import 'package:flutter/material.dart';

// var qty = 1;
int product_qty=0;

class OrderConfirmation extends StatefulWidget {
  List<Product> list;

  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();

  OrderConfirmation(this.list);
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  @override
  Widget build(BuildContext context) {
    List<Product> data = widget.list;
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
                      // product_qty = 1;
                      // product_qty = int.parse(data[index].product_qty);
                      return Card(
                        child: ListTile(
                          onTap: () {
                            print(product_qty);
                            setState(() {
                              product_qty ++;
                              // product_qty =10;
                              // /product_qty +=  product_qty;
                            });
                            print(product_qty);
                          },
                          title: Container(
                            // width: MediaQuery.of(context).size.width,
                            child: Text(
                              data[index].product_name.toString(),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                            ),
                          ),
                          trailing: Text(
                            'SAR ' +
                            (product_qty *product_price).toString(),
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                          // title: Text(data[index].product_name.toString()),
                          // trailing: Text('SAR : ' + data[index].product_price.toString()),
                          subtitle: Text(
                            product_qty.toString() +
                                ' x ' +
                                data[index].product_price.toString(),
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                          leading: Image.network(
                              data[index].product_url),
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
              'Grand Total : SAR. ' + "grandTotal".toString(),
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
               await  FirebaseFirestore.instance
                    .collection('Users')
                    .doc(appConstant().userId)
                    .collection('Orders')
                    .add({
                  'grand_total': 1200,
                  'order_status': 'pending',
                  'date': FieldValue.serverTimestamp()
                }).then((value) => docId =value.id);
                
               for(int i=0;i<widget.list.length;i++){
                 FirebaseFirestore.instance
                     .collection('Users')
                     .doc(appConstant().userId)
                     .collection('Orders').doc(docId).collection('OrderProducts')
                     .add({
                   'product_name': widget.list[i].product_name,
                   'product_price': widget.list[i]. product_price,
                   'product_qty': widget.list[i].product_qty,
                   'product_url': widget.list[i].product_url
                 });
               }

              },
              child: Text('Place Order'),
              // style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
