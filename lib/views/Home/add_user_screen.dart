import 'package:flutter/material.dart';
import '../../models/role_model.dart';
import '/api_service.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Role> _roles = [];
  int? _selectedRoleId;

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    try {
      final roles = await _apiService.getRoles();
      setState(() {
        _roles = roles;
      });
    } catch (e) {
      print('Failed to load roles: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRoleId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a role')),
        );
        return;
      }
      try {
        await _apiService.addUser(
          _nameController.text,
          _usernameController.text,
          int.parse(_phoneController.text),
          _emailController.text,
          _passwordController.text,
          _selectedRoleId!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User added successfully')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengguna'),
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
                    return 'Masukkan nama pengguna';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telepon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor telepon';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Pilih Peran'),
                value: _selectedRoleId,
                items: _roles.map((role) {
                  return DropdownMenuItem<int>(
                    value: role.id,
                    child: Text(role.roleName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoleId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih peran';
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
