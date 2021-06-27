import 'package:demo_app_jmm/object/product.dart';
import 'package:flutter/material.dart';

// var qty = 1;
var product_qty;
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
            Center(child: Text('Selected Products',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30),)),
            // Center(child: Text('Select Products',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 10),)),
            Center(child: ListView.builder(
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (_, int index) {
                  var product_price=data[index].product_price;
                   product_qty=int.parse(data[index].product_qty);
                  return Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          product_qty += double.parse(product_qty);
                          // product_qty =10;
                          // /product_qty +=  product_qty;
                        });
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
                        'SAR ' + data[index].product_price.toString(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                      ),
                      // title: Text(data[index].product_name.toString()),
                      // trailing: Text('SAR : ' + data[index].product_price.toString()),
                      subtitle: Text(product_qty.toString() +
                          ' x ' +
                          data[index].product_price.toString(),            style: TextStyle(
                          fontSize: 10,
                          // fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),),
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
              onPressed: () {},
              child: Text('Place Order'),
              // style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
