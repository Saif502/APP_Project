import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QuickFix/animation/FadeAnimation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          String? imageUrl;
          if (_imageFile != null) {
            // Upload image to your preferred storage and get the URL
            // Example: imageUrl = await uploadImage(_imageFile);
            // For now, just set imageUrl to a placeholder
            imageUrl = 'assets/upload/_imageFile';
          }

          // Save user data to Firestore
          await _firestore
              .collection('users_profile')
              .doc(userCredential.user!.uid)
              .set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _mobileController.text.trim(),
            'image': imageUrl,
          });

          // Registration successful, navigate to home page
          Navigator.pushReplacementNamed(context, '/login');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _showErrorDialog(context, 'Weak password');
        } else if (e.code == 'email-already-in-use') {
          _showErrorDialog(context, 'Email already in use');
        } else {
          _showErrorDialog(context, 'Error: $e');
        }
      } catch (e) {
        _showErrorDialog(context, 'Unexpected error: $e');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              FadeAnimation(
                1.0,
                Container(
                  width: double.infinity,
                  height: 180,
                  child: Image.asset(
                    'assets/img/signup.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              FadeAnimation(
                1.2,
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : AssetImage('assets/placeholder.png') as ImageProvider,
                    child: _imageFile == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 10),
              FadeAnimation(
                1.4,
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
              ),
              SizedBox(height: 10),
              FadeAnimation(
                1.6,
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.red),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    } else if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              FadeAnimation(
                1.8,
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              FadeAnimation(
                2.0,
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    prefixIcon: Icon(Icons.phone, color: Colors.orange),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter mobile number';
                    } else if (value.length != 11) {
                      return 'Mobile number must be 11 digits';
                    } else if (!isNumeric(value)) {
                      return 'Mobile number must only contain digits';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                2.2,
                ElevatedButton(
                  onPressed: () => _register(context),
                  child: Text('Register'),
                ),
              ),
              SizedBox(height: 10),
              FadeAnimation(
                2.4,
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Already have an account? Log in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}
