import 'package:flutter/material.dart';
import 'product.dart';

class PaymentScreen extends StatefulWidget {
  final List<Product> cartProducts;
  final double totalSale;

  PaymentScreen({required this.cartProducts, required this.totalSale});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double paymentAmount = 0;
  double changeAmount = 0;
  double shippingCost = 0;

  String selectedPackage = 'Reguler'; // Jenis paket default
  String destination = 'Domestic'; // Tujuan lokasi default
  String shippingAddress = ''; // Alamat pengiriman

  final List<String> packageTypes = ['Reguler', 'Hemat', 'Instant'];
  final List<String> destinations = ['Domestic', 'International'];

  void _calculateShippingCost() {
    if (selectedPackage == 'Reguler' && destination == 'Domestic') {
      shippingCost = 5000;
    } else if (selectedPackage == 'Hemat' && destination == 'Domestic') {
      shippingCost = 10000;
    } else if (selectedPackage == 'Instant' && destination == 'Domestic') {
      shippingCost = 15000;
    } else if (selectedPackage == 'Reguler' && destination == 'International') {
      shippingCost = 20000;
    } else if (selectedPackage == 'Hemat' && destination == 'International') {
      shippingCost = 30000;
    } else if (selectedPackage == 'Instant' && destination == 'International') {
      shippingCost = 40000;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.cartProducts.length,
              itemBuilder: (context, index) {
                final product = widget.cartProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Rp ${product.price.toStringAsFixed(0)}'),
                );
              },
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedPackage,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPackage = newValue!;
                          _calculateShippingCost();
                        });
                      },
                      items: packageTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: destination,
                      onChanged: (String? newValue) {
                        setState(() {
                          destination = newValue!;
                          _calculateShippingCost();
                        });
                      },
                      items: destinations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Alamat Pengiriman'),
                onChanged: (value) {
                  setState(() {
                    shippingAddress = value;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Total Belanja'),
              subtitle: Text('Rp ${widget.totalSale.toStringAsFixed(0)}'),
            ),
            Divider(),
            ListTile(
              title: Text('Total Transaksi'),
              subtitle: Text(
                  'Rp ${(widget.totalSale + paymentAmount + shippingCost).toStringAsFixed(0)}'),
            ),
            ListTile(
              title: Text('Jumlah Pembayaran'),
              subtitle: Text('Rp ${paymentAmount.toStringAsFixed(0)}'),
            ),
            ListTile(
              title: Text('Ongkos Kirim'),
              subtitle: Text('Rp ${shippingCost.toStringAsFixed(0)}'),
            ),
            ListTile(
              title: Text('Kembalian'),
              subtitle: Text(
                  'Rp ${(paymentAmount - widget.totalSale - shippingCost).toStringAsFixed(0)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Jumlah Pembayaran'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    paymentAmount = double.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showPaymentReceipt(context);
              },
              child: Text('Bayar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentReceipt(BuildContext context) {
    double change = paymentAmount - widget.totalSale - shippingCost;
    if (change < 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Jumlah pembayaran tidak mencukupi'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nota Pembayaran'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Produk yang Dibeli:'),
                for (var product in widget.cartProducts)
                  Text(
                      '${product.name} - Rp ${product.price.toStringAsFixed(0)}'),
                Divider(),
                ListTile(
                  title: Text('Total Belanja'),
                  subtitle: Text('Rp ${widget.totalSale.toStringAsFixed(0)}'),
                ),
                ListTile(
                  title: Text('Jumlah Pembayaran'),
                  subtitle: Text('Rp ${paymentAmount.toStringAsFixed(0)}'),
                ),
                ListTile(
                  title: Text('Ongkos Kirim'),
                  subtitle: Text('Rp ${shippingCost.toStringAsFixed(0)}'),
                ),
                ListTile(
                  title: Text('Kembalian'),
                  subtitle: Text(
                      'Rp ${(paymentAmount - widget.totalSale - shippingCost).toStringAsFixed(0)}'),
                ),
                Divider(),
                ListTile(
                  title: Text('Alamat Pengiriman'),
                  subtitle: Text('$shippingAddress'),
                ),
              ],
            ),
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
}
