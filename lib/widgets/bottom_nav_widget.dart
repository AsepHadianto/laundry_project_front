import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:laundry_project/views/Home/add_sales_transaction.dart';
import 'package:laundry_project/views/Home/home_screen.dart';
import 'package:laundry_project/views/MyProfile/myprofile_screen.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Bottom Navigation Bar'),
//       ),
//       body: Center(
//         child: Text('Selected Index: $_selectedIndex'),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 18.0,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () => _onItemTapped(0),
//             ),
//             // IconButton(
//             //   icon: Icon(Icons.schedule),
//             //   onPressed: () => _onItemTapped(1),
//             // ),
//             // SizedBox(width: 48.0), // The dummy child for spacing
//             // IconButton(
//             //   icon: Icon(Icons.message),
//             //   onPressed: () => _onItemTapped(2),
//             // ),
//             IconButton(
//               icon: Icon(Icons.settings),
//               onPressed: () => _onItemTapped(1),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle add action
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final _pageOptions = [
    HomePage(),
    // OffersPage(),
    // SearchPage(),
    // FlightsPage(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pageOptions[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, size: 25),
          // Icon(Icons.add, size: 35),
          Icon(Icons.person, size: 25),
          // Icon(Icons.search, size: 25),
        ],
        color: Colors.blue.shade900,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddSalesRecordPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
