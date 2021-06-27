import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_jmm/object/product.dart';
import 'package:demo_app_jmm/order_confirmation.dart';
import 'package:demo_app_jmm/order_history.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "dart:collection";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

double grandTotal = 0;
List<Product> selectedList = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
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
      appBar: AppBar(),
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
      body: Container(
        child: Wrap(
          children: [
            Center(child: showProducts(context)),
          ],
        ),
      ),
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
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    // itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, int index) {
                      var data = snapshot.data!.docs[index].data();
                      var product_name = data['product_name'].toString();
                      var product_price = data['product_price'].toString();
                      var product_qty = data['product_qty'].toString();
                      var product_url = data['product_url'].toString();
                      var date = data['date'].toString();
                      return Card(
                          shadowColor: Colors.red,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: EdgeInsets.all(20),
                            child: ListTile(
                              onTap: () {
                                Product p = new Product(
                                    product_name: product_name,
                                    product_price: product_price,
                                    product_qty: product_qty,
                                    product_url: product_url);
                                // print(selectedList.contains(p));
                                // List<Product> result =
                                //     LinkedHashSet<Product>.from(selectedList)
                                //         .toList();
                                // print(result);
                                if (!selectedList.contains(p)) {
                                  selectedList.add(p);
                                  setState(() {
                                    grandTotal += double.parse(product_price);
                                  });
                                }
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
              onPressed: () {
                print(selectedList);
                selectedList= selectedList.toSet().toList();
                print(selectedList);
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {


                      return new OrderConfirmation(selectedList);
                    },
                  ),
                );
              },
              child: Text('Next'),
              // style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
