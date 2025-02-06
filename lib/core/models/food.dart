class Food {
  String id;
  String name;
  double price;
  bool isVeg;
  int quantity;
  String barcode;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.isVeg,
    required this.quantity,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'isVeg': isVeg,
      'quantity': quantity,
      'barcode': barcode,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      isVeg: map['isVeg'],
      quantity: map['quantity'],
      barcode: map['barcode'],
    );
  }
}
