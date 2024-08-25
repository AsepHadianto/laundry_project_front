import 'package:flutter/material.dart';
import '/models/category_model.dart';
import '/views/Home/product_list_screen.dart';
import '/widgets/snackbar.dart';
import '/api_service.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
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
      String responseMessage = await _apiService.addProduct(
        _nameController.text,
        int.parse(_priceController.text),
        _selectedCategoryId!,
        int.parse(_stockController.text),
      );

      print('Produk berhasil ditambahkan: $responseMessage');
      showCustomSnackBar(context, 'Produk berhasil ditambahkan');
      if (responseMessage.contains('berhasil')) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ProductListPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama produk';
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
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah stok';
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
                child: Text('Tambah Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
