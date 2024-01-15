import 'package:flutter/material.dart';
import 'product_description_screen.dart';
import 'product.dart';
import 'payment_screen.dart';

class ProductListView extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  List<Product> products = [
    Product(
        'Jagung',
        'Jagung adalah tanaman serealia yang dikenal dengan butiran kuning manisnya. Jagung biasanya ditanam sebagai sumber makanan utama atau digunakan sebagai bahan baku untuk berbagai produk makanan dan industri. Kaya akan serat dan nutrisi, jagung sering diolah menjadi berbagai produk seperti tepung jagung, jagung pipil, dan jagung manis yang enak. Selain itu, jagung juga digunakan dalam pakan ternak dan sebagai bahan bakar alternatif dalam bentuk etanol.',
        10000,
        'images/jagung.jpg'),
    Product(
        'Bawang',
        'Bawang adalah tanaman yang digunakan sebagai bumbu dalam berbagai masakan. Terdapat berbagai jenis bawang, seperti bawang merah, bawang putih, dan bawang bombay, masing-masing dengan rasa dan aroma yang khas. Bawang digunakan untuk memberi cita rasa pada makanan dan juga memiliki sifat antimikroba yang membuatnya berguna dalam pengobatan tradisional. Bawang merupakan komponen penting dalam berbagai hidangan dari berbagai budaya di seluruh dunia.',
        12000,
        'images/bawang.jpg'),
    Product(
        'Kayu Manis',
        'Kayu manis adalah rempah-rempah yang diperoleh dari kulit pohon kayu manis. Rempah ini dikenal dengan aroma manis dan rasa hangatnya yang unik. Kayu manis sering digunakan dalam berbagai hidangan, termasuk kue, pastry, minuman seperti cappuccino, dan masakan berbasis rempah. Selain digunakan sebagai bumbu makanan, kayu manis juga memiliki potensi manfaat kesehatan, seperti mengatur kadar gula darah dan memiliki sifat antioksidan.',
        6000,
        'images/kayumanis.jpg'),
    Product(
        'Kelapa',
        'Kelapa adalah buah tropis yang dikenal dengan daging buahnya yang lezat dan air kelapanya yang segar. Daging kelapa bisa digunakan dalam berbagai hidangan, mulai dari kari hingga hidangan penutup seperti es krim kelapa. Air kelapa juga merupakan minuman alami yang menyegarkan dan mengandung elektrolit alami, menjadikannya pilihan yang baik untuk rehidrasi. Selain itu, dari kelapa juga dihasilkan minyak kelapa yang digunakan dalam memasak, perawatan kulit dan rambut, serta industri kosmetik.',
        17000,
        'images/kelapa.jpg'),
    Product(
        'Kedelai',
        'Kedelai adalah tanaman kacang-kacangan yang kaya akan protein dan serat. Kedelai sering digunakan sebagai bahan dasar dalam produk-produk makanan seperti tahu, tempe, susu kedelai, dan berbagai produk olahan lainnya. Selain sebagai sumber protein nabati, kedelai juga digunakan dalam industri untuk menghasilkan minyak kedelai, yang digunakan dalam berbagai produk makanan dan non-makanan seperti sabun dan lilin.',
        5000,
        'images/kedelai.jpg'),
    // Tambahkan produk lain di sini
  ];

  double totalSale = 0;
  int cartItemCount = 0;

  // List untuk menyimpan produk yang dibeli
  List<Product> cartProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk Pertanian'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    cartProducts: cartProducts,
                    totalSale: totalSale,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Column(
            children: [
              Container(
                width:
                    double.infinity, // Agar gambar mengisi seluruh lebar layar
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.cover,
                  height: 200, // Tinggi gambar
                ),
              ),
              ListTile(
                title: Align(
                  // Menempatkan nama produk di tengah
                  alignment: Alignment.center,
                  child: Text(
                    product.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Align(
                  // Menempatkan harga di tengah
                  alignment: Alignment.center,
                  child: Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDescriptionScreen(product: product),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _startSale(product);
                },
                child: Text(
                  'Beli',
                  style: TextStyle(fontSize: 18), // Mengatur ukuran teks tombol
                ),
              ),
              SizedBox(height: 16), // Jarak antara item produk
            ],
          );
        },
      ),
    );
  }

  void _startSale(Product product) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Beli ${product.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Harga: Rp ${product.price.toStringAsFixed(0)}'),
                  SizedBox(height: 10),
                  Text('Jumlah:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    double subTotal = product.price * quantity;
                    setState(() {
                      totalSale += subTotal;
                      // Menambahkan produk yang dibeli ke dalam keranjang
                      for (int i = 0; i < quantity; i++) {
                        cartProducts.add(product);
                      }
                      // Update jumlah item di keranjang
                      cartItemCount += quantity;
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text('Beli'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showContactDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
