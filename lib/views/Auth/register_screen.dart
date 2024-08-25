// import 'package:flutter/material.dart';
// import 'package:laundry_project/api_service.dart';

// class Register extends StatefulWidget {
//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final _nameController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _role_idController = TextEditingController();
//   final ApiService _apiService = ApiService();

//   Future<void> _register() async {
//     try {
//       final result = await _apiService.register(
//           _nameController.text,
//           _usernameController.text,
//           _phoneController.text,
//           _emailController.text,
//           _passwordController.text,
//           _role_idController.text);
//       print('Register successful: $result');
//     } catch (e) {
//       print('Register failed: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Register')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(labelText: 'Phone'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _role_idController,
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             ElevatedButton(
//               onPressed: _register,
//               child: Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // class Register extends StatefulWidget {
// //   @override
// //   State<Register> createState() => _RegisterState();
// // }

// // class _RegisterState extends State<Register> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(
// //               "Create Account",
// //               style: TextStyle(color: Colors.white, fontSize: 24),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               "Register to get started!",
// //               style: TextStyle(color: Colors.grey),
// //             ),
// //             SizedBox(height: 32),
// //             TextField(
// //               style: TextStyle(color: Colors.white),
// //               decoration: InputDecoration(
// //                 labelText: "Name",
// //                 labelStyle: TextStyle(color: Colors.white),
// //                 hintText: "Enter your name",
// //                 hintStyle: TextStyle(color: Colors.grey),
// //                 enabledBorder: UnderlineInputBorder(
// //                   borderSide: BorderSide(color: Colors.grey),
// //                 ),
// //                 focusedBorder: UnderlineInputBorder(
// //                   borderSide: BorderSide(color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             TextField(
// //               style: TextStyle(color: Colors.white),
// //               decoration: InputDecoration(
// //                 labelText: "Email",
// //                 labelStyle: TextStyle(color: Colors.white),
// //                 hintText: "Enter your email",
// //                 hintStyle: TextStyle(color: Colors.grey),
// //                 enabledBorder: UnderlineInputBorder(
// //                   borderSide: BorderSide(color: Colors.grey),
// //                 ),
// //                 focusedBorder: UnderlineInputBorder(
// //                   borderSide: BorderSide(color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             TextField(
// //               obscureText: true,
// //               style: TextStyle(color: Colors.white),
// //               decoration: InputDecoration(
// //                 labelText: "Password",
// //                 labelStyle: TextStyle(color: Colors.white),
// //                 hintText: "Enter your password",
// //                 hintStyle: TextStyle(color: Colors.grey),
// //                 enabledBorder: UnderlineInputBorder(
// //                   borderSide: BorderSide(color: Colors.grey),
// //                 ),
// //                 focusedBorder: UnderlineInputBorder(
// //                   borderSide: BorderSide(color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 8),
// //             Align(
// //               alignment: Alignment.centerLeft,
// //               child: Text(
// //                 "Must be at least 8 characters.",
// //                 style: TextStyle(color: Colors.grey, fontSize: 12),
// //               ),
// //             ),
// //             SizedBox(height: 32),
// //             ElevatedButton(
// //               onPressed: () {},
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.teal, // Background color
// //                 padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
// //               ),
// //               child: Text(
// //                 "Register",
// //                 style: TextStyle(color: Colors.white),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text("Already have an account?",
// //                     style: TextStyle(color: Colors.blue)),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.pushNamed(context, '/login');
// //                   },
// //                   child:
// //                       Text("Login here", style: TextStyle(color: Colors.blue)),
// //                 ),
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
