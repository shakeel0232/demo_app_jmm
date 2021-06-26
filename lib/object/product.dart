class Product {
  String product_name;
  String product_price;
  String product_qty;
  String product_url;

  Product({
    required this.product_name,
    required this.product_price,
    required this.product_qty,
    required this.product_url,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_name: json['product_name'],
      product_price: json['product_price'],
      product_qty: json['product_qty'],
      product_url: json['product_url'],
    );
  }
}
