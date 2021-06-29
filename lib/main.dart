import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/object/product.dart';
import 'package:demo_app_jmm/order_history/order_history.dart';
import 'package:demo_app_jmm/place_order/order_confirmation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

int product_qty = 0;
int product_selected_qty = 1;
double grandTotal = 0;
List<Product> selectedList = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (c) {
                return new OrderHistory();
              },
            ),
          );
        },
      ),
      body: showProducts(context),
      bottomNavigationBar: showGrandTotal(context),
    );
  }

  showProducts(context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .orderBy("date", descending: false)
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
                      var product_id = snapshot.data!.docs[index].id;
                      var product_name = data['product_name'].toString();
                      var product_price = data['product_price'].toString();
                      product_qty = data['product_qty'];
                      var product_url = data['product_url'].toString();
                      return Card(
                          shadowColor: Colors.red,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: ListTile(
                              onTap: () {
                                Product p = new Product(
                                    product_id: product_id,
                                    product_name: product_name,
                                    product_price: product_price,
                                    product_qty: product_qty.toString(),
                                    product_selected_qty: product_selected_qty.toString(),
                                    product_url: product_url);

                                setState(() {
                                  grandTotal += double.parse(product_price);
                                });
                                selectedList.add(p);
                                Fluttertoast.showToast(
                                    msg: product_name + ' : Added',
                                    toastLength: Toast.LENGTH_SHORT,
                                    fontSize: 16.0);
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
                                'Qty ' + product_qty.toString(),
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.deepOrange),
                              ),
                              leading: Image.network(product_url),
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
              'Total : SAR. ' + grandTotal.toString(),
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
              onPressed: () {
                if (grandTotal > 0 && selectedList.length > 0) {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (c) {
                        return new OrderConfirmation(selectedList);
                      },
                    ),
                  );
                  setState(() {
                    grandTotal = 0;
                  });
                } else {
                  Fluttertoast.showToast(msg: 'Please add items');
                }
              },
              child: Text('Next'),
            ),
          )
        ],
      ),
    );
  }
}
