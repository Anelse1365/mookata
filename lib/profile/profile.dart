import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:mookata/Auth/login.dart'; // Import your login page file

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (userDoc.exists) {
      setState(() {
        _userData = userDoc.data();
      });
    }
  }

  void _updateName() async {
    TextEditingController _nameController = TextEditingController();
    _nameController.text = _userData!['name'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  // Update name in Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_uid)
                      .update({'name': newName});
                  // Update name in UI
                  setState(() {
                    _userData!['name'] = newName;
                  });
                  Navigator.pop(context); // Close dialog
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updatePhoneNumber() async {
    TextEditingController _phoneNumberController = TextEditingController();
    _phoneNumberController.text = _userData!['phone'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Phone Number'),
          content: TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'Enter new phone number'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newPhoneNumber = _phoneNumberController.text.trim();
                if (newPhoneNumber.isNotEmpty) {
                  // Update phone number in Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_uid)
                      .update({'phone': newPhoneNumber});
                  // Update phone number in UI
                  setState(() {
                    _userData!['phone'] = newPhoneNumber;
                  });
                  Navigator.pop(context); // Close dialog
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _userData == null ? CircularProgressIndicator() : _buildProfile(),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://example.com/background.jpg'), // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.teal,
                          child: Text(
                            _userData!['name'][0],
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '      ${_userData!['name']}',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _updateName();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.teal),
                          title: Text(_userData!['phone']),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _updatePhoneNumber();
                            },
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading:
                              Icon(Icons.calendar_today, color: Colors.teal),
                          title: Text(_userData!['dateOfBirth'] == null
                              ? 'N/A'
                              : DateFormat('dd/MM/yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      _userData!['dateOfBirth']))),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.teal),
                          title: Text(_userData!['gender'] ?? 'N/A'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _logout,
            child: Text('Logout'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
