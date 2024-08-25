import 'package:flutter/material.dart';
import '/views/Auth/login_screen.dart';
import '/views/Home/add_product_screen.dart';
import '/views/Home/home_screen.dart';
import '/views/Home/product_list_screen.dart';
// import '/views/Auth/register_screen.dart';
// import '/views/Home/home_screen.dart';
import '/views/MyProfile/myprofile_screen.dart';
import '/views/SplashScreen.dart';
import '/widgets/bottom_nav_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashScreenPage(),
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        // '/register': (context) => Register(),
        '/nav': (context) => BottomNav(),
        '/profile': (context) => MyProfile(),
        '/product': (context) => ProductListPage(),
        '/addproduct': (context) => AddProductPage(),
      },
    );
  }
}
