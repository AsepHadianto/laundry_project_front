import 'package:flutter/material.dart';
import '/widgets/alert_dialog.dart';
import '/models/service_model.dart';
import '/models/category_model.dart';
import '/views/Home/add_service_screen.dart';
import '/api_service.dart';

class ServiceListPage extends StatefulWidget {
  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  late Future<List<Service>> _serviceListFuture;
  final _apiService = ApiService();
  final _searchController = TextEditingController();
  List<Service> _filteredServiceList = [];

  Future<void> _fetchServices() async {
    final ServiceList = await _apiService.getServices();
    setState(() {
      _filteredServiceList = ServiceList;
      _serviceListFuture = Future.value(ServiceList);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _serviceListFuture = _apiService.getServices();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _serviceListFuture.then((serviceList) {
        _filteredServiceList = serviceList.where((service) {
          final query = _searchController.text.toLowerCase();
          final name = service.namaLayanan.toLowerCase();
          return name.contains(query);
        }).toList();
      });
    });
  }

  Future<void> _addService() async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddServicePage()),
    );

    if (result == true) {
      _fetchServices();
    }
  }

  Future<void> _editService(Service service) async {
    List<Category> _categories = await _apiService.getCategories();

    showDialog(
      context: context,
      builder: (context) {
        final _nameController =
            TextEditingController(text: service.namaLayanan);
        final _priceController =
            TextEditingController(text: service.harga.toString());
        int? _selectedCategoryId = service.categoryId;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Layanan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama Layanan'),
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Harga Layanan'),
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
                    await _apiService.editService(
                      service.id,
                      _nameController.text,
                      int.parse(_priceController.text),
                      _selectedCategoryId!,
                    );
                    _fetchServices();
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

  void _deleteService(int id) async {
    await _apiService.deleteService(id);
    _fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Layanan'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addService,
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
            child: FutureBuilder<List<Service>>(
              future: _serviceListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No services found'));
                } else {
                  if (_filteredServiceList.isEmpty &&
                      _searchController.text.isEmpty) {
                    _filteredServiceList = snapshot.data!;
                  }
                  return ListView.builder(
                    itemCount: _filteredServiceList.length,
                    itemBuilder: (context, index) {
                      final service = _filteredServiceList[index];
                      return ListTile(
                        title: Text(service.namaLayanan),
                        subtitle: Text("Rp${service.harga}"),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _editService(service),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => showCustomAlertDialog(
                                      context: context,
                                      message:
                                          'Apakah kamu yakin ingin menghapus layanan?',
                                      confirmText: 'Hapus',
                                      onConfirm: () {
                                        _deleteService(service.id);
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
