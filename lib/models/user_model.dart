class User {
  final int id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final int roleId;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      phone: json['phone'],
      email: json['email'],
      roleId: json['role_id'],
    );
  }
}
