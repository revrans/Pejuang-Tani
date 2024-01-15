import 'package:flutter/material.dart';
import 'package:reagen_farm/screen/konsumen_page.dart';
import 'package:reagen_farm/screen/product_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_list_view.dart';
import 'product_management.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: Text(
              'Keluar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: [
                  Text(
                    'Selamat Datang di',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Surga Hasil Panen',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'images/whatsapp_icon.jpeg',
                                width: 40.0, // Ubah ukuran ikon WhatsApp
                                height: 40.0, // Ubah ukuran ikon WhatsApp
                              ),
                              SizedBox(
                                  width:
                                      10), // Jarak antara ikon dan teks nomor WhatsApp
                              Text(
                                '081392462540',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Image.asset(
                    'images/company_logo.jpg',
                    width: 400.0,
                    height: 200.0,
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/product_icon.png',
                            width: 80.0,
                            height: 80.0,
                          ),
                          Text('Kelola Produk'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListView(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/shopping_icon.png',
                            width: 80.0,
                            height: 80.0,
                          ),
                          Text('Shopping'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerPage(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/customer_icon.png',
                            width: 80.0,
                            height: 80.0,
                          ),
                          Text('Kelola Konsumen'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductTablePage extends StatelessWidget {
  const ProductTablePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Produk (Tabel Produk)'),
      ),
      body: Center(
        child:
            Text('Ini adalah halaman untuk mengelola produk (tabel produk).'),
      ),
    );
  }
}

class CustomerTablePage extends StatelessWidget {
  const CustomerTablePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Konsumen (Tabel Konsumen)'),
      ),
      body: Center(
        child: Text(
            'Ini adalah halaman untuk mengelola konsumen (tabel konsumen).'),
      ),
    );
  }
}
