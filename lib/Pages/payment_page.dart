import 'package:career_coach/Pages/Otp_screenPage.dart';
import 'package:career_coach/models/Session.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String sessionId;
  final String coachName;

  const PaymentPage(
      {Key? key, required this.sessionId, required this.coachName})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  void _showOTPDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'OTP'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: const Text('Payment Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: cardHolderNameController,
                decoration: const InputDecoration(labelText: 'Cardholder Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Card Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryMonthController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Expiry Month'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid expiry month';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: expiryYearController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Expiry Year'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid expiry year';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CVV'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid CVV';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Navigate to the OTP screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OTPScreen(
                              sessionId: widget.sessionId,
                              coachName: widget.coachName)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0f4f6c),
                    foregroundColor: Colors.white),
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
