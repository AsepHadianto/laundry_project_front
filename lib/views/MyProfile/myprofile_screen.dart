import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Add edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            _buildInfoItem('Name', 'guntur s'),
            _buildInfoItem('Role user', 'Owner'),
            _buildInfoItem('Email', 'guntur13@gmail.com'),
            _buildInfoItem('Phone', '+628129581835'),
            _buildInfoItem('Address', 'null'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                // Add logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 18)),
          Divider(),
        ],
      ),
    );
  }
}
