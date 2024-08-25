import 'package:flutter/material.dart';
import '/api_service.dart';
import '/widgets/bottom_nav_widget.dart';
import '/widgets/snackbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _login() async {
    try {
      final result = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );
      print('Login successful: $result');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } catch (e) {
      print('Login failed: $e');
      showCustomSnackBar(
          context, 'Login failed, check your email or password again');
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              'Sign in to continue!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .12),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              // errorText: emailError,
              textInputAction: TextInputAction.next,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              // onChanged: (value) {
              //   setState(() {
              //     email = value;
              //   });
              // },
            ),
            SizedBox(height: screenHeight * .025),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              // errorText: passwordError,
              textInputAction: TextInputAction.next,
              autofocus: true,
              // onSubmitted: (val) => _login(),
              // onChanged: (value) {
              //   setState(() {
              //     password = value;
              //   });
              // },
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     onPressed: () {},
            //     child: const Text(
            //       'Forgot Password?',
            //       style: TextStyle(
            //         color: Colors.black,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: screenHeight * .075,
            ),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Login',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: screenHeight * .15,
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Login Account",
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "Hello, welcome back to our account",
//               style: TextStyle(color: Colors.grey),
//             ),
//             SizedBox(height: 32),
//             TextField(
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: "Name",
//                 labelStyle: TextStyle(color: Colors.white),
//                 hintText: "Enter your name",
//                 hintStyle: TextStyle(color: Colors.grey),
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               obscureText: true,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 labelStyle: TextStyle(color: Colors.white),
//                 hintText: "Create a password",
//                 hintStyle: TextStyle(color: Colors.grey),
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "Forgot password",
//                 style: TextStyle(color: Colors.blue),
//               ),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/nav');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal, // Background color
//                 padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
//               ),
//               child: Text("Login", style: TextStyle(color: Colors.white)),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Don't have an account yet?",
//                     style: TextStyle(color: Colors.blue)),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/register');
//                   },
//                   child: Text("Register here",
//                       style: TextStyle(color: Colors.blue)),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
