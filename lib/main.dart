import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(child: showProducts(context)),
        ),
      ),
    );
  }
}

showProducts(context) {
  return Container(
    margin: EdgeInsets.all(20),
    // height: 200,
    width: MediaQuery.of(context).size.width,
    child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Products') .orderBy("date", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
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
                          // margin: EdgeInsets.all(20),
                          child: ListTile(
                            onTap: (){

                            },
                            title: Text(
                              product_name,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                            ),
                            subtitle: Text(
                              'SAR ' + product_price,
                              style: TextStyle(
                                  fontSize: 10,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                            ),
                            trailing: Text(
                              'Qty ' + product_qty,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
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
