class Product {
  final String name;
  final String description;
  final double price;
  final String imagePath;

  Product(this.name, this.description, this.price, this.imagePath);

  static fromMap(Map<String, dynamic> map) {}
}
