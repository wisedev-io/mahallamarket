import 'package:flutter/material.dart';
import 'package:mahallamarket/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  bool _isOtpSent = false;

  void _sendOtp() async {
    try {
      await _authService.signInWithPhone(
        _phoneController.text,
        (verificationId) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _verifyOtp() async {
    try {
      await _authService.verifyOtp(_verificationId!, _otpController.text);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MahallaMarket Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number (e.g., +1234567890)'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'Enter OTP'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
              child: Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}