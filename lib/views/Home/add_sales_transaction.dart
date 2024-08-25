import 'package:flutter/material.dart';
import '/api_service.dart';
import '/models/customer_model.dart';
import '/models/product_model.dart';
// import '/models/service_model.dart';
// import '../../models/product_sales_detail.dart';
// import '../../models/service_sales_detail.dart';
// import '/models/sales_record_model.dart';

class AddSalesRecordPage extends StatefulWidget {
  @override
  _AddSalesRecordPageState createState() => _AddSalesRecordPageState();
}

class _AddSalesRecordPageState extends State<AddSalesRecordPage> {
  final _apiService = ApiService();
  int? _selectedCustomerId;
  List<Customer> _customers = [];
  List<Product> _products = [];
  // List<Service> _services = [];
  String productSearch = '';
  String serviceSearch = '';
  Map<int, int> _productQuantities = {};
  // final _productQuantity = TextEditingController();
  // final _serviceQuantity = TextEditingController();
  // final _productController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final customers = await _apiService.getCustomers();
      final products = await _apiService.getProducts();
      // final services = await _apiService.getServices();
      setState(() {
        _products = products;
        _customers = customers;
        // _services = services;
      });
    } catch (e) {
      // Handle error
      print('Failed to load data: $e');
    }
  }

  void _incrementQuantity(int productId) {
    setState(() {
      _productQuantities[productId] = (_productQuantities[productId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(int productId) {
    setState(() {
      if ((_productQuantities[productId] ?? 0) > 0) {
        _productQuantities[productId] =
            (_productQuantities[productId] ?? 0) - 1;
      }
    });
  }

  void _submitSalesRecord() async {
    final userId = 2; // Obtain the logged-in user ID dynamically
    final int customerId = _selectedCustomerId!;
    final List<Map<String, dynamic>> productSalesDetails = [];

    _productQuantities.forEach((productId, quantity) {
      if (quantity > 0) {
        final product = _products.firstWhere((p) => p.id == productId);
        final double subtotal = quantity * product.harga;
        productSalesDetails.add({
          'product_id': productId,
          'quantity': quantity,
          'subtotal': subtotal,
        });
      }
    });

    try {
      await _apiService.addSalesRecord(userId, customerId, productSalesDetails);
      Navigator.pushNamed(context, '/nav');
    } catch (e) {
      // Handle error
      print('Failed to submit sales record: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ExpansionTile(
              //   title: Text('Customer'),
              //   children: _customers.isEmpty
              //       ? [Center(child: CircularProgressIndicator())]
              //       : _customers.map((customer) {
              //           return ListTile(
              //             title: Text(customer.name),
              //             onTap: () {
              //               setState(() {
              //                 _selectedCustomerId = customer.id;
              //               });
              //             },
              //           );
              //         }).toList(),
              // ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Pelanggan'),
                value: _selectedCustomerId,
                items: _customers.map((customer) {
                  return DropdownMenuItem<int>(
                    value: customer.id,
                    child: Text(customer.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomerId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih pelanggan';
                  }
                  return null;
                },
              ),
              ExpansionTile(
                title: Text('Produk'),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                      ),
                      onChanged: (value) {
                        setState(() {
                          productSearch = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  ..._products
                      .where((product) => product.namaProduk
                          .toLowerCase()
                          .contains(productSearch))
                      .map((product) => ListTile(
                            title: Text(product.namaProduk),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    _decrementQuantity(product.id);
                                  },
                                ),
                                Text('${_productQuantities[product.id] ?? 0}'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _incrementQuantity(product.id);
                                  },
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitSalesRecord,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




















//   int productQuantity = 1;
//   int serviceQuantity = 1;
//   String productSearch = '';
//   String serviceSearch = '';
//   String selectedCustomer = '';
//   ApiService _apiService = ApiService();

//   List<Customer> customers = [];
//   List<Product> products = [];
//   List<Service> services = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       customers = await _apiService.getCustomers();
//       products = await _apiService.getProducts();
//       services = await _apiService.getServices();
//       setState(() {});
//     } catch (e) {
//       // Handle error
//       print('Error fetching data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tambah Transaksi'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ExpansionTile(
//                 title: Text('Customer'),
//                 children: customers.isEmpty
//                     ? [Center(child: CircularProgressIndicator())]
//                     : customers.map((customer) {
//                         return ListTile(
//                           title: Text(customer.name),
//                           onTap: () {
//                             setState(() {
//                               selectedCustomer = customer.name;
//                             });
//                           },
//                         );
//                       }).toList(),
//               ),
//               ExpansionTile(
//                 title: Text('Produk'),
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Search',
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           productSearch = value.toLowerCase();
//                         });
//                       },
//                     ),
//                   ),
//                   ...products
//                       .where((product) => product.namaProduk
//                           .toLowerCase()
//                           .contains(productSearch))
//                       .map((product) => ListTile(
//                             title: Text(product.namaProduk),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.remove),
//                                   onPressed: () {
//                                     setState(() {
//                                       if (productQuantity > 1)
//                                         productQuantity--;
//                                     });
//                                   },
//                                 ),
//                                 Text('$productQuantity'),
//                                 IconButton(
//                                   icon: Icon(Icons.add),
//                                   onPressed: () {
//                                     setState(() {
//                                       productQuantity++;
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ))
//                       .toList(),
//                 ],
//               ),
//               ExpansionTile(
//                 title: Text('Service'),
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Search',
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           serviceSearch = value.toLowerCase();
//                         });
//                       },
//                     ),
//                   ),
//                   ...services
//                       .where((service) => service.namaLayanan
//                           .toLowerCase()
//                           .contains(serviceSearch))
//                       .map((service) => ListTile(
//                             title: Text(service.namaLayanan),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.remove),
//                                   onPressed: () {
//                                     setState(() {
//                                       if (serviceQuantity > 1)
//                                         serviceQuantity--;
//                                     });
//                                   },
//                                 ),
//                                 Text('$serviceQuantity'),
//                                 IconButton(
//                                   icon: Icon(Icons.add),
//                                   onPressed: () {
//                                     setState(() {
//                                       serviceQuantity++;
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ))
//                       .toList(),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle reset
//                     },
//                     child: Text('Reset'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle create
//                     },
//                     child: Text('Buat'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
