import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:career_coach/models/Session.dart';

final formatter = DateFormat.yMd();

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

  void _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
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
      });
      // Clear the input fields
      _priceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Session Details')),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Enter price',
                prefixText: '\$',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Text(_selectedDate == null
                ? 'No date Selected'
                : formatter
                    .format(_selectedDate!)), //! means vlue never be null
            IconButton(
              onPressed: _selectDate,
              icon: const Icon(
                Icons.calendar_month,
              ), // Icon
            ),

            Text("Time: ${selectedTime.format(context)}"),
            IconButton(
              onPressed: _selectTime,
              icon: const Icon(
                Icons.access_alarm,
              ), // Icon
            ),
            ElevatedButton(
              onPressed: _selectTime,
              child: const Text('Save Session'),
            ),
          ],
        ),
      ),
    );
  }
}
