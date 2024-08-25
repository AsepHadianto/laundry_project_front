// import 'package:flutter/material.dart';
// import 'package:laundry_project/views/Home/customer_screen.dart';
// import 'package:laundry_project/widgets/snackbar.dart';
// import '/api_service.dart';

// class AddCustomerPage extends StatefulWidget {
//   @override
//   _AddCustomerPageState createState() => _AddCustomerPageState();
// }

// class _AddCustomerPageState extends State<AddCustomerPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final ApiService _apiService = ApiService();

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       String responseMessage = await _apiService.addCustomer(
//         _nameController.text,
//         int.parse(_phoneController.text),
//         _addressController.text,
//       );
//       print('Customer berhasil ditambahkan: $responseMessage');
//       showCustomSnackBar(context, 'Customer berhasil ditambahkan');
//       if (responseMessage.contains('berhasil')) {
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => CustomerListPage()));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tambah Pelanggan'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Nama'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Masukkan nama pelanggan';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(labelText: 'Telepon'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Masukkan nomor telepon';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: InputDecoration(labelText: 'Alamat'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Masukkan alamat';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Tambah'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:laundry_project/views/Home/customer_screen.dart';
import '/api_service.dart';

class AddCustomerPage extends StatefulWidget {
  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _apiService.addCustomer(
          _nameController.text,
          int.parse(_phoneController.text),
          _addressController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer added successfully')),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CustomerListPage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add customer: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama pelanggan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor telepon';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan alamat';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
