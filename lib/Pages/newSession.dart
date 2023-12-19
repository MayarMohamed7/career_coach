import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:career_coach/models/Session.dart';

final formatter = DateFormat('dd-MM-yyyy');

class NewSession extends StatefulWidget {
  const NewSession({super.key});

  @override
  State<NewSession> createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSession> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  //final coach = FirebaseAuth.instance.currentUser!;

  void _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month,
        now.day); // to be able to choose date up to a year from now
    final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = picked!;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _saveSession() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('sessions').add({
        'price': _priceController.text,
        'date': DateFormat('dd-MM-yyyy').format(_selectedDate),
        'time': selectedTime.format(context),
        'coachId': FirebaseAuth.instance.currentUser!.uid,
        'status': 'available'
      });
      // Clear the input fields
      _priceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Session Details'),
        backgroundColor: Color(0xff0f4f6c),
      ),
      body: SingleChildScrollView(
        // Makes the form scrollable
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Enter price',
                  prefixText: '\$',
                  border: OutlineInputBorder(), // Adds border
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${formatter.format(_selectedDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: _selectDate,
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Time: ${selectedTime.format(context)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: _selectTime,
                    icon: Icon(Icons.access_time),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSession,
                child: const Text('Save Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0f4f6c),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
