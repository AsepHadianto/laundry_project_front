// import 'package:flutter/material.dart';
// import '/api_service.dart';
// import '/models/customer_model.dart';
// import 'add_customer_screen.dart';

// class CustomerListPage extends StatefulWidget {
//   @override
//   _CustomerListPageState createState() => _CustomerListPageState();
// }

// class _CustomerListPageState extends State<CustomerListPage> {
//   late Future<List<Customer>> _customersListFuture;
//   final ApiService _apiService = ApiService();
//   List<Customer> _customers = [];

//   @override
//   void initState() {
//     super.initState();
//     _customersListFuture = _apiService.getCustomers();
//     _fetchCustomers();
//   }
//   Future<void> _fetchProducts() async {
//     final produkList = await _apiService.getProducts();
//     setState(() {
//       _filteredProdukList = produkList;
//       _produkListFuture = Future.value(produkList);
//     });
//   }

//   Future<void> _fetchCustomers() async {
//        final customers = await _apiService.getCustomers();
//     setState(() {
//       _customers = customers;
//     });
//     }
//   }

//   void _addCustomer() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AddCustomerPage()),
//     );

//     if (result == true) {
//       _fetchCustomers();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Daftar Pelanggan'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: _addCustomer,
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Customer>>(
//         future: _customerListFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No customers found'));
//           } else {
//             return ListView.builder(
//               itemCount: _customers.length,
//               itemBuilder: (context, index) {
//                 final customer = _customers[index];
//                 return ListTile(
//                   leading: Icon(Icons.person),
//                   title: Text(customer.name),
//                   subtitle: Text(
//                       'Phone: ${customer.phone}\nAddress: ${customer.address}'),
//                   isThreeLine: true,
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '/widgets/alert_dialog.dart';
import '/api_service.dart';
import '/models/customer_model.dart';
import 'add_customer_screen.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late Future<List<Customer>> _customerListFuture;
  final _apiService = ApiService();
  final _searchController = TextEditingController();
  List<Customer> _filteredCustomerList = [];

  Future<void> _fetchCustomers() async {
    final customerList = await _apiService.getCustomers();
    setState(() {
      _filteredCustomerList = customerList;
      _customerListFuture = Future.value(customerList);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _customerListFuture = _apiService.getCustomers();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _customerListFuture.then((customerList) {
        _filteredCustomerList = customerList.where((customer) {
          final query = _searchController.text.toLowerCase();
          final name = customer.name.toLowerCase();
          return name.contains(query);
        }).toList();
      });
    });
  }

  Future<void> _addCustomer() async {
    final result = await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AddCustomerPage()));

    if (result == true) {
      _fetchCustomers();
    }
  }

  Future<void> _editCustomer(Customer customer) async {
    final _nameController = TextEditingController(text: customer.name);
    final _phoneController =
        TextEditingController(text: customer.phone.toString());
    final _addressController = TextEditingController(text: customer.address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telepon'),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Alamat'),
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
                await _apiService.editCustomer(
                  customer.id,
                  _nameController.text,
                  int.parse(_phoneController.text),
                  _addressController.text,
                );
                _fetchCustomers();
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCustomer(int id) async {
    await _apiService.deleteCustomer(id);
    _fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Pelanggan'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addCustomer,
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
            child: FutureBuilder<List<Customer>>(
              future: _customerListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No customers found'));
                } else {
                  if (_filteredCustomerList.isEmpty &&
                      _searchController.text.isEmpty) {
                    _filteredCustomerList = snapshot.data!;
                  }
                  return ListView.builder(
                    itemCount: _filteredCustomerList.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomerList[index];
                      return ListTile(
                        title: Text(customer.name),
                        subtitle: Text(
                            'Phone: ${customer.phone}\nAddress: ${customer.address}'),
                        isThreeLine: true,
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _editCustomer(customer),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => showCustomAlertDialog(
                                      context: context,
                                      message:
                                          'Apakah kamu yakin ingin menghapus pelanggan?',
                                      confirmText: 'Hapus',
                                      onConfirm: () {
                                        _deleteCustomer(customer.id);
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
