import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> customers =
        FirebaseFirestore.instance.collection('customers');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Data Konsumen'),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Column(
            children: [
              //// VIEW DATA HERE
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: customers.snapshots(),
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
                              await customers.doc(doc.id).delete();
                            },
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditCustomerDialog(
                                    docId: doc.id,
                                    initialName: doc['nama'],
                                    initialPhone: doc['telepon'],
                                    initialAddress: doc['alamat'],
                                    onUpdate:
                                        (newName, newPhone, newAddress) async {
                                      await customers.doc(doc.id).update({
                                        'nama': newName,
                                        'telepon': newPhone,
                                        'alamat': newAddress,
                                      });
                                    },
                                  ),
                                );
                              },
                              child: CustomerCard(
                                doc['nama'],
                                doc['telepon'],
                                doc['alamat'],
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
              height: 210,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: nameController,
                          decoration: InputDecoration(hintText: "Nama"),
                        ),
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: phoneController,
                          decoration: InputDecoration(hintText: "Telepon"),
                          keyboardType: TextInputType.phone,
                        ),
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: addressController,
                          decoration: InputDecoration(hintText: "Alamat"),
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
                        'Tambah Data',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final String name = nameController.text.trim();
                        final String phone = phoneController.text.trim();
                        final String address = addressController.text.trim();

                        if (name.isNotEmpty &&
                            phone.isNotEmpty &&
                            address.isNotEmpty) {
                          try {
                            await customers.add({
                              'nama': name,
                              'telepon': phone,
                              'alamat': address,
                            });

                            nameController.clear();
                            phoneController.clear();
                            addressController.clear();

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

class CustomerCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;

  const CustomerCard(this.name, this.phone, this.address);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Telepon: $phone'),
            Text('Alamat: $address'),
          ],
        ),
      ),
    );
  }
}

class EditCustomerDialog extends StatefulWidget {
  final String docId;
  final String initialName;
  final String initialPhone;
  final String initialAddress;
  final Function(String, String, String) onUpdate;

  const EditCustomerDialog({
    required this.docId,
    required this.initialName,
    required this.initialPhone,
    required this.initialAddress,
    required this.onUpdate,
  });

  @override
  _EditCustomerDialogState createState() => _EditCustomerDialogState();
}

class _EditCustomerDialogState extends State<EditCustomerDialog> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    phoneController = TextEditingController(text: widget.initialPhone);
    addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Konsumen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Telepon'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Alamat'),
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
            final String newName = nameController.text.trim();
            final String newPhone = phoneController.text.trim();
            final String newAddress = addressController.text.trim();

            if (newName.isNotEmpty &&
                newPhone.isNotEmpty &&
                newAddress.isNotEmpty) {
              widget.onUpdate(newName, newPhone, newAddress);
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
