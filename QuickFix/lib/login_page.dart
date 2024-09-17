import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:QuickFix/pages/home.dart';
import 'package:QuickFix/register_page.dart';
import 'package:QuickFix/animation/FadeAnimation.dart'; // Import the FadeAnimation class

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _rememberMe = false; // To remember the login

  @override
  void initState() {
    super.initState();
    _loadRememberMe(); // Load remember me preference on startup
  }

  // Load remember me preference from local storage
  void _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  // Save remember me preference to local storage
  void _saveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('password', _passwordController.text.trim());
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              FadeAnimation(
                1,
                Image.asset(
                  'assets/img/login_illustration.png', // Update this to the correct path of your image
                  height: 150,
                  width: 600,
                ),
              ),
              SizedBox(height: 40),
              FadeAnimation(
                1.2,
                Text(
                  'Login with',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                1.4,
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email';
                    } else if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                1.6,
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                1.8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text('Remember Me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _resetPassword(context);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                2,
                ElevatedButton(
                  onPressed: () {
                    _signInWithEmailAndPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Background color
                    minimumSize:
                        Size(double.infinity, 60), // Full width and 60px height
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                2.2,
                Text('Or, sign up with'),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                2.4,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/img/facebook.png',
                          height: 25,
                          width: 25,
                        ),
                        iconSize: 10,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/img/google.png',
                          height: 25,
                          width: 25,
                        ),
                        iconSize: 10,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/img/apple.png',
                          height: 25,
                          width: 25,
                        ),
                        iconSize: 10,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                2.6,
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()));
                  },
                  child: Text(
                    "Don't Have Account? Register",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          // Save remember me preference
          _saveRememberMe();

          // Check if the user is admin

          // For other users, navigate to HomePage or any other page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle login errors here
        String errorMessage = 'Login failed';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address format.';
        }
        // Show error message in a popup dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Error'),
              content: Text(errorMessage),
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
      } catch (e) {
        // General error handling
        print('Login failed: $e');
        // Show a generic error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Error'),
              content:
                  Text('An unexpected error occurred. Please try again later.'),
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
    }
  }

  void _resetPassword(BuildContext context) async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset Password Error'),
            content: Text(
                'Please enter a valid email address to reset your password.'),
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
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset Password'),
            content: Text(
                'Password reset email has been sent to ${_emailController.text.trim()}.'),
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
    } catch (e) {
      print('Failed to send password reset email: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset Password Error'),
            content: Text(
                'Failed to send password reset email. Please try again later.'),
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
  }
}
