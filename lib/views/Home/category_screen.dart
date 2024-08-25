import 'package:flutter/material.dart';
import '/widgets/alert_dialog.dart';
import '/widgets/snackbar.dart';
import '/models/category_model.dart';
import '/api_service.dart';
import 'dart:developer';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Category>> _categoriesFuture;
  final _apiService = ApiService();
  final _categoryController = TextEditingController();
  List<Category> _categories = [];
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _apiService.getCategories();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _apiService.getCategories();
      log('categories: $categories');
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> _addCategory() async {
    if (_categoryController.text.isNotEmpty) {
      String responseMessage =
          await _apiService.addCategory(_categoryController.text);
      showCustomSnackBar(context, responseMessage);
      _categoryController.clear();
      setState(() {
        _fetchCategories();
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText = 'Masukkan nama kategori';
      });
    }
  }

  Future<void> _editCategory(int id, String newName) async {
    String responseMessage = await _apiService.editCategory(id, newName);
    showCustomSnackBar(context, responseMessage);
    _fetchCategories();
  }

  Future<void> _deleteCategory(int id) async {
    String responseMessage = await _apiService.deleteCategory(id);
    showCustomSnackBar(context, responseMessage);
    _fetchCategories();
  }

  void _showEditDialog(Category category) {
    final _editController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Kategori'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _editCategory(category.id, _editController.text);
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Kelola Kategori Produk/Jasa"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Text("Tambah kategori produk/jasa",
                style: TextStyle(fontSize: 18)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _categoryController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Kategori',
                    errorText: _errorText,
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  onPressed: _addCategory,
                  icon: Icon(Icons.add),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "Daftar Kategori",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No categories found'));
                } else {
                  return ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return ListTile(
                        title: Text(category.name),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _showEditDialog(category),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showCustomAlertDialog(
                                context: context,
                                message:
                                    'Apakah kamu yakin ingin menghapus kategori?',
                                confirmText: 'Hapus',
                                onConfirm: () {
                                  _deleteCategory(category.id);
                                  Navigator.of(context).pop();
                                },
                                onCancel: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
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

// import 'package:flutter/material.dart';

// class Category extends StatelessWidget {
//   const Category({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.orange,
//           automaticallyImplyLeading: true,
//           centerTitle: true,
//           title: Text("Kelola Kategori Produk/Jasa"),
//         ),
//         body: Column(
//           children: [
//             Container(
//               alignment: Alignment.center,
//               child: Text("Tambah kategori produk/jasa"),
//             ),
//             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Container(
//                 child: TextField(
//                   maxLines: 1,
//                 ),
//                 width: 300,
//                 margin: EdgeInsets.symmetric(horizontal: 10),
//               ),
//               Container(
//                 child: IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.add),
//                 ),
//               )
//             ]),
//           ],
//         ));
//   }
// }
