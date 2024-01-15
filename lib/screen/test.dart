import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatelessWidget {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> products =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Data Produk'),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Column(
            children: [
              //// VIEW DATA HERE
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: products.snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          var doc = snapshot.data!.docs[index];
                          return Dismissible(
                            key: Key(doc.id),
                            onDismissed: (direction) async {
                              await products.doc(doc.id).delete();
                            },
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditProductDialog(
                                    docId: doc.id,
                                    initialProductName: doc['nama_produk'],
                                    initialPrice: doc['harga'].toString(),
                                    initialStock: doc['stok'].toString(),
                                    onUpdate: (newProductName, newPrice,
                                        newStock) async {
                                      await products.doc(doc.id).update({
                                        'nama_produk': newProductName,
                                        'harga': int.tryParse(newPrice) ?? 0,
                                        'stok': int.tryParse(newStock) ?? 0,
                                      });
                                    },
                                  ),
                                );
                              },
                              child: ItemCard(
                                doc['nama_produk'],
                                doc['harga'],
                                doc['stok'],
                              ),
                            ),
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('Tidak ada Data'));
                    }
                  },
                ),
              ),
              SizedBox(height: 150),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 120, 190, 252),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(-5, 0),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              width: double.infinity,
              height: 180,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: productNameController,
                          decoration: InputDecoration(hintText: "Nama Produk"),
                        ),
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: priceController,
                          decoration: InputDecoration(hintText: "Harga"),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: stockController,
                          decoration: InputDecoration(hintText: "Stok"),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 130,
                    width: 130,
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        primary: Colors.blue[900],
                      ),
                      child: Text(
                        'Add Data',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final String productName =
                            productNameController.text.trim();
                        final String price = priceController.text.trim();
                        final String stock = stockController.text.trim();

                        if (productName.isNotEmpty &&
                            price.isNotEmpty &&
                            stock.isNotEmpty) {
                          try {
                            await products.add({
                              'nama_produk': productName,
                              'harga': int.tryParse(price) ?? 0,
                              'stok': int.tryParse(stock) ?? 0,
                            });

                            productNameController.clear();
                            priceController.clear();
                            stockController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Data berhasil ditambahkan ke Firestore!',
                                ),
                              ),
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menambahkan data: $error'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tolong isi data dengan benar.'),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String productName;
  final int price;
  final int stock;

  const ItemCard(this.productName, this.price, this.stock);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga: $price'),
            Text('Stok: $stock'),
          ],
        ),
      ),
    );
  }
}

class EditProductDialog extends StatefulWidget {
  final String docId;
  final String initialProductName;
  final String initialPrice;
  final String initialStock;
  final Function(String, String, String) onUpdate;

  const EditProductDialog({
    required this.docId,
    required this.initialProductName,
    required this.initialPrice,
    required this.initialStock,
    required this.onUpdate,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();
    productNameController =
        TextEditingController(text: widget.initialProductName);
    priceController = TextEditingController(text: widget.initialPrice);
    stockController = TextEditingController(text: widget.initialStock);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Produk'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productNameController,
            decoration: InputDecoration(labelText: 'Nama Produk'),
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(labelText: 'Harga'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: stockController,
            decoration: InputDecoration(labelText: 'Stok'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final String newProductName = productNameController.text.trim();
            final String newPrice = priceController.text.trim();
            final String newStock = stockController.text.trim();

            if (newProductName.isNotEmpty &&
                newPrice.isNotEmpty &&
                newStock.isNotEmpty) {
              widget.onUpdate(newProductName, newPrice, newStock);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tolong isi data dengan benar.'),
                ),
              );
            }
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
