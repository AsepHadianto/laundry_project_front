import 'package:flutter/material.dart';
import 'package:laundry_project/views/Home/customer_screen.dart';
import 'package:laundry_project/views/Home/staff_screen.dart';
import '/views/Home/product_list_screen.dart';
import '/views/Home/category_screen.dart';
import '/views/Home/sales_record.dart';
import '/views/Home/service_list_screen.dart';
import '/widgets/appbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(height: 200),
                Expanded(
                  child:
                      ListView(padding: EdgeInsets.only(top: 100), children: [
                    Card(
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage())),
                        title: Text("Kelola Kategori"),
                        leading: Icon(Icons.local_laundry_service),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerListPage())),
                        title: Text("Kelola Pelanggan"),
                        leading: Icon(Icons.local_laundry_service),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserListPage())),
                        title: Text("Kelola Staff"),
                        leading: Icon(Icons.admin_panel_settings),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo Steve',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 130,
              left: 50,
              right: 50,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Omzet Hari Ini : \$1000',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      // SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.delivery_dining),
                                iconSize: 40,
                                color: Colors.orange,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductListPage()),
                                  );
                                },
                              ),
                              // SizedBox(height: 8),
                              Text('Produk'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.local_shipping),
                                iconSize: 40,
                                color: Colors.orange,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ServiceListPage()));
                                },
                              ),
                              // SizedBox(height: 8),
                              Text('Layanan'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.menu_book_rounded),
                                iconSize: 40,
                                color: Colors.orange,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SalesRecordPage()));
                                },
                              ),
                              // SizedBox(height: 8),
                              Text('Laporan'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
