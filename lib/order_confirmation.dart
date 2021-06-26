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
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (_, int index) {
          return Card(
            child: ListTile(title: Text(data[index].product_name.toString()),),

          );
        });
  }
}
