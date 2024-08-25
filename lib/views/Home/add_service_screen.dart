import 'package:flutter/material.dart';
import '/views/Home/service_list_screen.dart';
import '/widgets/snackbar.dart';
import '/models/category_model.dart';
import '/api_service.dart';

class AddServicePage extends StatefulWidget {
  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int? _selectedCategoryId;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _apiService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String responseMessage = await _apiService.addService(
        _nameController.text,
        int.parse(_priceController.text),
        _selectedCategoryId!,
      );

      print('Layanan berhasil ditambahkan: $responseMessage');
      showCustomSnackBar(context, 'Layanan berhasil ditambahkan');
      if (responseMessage.contains('berhasil')) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ServiceListPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Layanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Layanan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama layanan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Kategori'),
                value: _selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih kategori';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Tambah Layanan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
