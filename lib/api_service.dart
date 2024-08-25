import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/product_sales_detail.dart';
import 'models/category_model.dart';
import 'models/customer_model.dart';
import 'models/product_model.dart';
import 'models/role_model.dart';
import 'models/sales_record_model.dart';
import 'models/service_model.dart';
import 'models/user_model.dart';

class ApiService {
  final String baseUrl = "http://192.168.1.7:8000/api";
  // final String baseUrl = "http://13.215.254.101/api";

  //untuk login
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return token;
    } else {
      throw Exception('Gagal untuk masuk');
    }
  }

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Role>> getRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/roles'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((role) => Role.fromJson(role)).toList();
    } else {
      throw Exception('Failed to load roles');
    }
  }

  Future<String> addUser(String name, String username, int phone, String email,
      String password, int roleId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
        'role_id': roleId,
      }),
    );

    if (response.statusCode == 201) {
      return 'Staff berhasil ditambahkan';
    } else {
      return 'Staff gagal ditambahkan: ${response.reasonPhrase}';
    }
  }

  Future<String> editUser(int id, String name, String username, int phone,
      String email, String password, int roleId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
        'role_id': roleId,
      }),
    );

    if (response.statusCode == 201) {
      return 'Staff berhasil diubah';
    } else {
      return 'Staff gagal diubah: ${response.reasonPhrase}';
    }
  }

  Future<String> deleteUser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return 'Staff berhasil dihapus';
    } else {
      return 'Staff gagal dihapus: ${response.reasonPhrase}';
    }
  }

  //untuk mendapatkan daftar produk
  Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  //untuk tambah produk
  Future<String> addProduct(
      String name, int price, int category_id, int stock) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'category_id': category_id,
        'stock': stock
      }),
    );

    if (response.statusCode == 201) {
      return 'Produk berhasil ditambahkan';
    } else {
      return 'Produk gagal ditambahkan: ${response.reasonPhrase}';
    }
  }

  // Fungsi untuk mengedit produk
  Future<String> editProduct(
      int id, String name, int price, int stock, int categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'stock': stock,
        'category_id': categoryId,
      }),
    );

    if (response.statusCode == 200) {
      return 'Produk berhasil diubah';
    } else {
      return 'Produk gagal diubah: ${response.reasonPhrase}';
    }
  }

  // Fungsi untuk menghapus produk
  Future<String> deleteProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return 'Produk berhasil dihapus';
    } else {
      return 'Produk gagal dihapus: ${response.reasonPhrase}';
    }
  }

  //untuk mendapatkan daftar layanan
  Future<List<Service>> getServices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/services'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => Service.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  //untuk tambah layanan
  Future<String> addService(String name, int price, category_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/services'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'category_id': category_id,
      }),
    );

    if (response.statusCode == 201) {
      return 'Layanan berhasil ditambahkan';
    } else {
      return 'Layanan gagal ditambahkan: ${response.reasonPhrase}';
    }
  }

  // Fungsi untuk mengedit produk
  Future<String> editService(
      int id, String name, int price, int category_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/services/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'category_id': category_id,
      }),
    );

    if (response.statusCode == 200) {
      return 'Layanan berhasil diubah';
    } else {
      return 'Layanan gagal diubah: ${response.reasonPhrase}';
    }
  }

  // Fungsi untuk menghapus produk
  Future<String> deleteService(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/services/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return 'Layanan berhasil dihapus';
    } else {
      return 'Layanan gagal dihapus: ${response.reasonPhrase}';
    }
  }

  //untuk mendapatkan daftar kategori
  Future<List<Category>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  //untuk tambah kategori
  Future<String> addCategory(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return 'Kategori berhasil ditambahkan';
    } else {
      return 'Kategori gagal ditambahkan: ${response.reasonPhrase}';
    }
  }

  //untuk edit kategori
  Future<String> editCategory(int id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200) {
      return 'Kategori berhasil diubah';
    } else {
      return 'Kategori gagal diubah: ${response.reasonPhrase}';
    }
  }

  //untuk hapus kategori
  Future<String> deleteCategory(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return 'Kategori berhasil dihapus';
    } else {
      return 'Kategori gagal dihapus: ${response.reasonPhrase}';
    }
  }

  //untuk mendapatkan customer
  Future<List<Customer>> getCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Customer.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<String> addCustomer(String name, int phone, String address) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'address': address,
      }),
    );

    if (response.statusCode == 201) {
      return 'Customer berhasil ditambahkan';
    } else {
      return 'Customer gagal ditambahkan: ${response.reasonPhrase}';
    }
  }

  Future<String> editCustomer(
      int id, String name, int phone, String address) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/customers/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'address': address,
      }),
    );

    if (response.statusCode == 200) {
      return 'Pelanggan berhasil diubah';
    } else {
      return 'Pelanggan gagal diubah: ${response.reasonPhrase}';
    }
  }

  Future<String> deleteCustomer(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http
        .delete(Uri.parse('$baseUrl/customers/$id'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return 'Kategori berhasil dihapus';
    } else {
      return 'Kategori gagal dihapus: ${response.reasonPhrase}';
    }
  }

  // Fungsi untuk menambah transaksi
  Future<void> addSalesRecord(
    int userId,
    int customerId,
    List<Map<String, dynamic>> productSalesDetails,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }
    final DateTime date = DateTime.now();
    double totalAmount =
        productSalesDetails.fold(0, (sum, item) => sum + item['subtotal']);

    final salesRecord = {
      'user_id': userId,
      'customer_id': customerId,
      'date': date.toString(),
      'total_amount': totalAmount,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/sales_records'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(salesRecord),
    );

    if (response.statusCode == 201) {
      final salesRecordId = json.decode(response.body)['id'];
      for (final detail in productSalesDetails) {
        final productId = detail['product_id'];
        final quantity = detail['quantity'];
        final subtotal = detail['subtotal'];
        await http.post(
          Uri.parse('$baseUrl/product_sales_details'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'sales_record_id': salesRecordId,
            'product_id': productId,
            'quantity': quantity,
            'subtotal': subtotal,
          }),
        );
        if (response.statusCode != 201) {
          throw Exception('Failed to create product sales detail');
        }
        ;
      }
    } else {
      throw Exception('Failed to create sales record');
    }
  }
  // Future<String> addSalesRecord(
  //     int userId, int customerId, String date, double totalAmount) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('token');

  //   if (token == null) {
  //     throw Exception('No token found. Please login first.');
  //   }
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/sales_records'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({
  //       'user_id': userId,
  //       'customer_id': customerId,
  //       'date': date.toIso8601String(),
  //       'total_amount': totalAmount,
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     final salesRecordId = json.decode(response.body)['id'];
  //     for (final detail in product) {
  //       detail['sales_record_id'] = salesRecordId;
  //       await http.post(
  //         Uri.parse('$baseUrl/product_sales_details'),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode(detail),
  //       );
  //     }
  //     return 'Transaksi berhasil ditambahkan';
  //   } else {
  //     return 'Transaksi gagal ditambahkan: ${response.reasonPhrase}';
  //   }
  // }

  // Fungsi untuk menambah detail penjualan produk
  Future<String> addProductSalesDetail(
      int salesRecordId, int productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/product_sales_details'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'sales_record_id': salesRecordId,
        'product_id': productId,
        'quantity': quantity,
        'subtotal': quantity,
      }),
    );

    if (response.statusCode == 201) {
      return 'Detail penjualan produk berhasil ditambahkan';
    } else {
      return 'Detail penjualan produk gagal ditambahkan: ${response.reasonPhrase}';
    }
  }

  // Fungsi untuk menambah detail penjualan layanan
  Future<String> addServiceSalesDetail(
      int salesRecordId, int serviceId, int quantity, double price) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/service_sales_details'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'sales_record_id': salesRecordId,
        'service_id': serviceId,
        'quantity': quantity,
        'price': price,
        'subtotal': quantity * price,
      }),
    );

    if (response.statusCode == 201) {
      return 'Detail penjualan layanan berhasil ditambahkan';
    } else {
      return 'Detail penjualan layanan gagal ditambahkan: ${response.reasonPhrase}';
    }
  }

  // Fungsi untuk mengambil laporan penjualan
  Future<List<SalesRecord>> getSalesRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/sales_records'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((record) => SalesRecord.fromJson(record)).toList();
    } else {
      throw Exception('Failed to load sales records');
    }
  }
}
