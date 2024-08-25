import 'package:flutter/material.dart';
import '/widgets/alert_dialog.dart';
import '/models/product_model.dart';
import '/models/category_model.dart';
import 'add_product_screen.dart';
import '/api_service.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> _produkListFuture;
  final _apiService = ApiService();
  final _searchController = TextEditingController();
  List<Product> _filteredProdukList = [];

  Future<void> _fetchProducts() async {
    final produkList = await _apiService.getProducts();
    setState(() {
      _filteredProdukList = produkList;
      _produkListFuture = Future.value(produkList);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _produkListFuture = _apiService.getProducts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // Update filtered list based on search query
      _produkListFuture.then((produkList) {
        _filteredProdukList = produkList.where((produk) {
          final query = _searchController.text.toLowerCase();
          final namaProduk = produk.namaProduk.toLowerCase();
          return namaProduk.contains(query);
        }).toList();
      });
    });
  }

  Future<void> _addProduct() async {
    final result = await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AddProductPage()));

    if (result == true) {
      // Refresh the product list after adding a new product
      _fetchProducts();
    }
  }

  Future<void> _editProduct(Product produk) async {
    List<Category> _categories = await _apiService.getCategories();

    showDialog(
      context: context,
      builder: (context) {
        final _nameController = TextEditingController(text: produk.namaProduk);
        final _priceController =
            TextEditingController(text: produk.harga.toString());
        final _stockController =
            TextEditingController(text: produk.stok.toString());
        int? _selectedCategoryId = produk.categoryId;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Produk'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama Produk'),
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _stockController,
                    decoration: InputDecoration(labelText: 'Stok'),
                    keyboardType: TextInputType.number,
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
                      _selectedCategoryId = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih kategori';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    await _apiService.editProduct(
                      produk.id,
                      _nameController.text,
                      int.parse(_priceController.text),
                      int.parse(_stockController.text),
                      _selectedCategoryId!,
                    );
                    _fetchProducts();
                    Navigator.of(context).pop();
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteProduct(int id) async {
    await _apiService.deleteProduct(id);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addProduct,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _produkListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found'));
                } else {
                  // Initialize filtered list with all products
                  if (_filteredProdukList.isEmpty &&
                      _searchController.text.isEmpty) {
                    _filteredProdukList = snapshot.data!;
                  }
                  return ListView.builder(
                    itemCount: _filteredProdukList.length,
                    itemBuilder: (context, index) {
                      final produk = _filteredProdukList[index];
                      return ListTile(
                        // leading: Icon(Icons.image),
                        title:
                            Text("${produk.namaProduk} (stok: ${produk.stok})"),
                        subtitle: Text("Rp${produk.harga}"),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _editProduct(produk),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => showCustomAlertDialog(
                                      context: context,
                                      message:
                                          'Apakah kamu yakin ingin menghapus produk?',
                                      confirmText: 'Hapus',
                                      onConfirm: () {
                                        _deleteProduct(produk.id);
                                        Navigator.of(context).pop();
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    )),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
