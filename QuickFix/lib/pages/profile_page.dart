import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QuickFix/animation/FadeAnimation.dart'; // Import the FadeAnimation class

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out the user
              Navigator.pushReplacementNamed(
                  context, '/login'); // Navigate to login page
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users_profile')
              .where('email', isEqualTo: widget.userEmail)
              .limit(1)
              .get()
              .then((snapshot) => snapshot.docs.first),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No profile data available'));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            String profileImageUrl =
                userData['image'] ?? 'https://via.placeholder.com/150';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FadeAnimation(
                      1.0,
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeAnimation(
                    1.2,
                    ProfileCard(
                      label: 'Name',
                      value: userData['name'] ?? 'No name available',
                      icon: Icons.person,
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeAnimation(
                    1.4,
                    ProfileCard(
                      label: 'Email',
                      value: userData['email'] ?? 'No email available',
                      icon: Icons.email,
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeAnimation(
                    1.6,
                    ProfileCard(
                      label: 'Phone',
                      value: userData['phone'] ?? 'No phone available',
                      icon: Icons.phone,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  ProfileCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
