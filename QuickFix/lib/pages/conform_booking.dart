import 'package:flutter/material.dart';
import 'package:QuickFix/animation/FadeAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:QuickFix/pages/home.dart';

class ConfirmBookingPage extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedTime;
  final String repeatOption;
  final List<int> extraCleaning;
  final List<String> selectedRooms;

  const ConfirmBookingPage({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.repeatOption,
    required this.extraCleaning,
    required this.selectedRooms,
  }) : super(key: key);

  @override
  _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedPackage = 'General';
  double _hours = 1;
  List<String> _selectedExtraServices = [];

  final List<String> _packages = ['General', 'Gas Recharge'];
  final List<String> _extraServices = ['Organizing', 'Cooking', 'Wash'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            FadeAnimation(
              1,
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Receiver Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1.2,
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixText: '+88 ',
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1.4,
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.location_on),
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1.6,
              Text(
                'Package Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _packages.map((package) {
                return ChoiceChip(
                  label: Text(package),
                  selected: _selectedPackage == package,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPackage = package;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1.8,
              Text(
                'Hours',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Slider(
              value: _hours,
              min: 1,
              max: 4,
              divisions: 3,
              label: '$_hours hours',
              onChanged: (value) {
                setState(() {
                  _hours = value;
                });
              },
            ),
            SizedBox(height: 20),
            FadeAnimation(
              2,
              Text(
                'Extra Service',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              spacing: 10,
              children: _extraServices.map((service) {
                return FilterChip(
                  label: Text(service),
                  selected: _selectedExtraServices.contains(service),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedExtraServices.add(service);
                      } else {
                        _selectedExtraServices.remove(service);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Get the current user's email
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('Booking_list')
                          .add({
                        'Receiver Name': _nameController.text,
                        'Phone Number': _phoneController.text,
                        'Location': _locationController.text,
                        'Selected Package': _selectedPackage,
                        'Selected Hours': _hours,
                        'Selected Extra Services': _selectedExtraServices,
                        'Selected Rooms': widget.selectedRooms,
                        'Selected Date': widget.selectedDate,
                        'Selected Time': widget.selectedTime,
                        'Repeat Option': widget.repeatOption,
                        'User Email': user.email,
                      });

                      // Show a confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking confirmed and saved!')),
                      );

                      // Navigate to the homepage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage()), // Replace HomePage with your actual homepage widget
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to confirm booking: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No user is currently logged in')),
                    );
                  }
                },
                child: Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
