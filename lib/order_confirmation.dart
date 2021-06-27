import 'package:demo_app_jmm/object/product.dart';
import 'package:flutter/material.dart';

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
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (_, int index) {
            return Card(
              child: ListTile(

                title: Text(data[index].product_name.toString()),
                subtitle: Text(data[index].product_price.toString()),
                trailing: Text(data[index].product_qty.toString()),
              ),
            );
          }),
      bottomNavigationBar: showGrandTotal(context),
    );
  }
  showGrandTotal(context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Wrap(
        children: [
          Container(
            color: Colors.redAccent,
            height: 1,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
            width: MediaQuery
                .of(context)
                .size
                .width,
          ),
          Container(
            alignment: Alignment.centerRight,
            // margin: EdgeInsets.all(10),
            // padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
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
