import 'package:flutter/material.dart';
import '../../models/role_model.dart';
import '/widgets/alert_dialog.dart';
import '/api_service.dart';
import '/models/user_model.dart';
import 'add_user_screen.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _userListFuture;
  final _apiService = ApiService();
  final _searchController = TextEditingController();
  List<User> _filteredUserList = [];
  // List<Role> _roles = [];

  Future<void> _fetchUsers() async {
    final userList = await _apiService.getUsers();
    setState(() {
      _filteredUserList = userList;
      _userListFuture = Future.value(userList);
    });
  }

  // Future<void> _fetchRoles() async {
  //   try {
  //     final roles = await _apiService.getRoles();
  //     setState(() {
  //       _roles = roles;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load roles: $e')),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _userListFuture = _apiService.getUsers();
    // _fetchRoles();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _userListFuture.then((userList) {
        _filteredUserList = userList.where((user) {
          final query = _searchController.text.toLowerCase();
          final name = user.name.toLowerCase();
          return name.contains(query);
        }).toList();
      });
    });
  }

  Future<void> _addUser() async {
    final result = await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AddUserPage()));

    if (result == true) {
      _fetchUsers();
    }
  }

  Future<void> _editUser(User user) async {
    List<Role> _roles = await _apiService.getRoles();

    showDialog(
      context: context,
      builder: (context) {
        final _nameController = TextEditingController(text: user.name);
        final _usernameController = TextEditingController(text: user.username);
        final _phoneController =
            TextEditingController(text: user.phone.toString());
        final _emailController = TextEditingController(text: user.email);
        final _passwordController = TextEditingController();
        int? _selectedRoleId = user.roleId;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Pengguna'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Telepon'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
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
                    await _apiService.editUser(
                      user.id,
                      _nameController.text,
                      _usernameController.text,
                      int.parse(_phoneController.text),
                      _emailController.text,
                      _passwordController.text,
                      _selectedRoleId!,
                    );
                    _fetchUsers();
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

  void _deleteUser(int id) async {
    await _apiService.deleteUser(id);
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Pengguna'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addUser,
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
            child: FutureBuilder<List<User>>(
              future: _userListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found'));
                } else {
                  if (_filteredUserList.isEmpty &&
                      _searchController.text.isEmpty) {
                    _filteredUserList = snapshot.data!;
                  }
                  return ListView.builder(
                    itemCount: _filteredUserList.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUserList[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(
                            'Username: ${user.username}\nPhone: ${user.phone}\nEmail: ${user.email}'),
                        isThreeLine: true,
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _editUser(user),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => showCustomAlertDialog(
                                      context: context,
                                      message:
                                          'Apakah kamu yakin ingin menghapus pengguna?',
                                      confirmText: 'Hapus',
                                      onConfirm: () {
                                        _deleteUser(user.id);
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
